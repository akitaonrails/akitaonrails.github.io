---
title: Omarchy 2.0 - LazyVim - LazyExtras
date: "2025-09-07T16:00:00-03:00"
slug: omarchy-2-0-lazyvim-lazyextras
tags:
  - arch
  - omarchy
  - lazyvim
  - lazyextras
draft: false
---

Continuando meus posts de dicas sobre [Omarchy](https://akitaonrails.com/tags/omarchy/) resolvi postar sobre [LazyVim](https://www.lazyvim.org/) que já vem pré-instalado.

![LazyVim](https://user-images.githubusercontent.com/292349/213447056-92290767-ea16-430c-8727-ce994c93e9cc.png)

Mesmo se não usa Omarchy, recomendo [instalar](https://www.lazyvim.org/installation) LazyVim, só fazer isso:

```
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

git clone https://github.com/LazyVim/starter ~/.config/nvim

rm -rf ~/.config/nvim/.git

nvim
```

Pronto, é só isso. NeoVim, pra quem não sabe, é um fork mais moderno do antigo Vim (por isso o comando é `nvim`, reservando `vim` pro antigo). Ele troca o antigo VimScripts por scripts em Lua e tem várias otimizações e funcionalidades de qualidade de vida melhores. Hoje em dia, não tem porque usar o Vim antigo mais.

Usando Lua dá pra configurar o Nvim como quiser. Mas dá muito trabalho configurar tudo do zero. É um bom exercício, mas sendo prático, não compensa pro dia a dia. É melhor instalar um setup pré-configurado como os antigos [LunarVim](https://www.lunarvim.org/) que eu usava antes e até recomendei em alguns videos de Linux do meu canal, ou o [AstroNvim](https://astronvim.com/) ou o **LazyVim** que atualmente é meu favorito. Qualquer um deles é um bom começo e vai ser preferência pessoal qual vai escolher.

Cada plugin que eles instalam tem diversas funcionalidades e combinações de teclas (hotkeys) próprias que precisa ler na documentação pra saber o que faz o que. Recomendo ir na seção [plugins](https://www.lazyvim.org/plugins) do site oficial e ler um por um. Tem muita coisa que você nem espera e todos são muito úteis.

LazyVim sozinho já ajuda bastante porque ele abre pop-ups documentando algumas das hotkeys. Por exemplo, o que se chama de comando **Leader** em LazyVim é a "barra de espaço". Quando apertar, vai aparecer esse menu de contexto:

![Leader context menu](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-07_15-44-17.png)

A partir daqui, se digitar, digamos "b", vai aparece outro menu de contexto:

![Buffer context menu](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-07_15-46-48.png)

E se digitar "b" de novo, ele vai trocar pro próximo arquivo já aberto no Buffer. **Buffer** é o nome em Vim onde ficam os arquivos já abertos. Deletar do Buffer é o equivalente a "fechar o arquivo".

Da próxima vez, não precisa olhar os menus, só digitar rápido de uma só vez: "Espaço+b+b". E é assim que você vai decorando os comandos que mais usa.

Alguns comandos que vale a pena já saber são: **Espaço+Espaço"** (duas vezes), e vai abrir o menu que abre arquivos. digite algumas letras do nome do arquivo e vai filtrando dinamicamente:

![find files](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-07_15-49-35.png)

Ou então "Espaço+e" pra abrir o Explorer NeoTree. Digite "?" pra abrir um popup com os comandos que pode usar pra criar novos sub-diretórios ou arquivos no subdiretório:

![NeoTree](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-07_15-51-08.png)

Quando aprender os demais comandos e plugins, vai notar que nem precisa abrir NeoTree, ele é mais pra quando quiser explorar visualmente mesmo. Mas pro dia a dia comando como ":e" devem ser suficiente. Aliás, ":" (dois pontos) é o comando pra executar funções do NeoVim. Por exemplo ":q" é quit, ou ":w" é write e ":wq" é write e quit ao mesmo tempo.

Se quiser aprender mais a fundo sobre NeoVim, recomendo o canal do YouTube do camarada [Eustáquio Rangel](https://www.youtube.com/@EustaquioRangel) que é veterano de Linux, Rails e Vim e ele ensina NeoVim do zero (sem LazyVim).

![TaQ](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-07_16-09-53.png)

Agora, digamos que já aprendeu o básico de NeoVim e LazyVim, e agora quer começar a mexer nos seus projetos de PHP, Java, C#, Ruby, Python ou o que for. Vai notar que o LazyVim não tem nenhuma funcionalidade pra nenhuma delas.

O que fazer agora? Instalar VS Code?? **NÃO!!**

Isso porque você não executou [:LazyExtras](https://www.lazyvim.org/extras).

![LazyExtras command](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-07_15-35-36.png)

Digite exatamente assim e veja isto:

![Enabled Plugins](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-07_15-36-01.png)

Essa janela parece complicada mas é só uma lista de plugins dividida em seções. No começo aparecem os plugins já instalados e habilitados. Caso não queira algum deles, basta usar as setas pra descer o cursor até uma delas e apertar "x" pra desmarcar. Mas deixe essa seção como está. Vamos descer até a seção de "Languages":

![Languages section](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-07_15-36-43.png)

É nesta seção que estão todas as linguagens que você pode habilitar o suporte. Basta descer com as setas e ir marcando com "x" quais quer instalar. E tem de tudo, desde Angular, Vue, Erlang, Elixir, Rust, Zig, Haskell e muito mais.

Ao lado de cada linguagem tem o grupo de plugins individuais que ele vai instalar. Pra saber o que cada uma faz, digite o nome delas no Google e ache a página com a documentação, onde vai ter hotkeys e configurações extras que pode fazer.

Com isso vai ganhar coisas como Linters, syntax highlighting, LSP, snippets e muito mais.

E se quiser instalar plugins a mais que não tem listado, dá pra adicionar manualmente. Leia a seção de [Adding Plugins](https://www.lazyvim.org/configuration/plugins#-adding-plugins) na documentação.

![Linter](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-07_16-05-15.png)

LazyVim + LazyExtras é 90% de tudo que precisa pro seu dia a dia de desenvolvimento de software. É mais leve e mais rápido que um VS Code, usando muito menos memória e vai ser muito melhor especialmente em máquinas mais antigas. Não tenha preguiça de aprender Vim, um programador de verdade não deveria ficar num VS Code só porque tem preguiça de aprender hotkeys extras.
