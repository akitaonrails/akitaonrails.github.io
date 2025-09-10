---
title: Instalando Grafana no meu Home Server
date: "2025-09-10T16:00:00-03:00"
slug: instalando-grafana-no-meu-home-server
tags:
  - homeserver
  - grafana
  - prometheus
  - cadvisor
  - docker
draft: false
---

Este post é pra continuar complementando minha [série sobre meu Home Server](/tags/homeserver), de novo, pra servir de anotação pra mim mesmo no futuro. Como já expliquei, meu home server é um mini-PC Intel NUC que eu só acesso com SSH. Então eu queria uma forma de monitorar o uso dos recursos do sistema sem ter que manualmente logar via SSH e abrir BTOP ou NTOP.

Fiquei com preguiça de instalar Grafana na época, mas resolvi fazer isso agora, e foi bem mais fácil do que eu esperava, por isso resolvi compartilhar como fiz.

A idéia é subir [cAdvisor](https://github.com/google/cadvisor) que faz monitoramento de recursos de containers e [Prometheus](https://github.com/prometheus/prometheus) que faz scraping de dados de recursos do sistema e consolidar os dados dos dois no [Grafana](https://grafana.com/) que é uma aplicação web que permite montar dashboards gráficos pra monitorar seus sistemas. Se fizer direito, no final vai ter uma tela assim:

![Grafana Dashboard](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250910155108_screenshot-2025-09-10_15-50-49.png)

### Instalação

Pra subir no meu home server é muito simples, eu faço tudo com Docker Compose, então:

```yaml
# monitor-docker-compose.yml
networks:
  monitoring:
    driver: bridge

volumes:
  prometheus_data:
  grafana_data:

services:
  node-exporter:
    image: quay.io/prometheus/node-exporter:latest
    command:
      - --path.rootfs=/host
    pid: host
    restart: unless-stopped
    networks: [monitoring]
    volumes:
      - /:/host:ro,rslave
    security_opt: ["no-new-privileges:true"]
    read_only: true

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    restart: unless-stopped
    networks: [monitoring]
    ports: ["8080:8080"]   # optional: expose UI locally
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /dev/disk/:/dev/disk:ro
    security_opt: ["no-new-privileges:true"]
    read_only: true

  prometheus:
    image: prom/prometheus:latest
    restart: unless-stopped
    networks: [monitoring]
    volumes:
      - prometheus_data:/prometheus
      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
    command:
      - --config.file=/etc/prometheus/prometheus.yml
      - --storage.tsdb.path=/prometheus
      - --storage.tsdb.retention.time=30d
      - --web.enable-lifecycle
    ports: ["9090:9090"]
    security_opt: ["no-new-privileges:true"]
    read_only: true

  grafana:
    image: grafana/grafana:latest
    restart: unless-stopped
    networks: [monitoring]
    depends_on: [prometheus]
    ports: ["3001:3000"]
    environment:
      GF_SECURITY_ADMIN_USER: admin
      GF_SECURITY_ADMIN_PASSWORD: change-me
      GF_USERS_ALLOW_SIGN_UP: "false"
    volumes:
      - grafana_data:/var/lib/grafana
      - ./provisioning/datasources:/etc/grafana/provisioning/datasources:ro
    security_opt: ["no-new-privileges:true"]
```

Tem que prestar atenção nos mapeamentos de diretório local. Se colocar `/etc/grafana/prometheus.yml` por exemplo, tem que mudar esta linha:

```yaml
...
    volumes:
      - prometheus_data:/prometheus
      - /etc/grafana/prometheus.yml:/etc/prometheus/prometheus.yml:ro
...
```

Falando nele, eis o `prometheus.yml`:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs: [{ targets: ['prometheus:9090'] }]

  - job_name: 'node'
    static_configs: [{ targets: ['node-exporter:9100'] }]

  - job_name: 'cadvisor'
    static_configs: [{ targets: ['cadvisor:8080'] }]
```

Finalmente `/etc/grafana/provisioning/datasources/datasource.yaml`:

```
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
```

Cuidado também com mapeamento de portas, o recomendado é fazer assim:

```yaml
ports: ["127.0.0.1:8080:8080"]
```

Isso porque cAdvisor e Prometheus só precisam estar acessíveis pro Grafana, dentro do home server, mas não tem porque dar bind em `0.0.0.0` e estar acessível pra fora do servidor. Aí é mais uma escolha. Como eu estou numa LAN caseira, e não tem túneis apontando pra esses serviços, pra mim tanto faz.

Se por acaso, como eu, também já tiver algum serviço pendurado na porta 8080, o cAdvisor vai falhar. Nesse caso remapeie as portas e reconfigure o Prometheus, ou só tire a linha de porta. Não precisa ter o cAdvisor exposto pra fora.

Outro detalhe é que por padrão Grafana sobe an porta 3000 mas eu mudei pra 3001 porque já tinha outro serviço nessa porta. Então, quando subir, eu posso acessar via `http://192.168.0.200:3001`.

Como expliquei no [artigo de Cloudflared](https://akitaonrails.com/2025/09/09/acessando-meu-home-server-com-dominio-de-verdade/) eu roteio esse endereço pro Cloudflare pra ter um domínio bonito como `https://grafana.fabioakita.dev` pra acessar tanto localmente quanto remotamente, se quiser. Depois leiam esses outros artigos pra entender como.

E pronto, agora é só subir os containers:

```bash
docker compose -f monitor-docker-compose.yml up -d
```

E acabou, super simples, eu deveria ter feito isso antes.

Como podem ver arquivo de Docker Compose, quando entrar no site pela primeira vez, o login vai ser com `admin` senha `change-me`, obviamente, a primeira coisa a fazer é trocar a senha:

![Admin Password](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250910160042_screenshot-2025-09-10_16-00-31.png)

### Dashboards

Agora praticamente acabou. Podemos checar se o Prometheus está funcionando e integrado. Basta ir no menu "Connections" e "Data Sources":

![Data Sources](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250910160151_screenshot-2025-09-10_16-01-40.png)

Grafana consegue consolidar dados de dezenas de fontes diferentes, Prometheus é só um deles. Em uma infra maior e mais complicada, essa lista estaria enorme.

Pra montar Dashboards, dá pra ir do zero e montar manualmente widget a widget, mas é mais fácil importar dashboards que já existem. Pra isso é só clicar na lupa lá no topo, na caixa de procura e escoher a opção "Import dashboards":

![import dashboards menu](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250910160509_screenshot-2025-09-10_16-04-59.png)

Nessa página dá pra ou importar um arquivo JSON, ou copiar e colocar o JSON ou pesquisar pelo ID que já existe cadastrado no site grafana.com:

![import by ID](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250910160603_screenshot-2025-09-10_16-05-46.png)

De cara, eu aprendi que existem 3 IDs que são úteis pra mim:

- **1860 - Node Exporter Full** - que é a foto de tela que está no começo deste artigo e tem várias métricas do sistema como CPU, memória, disco, rede, etc. É o mais útil pra mim.
- **13484 - Docker/cAdvisor Exporter** - que são as métricas de CPU, memória, mas dividido por cada container rodando no servidor.
- **3662 - Prometheus 2.0 overview** - que é um resumo geral de saúde

Se gostar desses ou de outros dashboard, depois é só favoritar com um "pin" e pronto.

Por exemplo, este é o dashboard do cAdvisor:

![cAdvisor dashboard](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250910160927_screenshot-2025-09-10_16-09-13.png)

Eu ainda não explorei outros dashboards. Se tiver recomendações de IDs pra dar import, não deixe de mandar nos comentários abaixo!

Com isso eu tenho uma visão rápida e bonita do uso de recursos do meu home server e consigo ver rapidamente se tem algo de estranho acontecendo. Não parece que esses serviços consumam muitos recursos então posso deixar rodando junto com os demais containers.
