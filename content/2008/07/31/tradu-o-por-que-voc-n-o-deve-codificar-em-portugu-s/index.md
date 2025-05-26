---
title: 'Tradução: Por que você não deve codificar em Português'
date: '2008-07-31T16:41:00-03:00'
slug: tradu-o-por-que-voc-n-o-deve-codificar-em-portugu-s
tags:
- career
- translation
draft: false
---

Achei esse artigo interessante, o título original é [Why you shouldn’t code in Spanish](http://www.codespanish.com/archives/softwaredevelopment/43). E como o autor mesmo fala, a parte engraçada é que ele publicou esse artigo no site chamado [CodeSpanish](http://www.codespanish.com). Eu coloquei “Português” no título porque senão ninguém iria ler :-) Mas vou traduzir o artigo original. Seja português, seja espanhol, a noção é a mesma, então lá vai:

[![](http://s3.amazonaws.com/akitaonrails/files/america-790957.jpg)](http://www.akitaonrails.com/2007/4/14/off-topic-seja-arrogante)


### Por que você não deve codificar em Espanhol.

Na realidade eu promovo a tradução de software para Espanhol e outras linguagens. Quando digo que você não deveria codificar em Espanhol quero dizer que não deve usar Espanhol ou qualquer outra língua que não seja Inglês como nomes de variáveis, nomes de arquivos, nomes de funções, etc. Linguagens de Programação, linguagens de script, comandos de sistema operacional, etc, são todos baseados na língua Inglesa. Então, por que você faria diferente no seu código?

Pegue por exemplo este código em PHP do post [Construindo um forum em PHP e MySQL](http://www.codespanish.com/archives/softwaredevelopment/30)

* * *
php

require(’funciones.php’);  
$id = $_GET[“id”];  
$citar = $GET[“citar”];  
$row = array(”id” =\> $id);  
if($citar==1)  
{  
 require(’configuracion.php’);  
 $sql = “SELECT titulo, mensaje, identificador AS id “;  
 $sql.= “FROM foro WHERE id=’$id’”;  
 $rs = mysql\_query($sql, $con);  
 if(mysql\_num\_rows($rs)==1) $row = mysqlfetch_ assoc($rs);  
 $row[“titulo”] = “Re: “.$row[“titulo”];  
 $row[“mensaje”] = “[citar]“.$row[“mensaje”].”[/citar]“;  
 if($row[“id”]==0) $row[“id”]=$id;  
}  
$template = implode(”", file(’formulario.html’));  
include(’header.html’);  
mostrarTemplate($template, $row);  
include(’footer.html’);  
-

Algumas palavras podem ser familiares para pessoas que entendem inglês já que têm pronúncias similares em inglês, por exemplo: _configuracion_ é _configuration_, mas e _mostrarTemplate_? Mesmo _formulario_ dará dores de cabeça a mais de um programador que não saiba Espanhol.

Você também tem que considerar que muitos programadores nem mesmo falam Inglês. Eles podem falar línguas que sequer tem raízes em Latin, para eles já é difícil o suficiente interpretar funções em Inglês como require, echo, etc. Você consegue imaginar um desenvolvedor Chinês tentando entender seu código em Espanhol? Escrever seu código em Inglês é crítico quando se quer trabalhar em um projeto Open Source.

Minha visão é que código deve ser escrito em Inglês: nomes de variáveis, nomes de funções, nomes de classe, campos de dados, etc. Quando digo código, também estou falando de bancos de dados. Existem exceções, objetos nomeados em inglês poderiam ser um problema se o usuário final tiver acesso livre para gerar relatórios, exportar dados, etc.

Não é difícil escrever seu código em Inglês. Use dicionários Espanhol/Ingles (_Sua Língua_/Inglês – eu recomendo [Word Reference](http://www.wordreference.com/)). Não entre em pânico, não é para escrever como Shakespeare, gramática não é necessária. Por exemplo, no código acima, _mostrarTemplate_ poderia ser facilmente modificado para _showTemplate_.

Mesmo que você não tenha intenções de fazer outsourcing, compartilhar ou vender seu código, ter funções em Espanhol misturado com funções nativas de uma linguagem de programação em particular é uma **má prática** que pode levar a confusões e duplicação de código. Por exemplo, alguém poderia escrever uma função _obtenerVariable_ (obtener significa ‘obter’, em Espanhol), quando já existe uma função chamada _getVariable_ incluso na biblioteca padrão. Se tivesse escrito seu código em inglês e duplicado a função _getVariable_ por engano, é bem possível que o compilador ou interpretador o avisasse. Isso não aconteceria se misturar línguas humanas no seu código.

E sobre comentários dentro de seu código? Embora seja desafiador para muitos que não falam inglês, a realidade é que a maioria dos comentários normalmente tem uma ou duas sentenças. Como disse antes, não é sobre escrever Inglês perfeito. Existem diversas ferramentas que podem ajudá-lo a traduzir sentenças simples. [Free Translation](http://freetranslation.com/) é um dos meus favoritos. Mas saiba que essas ferramentas não são 100% perfeitas, traduções de línguas humanas ainda não foram vencidas. Se precisar traduzir um manual, o conteúdo de um website ou as mensagens mostradas ao usuários, por favor, contrate um tradutor profissional.

Não me entenda mal, sou um forte defensor da minha língua materna, Espanhol, mas não sou um idiota. No mundo de hoje, uma empresa estrangeira poderia chegar em você para comprar os direitos do seu produto a qualquer momento. Por exemplo, ano passado o Google comprou o [Panoramio](http://www.panoramio.com/), uma empresa fundada pelo Espanhol [Eduardo Manchón](http://www.codespanish.com/archives/profiles/34). Se seu código for ruim para quem não fala Espanhol, será mais difícil de terceirizar sua manutenção (você estará limitado a programadores que falam espanhóis). Esse último ponto poderia ser tópico de discussão com investidores internacionais.

Goste ou não, Inglês é o Esperanto da tecnologia e dos negócios dos tempos modernos. Você deveria escrever seu código em Inglês.

**Nota do Akita:** novamente, sou um [antigo defensor](http://www.akitaonrails.com/2007/4/14/off-topic-seja-arrogante) da melhoria da educação pessoal de cada profissional. Cada um é responsável por sua própria capacitação, e ninguém mais. Como disse o autor, aprender – e realmente usar – inglês diariamente não é uma opção, é uma obrigação.

Anos atrás, muitos desenvolvedores reclamaram do código fonte do Ruby porque muita coisa estava documentada em Japonês (!) Imagino que isso deva ter sido um dos motivos que dificulta revoluções maiores no interpretador e a busca por novas alternativas.

Outro caso notório é da SAP, com sua linguagem ABAP/4. Provavelmente, 30 anos atrás, os alemães não imaginavam que seu software seria usado no mundo todo. Veja este [pequeno trecho](http://www.abapcode.info/2007/05/purchase-order-history-mass-display.html) de código ABAP:

* * *
abap

IF SUDATE = ‘X’.  
SORT ITAB BY UDATE EKKEY-EBELN CHANGENR EKKEY-EBELP  
EKKEY-ETENR.  
ELSEIF SNAME = ‘X’.  
SORT ITAB BY USERNAME EKKEY-EBELN CHANGENR EKKEY-EBELP  
EKKEY-ETENR.  
ELSE.  
SORT ITAB BY EKKEY-EBELN CHANGENR EKKEY-EBELP EKKEY-ETENR.  
ENDIF.  
-

EKKEY, EBELN, EBELP … consultores SAP se acostumam depois de algum tempo, mas tudo isso são acrônimos – que já é ruim – de palavras em alemão! Não é pouco: estamos falando de centenas de milhares de acrônimos como esses, para cada tipo de campo, objeto, tabela em cada módulo empresarial de um pacote que atende Fortune 500. Boa sorte lendo um código desses. ABAP por definição não é a linguagem mais visualmente agradável de se trabalhar, junte a isso diversos nomes de variáveis, tabelas, funções, APIs, tudo em Alemão. Pior: com comentários de código em alemão! Você não precisa compilar nem nada: o código já é naturalmente obfuscado.

Portanto, façam um favor a todos: escrevam nomes em inglês. Não se trata de nacionalismo, idealismo, ou qualquer coisa assim. Isso é puro pragmatismo.

