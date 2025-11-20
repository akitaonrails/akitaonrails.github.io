---
title: Omarchy - Não entrar em Sleep enquanto Copia
date: "2025-11-20T14:00:00-03:00"
slug: omarchy-no-sleep-on-copy
tags:
  - omarchy
  - sleep
  - systemd-inhibit
  - archlinux
draft: false
---
Esta dica não é específica de Omarchy mas de Linux em geral, mas coloquei na categoria de Omarchy só pra ficar consistente no meu blog.

### Introdução

Quando eu me afasto do meu PC, o Hyprland vai usar as configurações em `~/.config/hypr/hypridle.conf` pra saber em que timeout desligar o monitor e depois, quando colocar meu PC pra dormir (sleep). Podemos configurar o tempo que quisermos lá, como 10 min pra apagar a tela, 20 min sem atividade pra dormir.

Se tiver algum app que queira fazer alguma manutenção em background que demore mais que isso pra terminar, ele pode sinalizar pro sistema não dormir. Dá pra ver quais apps fazem isso usando o comando `systemd-inhibit --list`:

![inhibit list](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20251120140935_screenshot-2025-11-20_14-09-09.png)

### O Problema

Vira e mexe eu deixo copiando grandes quantidades de arquivos, por exemplo, do meu NAS pra um micro SD Card. Pode levar mais de 1 hora fácil (minhas cópias de ROMs pra emuladores):

![copiando usb](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20251120141114_screenshot-2025-11-20_13-50-46.png)

O problema é que antes disso o `hypridle` vai entrar em ação e colocar meu PC pra dormir, pausando essa cópia. E normalmente eu queria deixar copiando, ir dormir, e estar pronto quando acordar. Só que sempre esqueço disso e quando acordo ainda não terminou. Bem inconveniente. Não sei porque o Nautilus já não sinaliza pra inibir sleep quando tem atividades assim acontecendo.

Pode ser que tenha alguma configuração de `gsettings` que eu não saiba? (se tiver algo assim, não deixem de mandar nos comentários).

### A Solução

Enquanto não descubro algo melhor, só tem uma solução: ficar fazendo polling de `iostat` pra manualmente inibir.

Pra começar precisamos instalar estes dois pacotes no Arch:

```
sudo pacman -S sysstat bc
```

Agora, criar um script que cheque, vamos chamar de `~/.local/bin/io_inhibit.sh`:

```bash
#!/bin/bash

# --- Configuration ---
# UTIL_THRESHOLD: Percentage of time the device is busy (%util) that must be exceeded to inhibit sleep.
# 10.0% is a safe low threshold to catch any continuous I/O.
UTIL_THRESHOLD=10.0

# CHECK_INTERVAL: How often (in seconds) to check I/O activity.
CHECK_INTERVAL=5

# File to track the PID of the systemd-inhibit process.
PID_FILE="/tmp/io_inhibit_pid"

# --- Functions ---

# Function to check if the inhibit process is currently running
is_inhibitor_running() {
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
        return 0 # True
    else
        return 1 # False
    fi
}

# Function to get the maximum I/O utilization (%util) across all monitored devices
get_max_io_util() {
    # We use -x (extended stats) and monitor all devices.
    # The 'awk' script finds the column index for '%util' dynamically.
    iostat -x 1 2 | awk '
        BEGIN { max_util = 0.0; f = 0; util_col = 0; }
        
        # 1. Look for the header line (contains 'r/s' and 'util'). Set flag (f) to start processing.
        #    We only do this check in the second block.
        /avg-cpu:/ { if (f == 0) f = 1; else if (f == 1) f = 2; next }

        # 2. In the second block (f == 2), check for the header line to map columns
        (f == 2 && $1 == "Device") {
            # Find the column index for the "%util" header
            for (i=1; i<=NF; i++) {
                if ($i == "%util") {
                    util_col = i;
                    break;
                }
            }
            # Skip the header line after mapping
            next
        }

        # 3. Process data lines only after the column has been mapped
        (f == 2 && util_col > 0) { 
            # Match lines starting with a common device prefix
            if ($1 ~ /^(sd|nvme|loop|hd|dm|zram|mmc)/) {
                # Use the dynamically found column index
                util = $(util_col);
                if (util > max_util) {
                    max_util = util;
                }
            }
        }
        END { print max_util; }
    '
}

# --- Main Loop ---

while true; do
    # 1. Get current I/O activity
    MAX_UTIL=$(get_max_io_util)
    
    # Use 'bc' for floating-point comparison
    if (( $(echo "$MAX_UTIL > $UTIL_THRESHOLD" | bc -l) )); then
        
        # I/O is active and exceeds the %util threshold
        if ! is_inhibitor_running; then
            setsid systemd-inhibit --what=idle:sleep --why='Active I/O Detected (%util)' --mode=block sleep infinity &
            echo $! > "$PID_FILE"
        fi
        
    else
        
        # I/O is idle or below threshold
        if is_inhibitor_running; then
            kill $(cat "$PID_FILE") 2>/dev/null
            rm "$PID_FILE"
        fi
        
    fi

    # Wait before checking again
    sleep $CHECK_INTERVAL 
done
```

(sim, este script foi vibe coded e precisei ajustar algumas vezes até funcionar, as versões que o Gemini me dava não funcionavam kkkk).

O principal é o `awk` processando a saída do comando `iostat -x 1 2`. Meu micro SD card aparece como `/dev/sda`:

![iostat](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20251120141644_screenshot-2025-11-20_14-16-36.png)

Note que no segundo bloco, quando estou copiando vários arquivos, ele mostra 99.61 e fica variando entre 90 a 100% de uso, que é o desejável: significa que está usando toda a banda disponível de IO pra ele.

Então, queremos que, enquanto estiver numa taxa acima de zero, tipo, maior que 10% de atividade, o HyprIdle não ative o sleep no timeout normal.

Com esse script, agora temos o seguinte quando listamos `systemd-inhibit --list`:

![sleep infinity](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20251120141859_screenshot-2025-11-20_14-18-48.png)

Agora apareceu uma nova linha dizendo:

- `sleep infinity`: Este é o nome do processo que iniciou meu script e segura o lock.

- `sleep:idle`: Esta é a parte crucial. Diz ao systemd e logind pra bloquear tanto sleep (system suspend) quanto idle (prevenindo timers de idle como do hypridle).

- `Active I/O Detected (%util)`: Esta é a razão especificada no script.

E pronto, pra garantir que temos este script sempre rodando, basta alterar o `~/.config/hypr/autostart.conf` pra ter esta linha:

```
exec-once = /home/akitaonrails/.local/bin/io_inhibit.sh &
```

Em teoria, agora posso deixar essas atividades longas de IO rodando e não me preocupar do meu Arch suspender e dormir.

Alguém conhece alguma solução mais simples do que essa? Se tiver idéias, mandem nos comentários.

