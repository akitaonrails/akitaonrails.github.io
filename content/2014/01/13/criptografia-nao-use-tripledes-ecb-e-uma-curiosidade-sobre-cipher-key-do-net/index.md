---
title: "[Criptografia] Não use TripleDES/ECB - e uma curiosidade sobre Cipher Key
  do .Net"
date: '2014-01-13T13:01:00-02:00'
slug: criptografia-nao-use-tripledes-ecb-e-uma-curiosidade-sobre-cipher-key-do-net
tags:
- learning
- beginner
- security
draft: false
---

Recentemente num de nossos projetos tivemos que lidar com uma integração de dados vindo de um sistema feito em C#. Até aqui nenhum problema. O código que tivemos que usar como referência, vindo de um parceiro de nosso cliente, foi basicamente este:

```C
using System;
using System.Security.Cryptography;
using System.Text;

class Program
{
	public static void Main(String[] args) {
		Console.WriteLine(EncryptData("hello world"));
	}

	public static string EncryptData(string Message)
	{
	    byte[] Results;
	    System.Text.UTF8Encoding UTF8 = new System.Text.UTF8Encoding();
	    MD5CryptoServiceProvider HashProvider = new MD5CryptoServiceProvider();
	    byte[] TDESKey = HashProvider.ComputeHash(UTF8.GetBytes("abc123"));

	    TripleDESCryptoServiceProvider TDESAlgorithm = new TripleDESCryptoServiceProvider();
	    TDESAlgorithm.Key = TDESKey;
	    TDESAlgorithm.Mode = CipherMode.ECB;
	    TDESAlgorithm.Padding = PaddingMode.PKCS7;
	    byte[] DataToEncrypt = UTF8.GetBytes(Message);
	    try
	    {
	        ICryptoTransform Encryptor = TDESAlgorithm.CreateEncryptor();
	        Results = Encryptor.TransformFinalBlock(DataToEncrypt, 0, DataToEncrypt.Length);
	    }
	    finally
	    {                
	        TDESAlgorithm.Clear();
	        HashProvider.Clear();
	    }
	    return Convert.ToBase64String(Results);
	}
}
```

Não estou quebrando confidencialidade simplesmente porque este é um código publicamente conhecido disponível no site [CodeProject](http://www.codeproject.com/Tips/306620/Encryption-Decryption-Function-in-Net-using-MD5Cry), sob licença. [CPOL](http://www.codeproject.com/info/cpol10.aspx). O que eu vi foi uma cópia exata disso. Mas cuidado: grandes empresas, em grandes sistemas usados por milhões de pessoas usam código exatamente como este. (#MEDO)

O ponto de atenção é que este exemplo tenta ser o mais simples possível. Por isso ele escolhe [TripleDES](http://en.wikipedia.org/wiki/Triple_DES) - que é o DES aplicado 3 vezes pra cada bloco de dados -, um dos algoritmos mais antigos e mais simples, em vez de usar algo mais moderno como Rijndael/AES. Pior ainda, TripleDES não seria tão ruim se fosse usado no modo CBC em vez do modo ECB.

Falando em termos de leigo, a diferença é que o modo CBC (Cipher Block Chaining) exige o uso de um [Initialization Vector (IV)](http://bit.ly/1m2TCjI) além da chave de encriptação. Diferente da chave - que deve ser "secreta" - o IV pode ser público e transmitido remotamente. O modo CBC vai usar esses dois componentes para fazer transformações em cadeia nos dados, adicionando uma camada extra de segurança.

No modo ECB (Electronic Code Book) você só precisa da chave - e por isso todo mundo usa TripleDES em modo ECB para exemplos e tutoriais: porque é mais simples - e aqui vai uma crítica para tutoriais que simplificam demais sem explicar as implicações, especialmente de segurança (!). O modo ECB é considerado inseguro. 

Não sou um especialista em segurança, mas em termos leigos o mesmo dado passado pelo TripleDES com a mesma chave gera a mesma saída encriptada. Portanto se eu souber a entrada e saída de alguns dados, posso encontrar padrões que ajudem a decriptar outros dados, e impede o uso de [ataques baseados em dicionários](http://en.wikipedia.org/wiki/Dictionary_attack) e [rainbow tables](http://en.wikipedia.org/wiki/Rainbow_table). Como um IV novo é gerado para cada vez que encripto no modo CBC (*importante:* sempre gere um novo IV aleatoriamente - tem métodos pra isso, não reuse IVs), o mesmo dado de entrada não gera duas saída iguais, dificultando muito encontrar padrões que ajudem a quebrar outros dados. É a mesma razão de porque usamos ["salts"](http://bit.ly/JV5KHv) ao gerar digests de senhas antes de armazenar numa tabela de banco de dados. Esta resposta no [StackExchange](http://security.stackexchange.com/questions/6058/is-real-salt-the-same-as-initialization-vectors) descreve melhor.

Portanto, se possível, use um algoritmo decente como AES-256, como [neste exemplo](http://www.codeproject.com/Articles/662187/FIPS-Encryption-Algorithms-and-Implementation-of-A). E se for usar TripleDES, pelo menos evite ECB e vá para CBC, mesmo com o trabalho extra de precisar de um IV.

Aliás, se puder também evite MD5 ou SHA1 para gerar digests de senhas. Eles são algoritmos "rápidos", quebráveis com rainbow tables e força bruta. Por isso hoje usamos algoritmos que são computacionalmente "caros" (demorados) como [bcrypt](http://www.warmenhoven.co/2012/03/06/do-not-use-md5-or-sha1-to-simply-hash-db-passwords/). MD5 e SHA1 são bons pra checar integridade de um download, por exemplo, e isso tem que ser rápido. Mas para evitar força bruta, use um demorado para o digest de senhas.

## A Curiosidade: MD5 da Cipher Key (passphrase)

Como disse antes, independente da qualidade do código original, precisávamos fazer um em Ruby que gerasse o mesmo resultado. A "tradução" do código C# anterior em Ruby seria assim (versão simplificada):

```ruby
require 'rubygems'
require 'openssl'
require 'digest/md5'
require 'base64'

def encrypt_data(passphrase, message)
  cipher = OpenSSL::Cipher.new('des-ede3')
  cipher.encrypt
  cipher.key = Digest::MD5.digest(passphrase)
  Base64.encode64(cipher.update(message) + cipher.final)
end
```

É só isso mesmo. Vamos por partes.

* Não deixe de ler a [documentação do OpenSSL](http://ruby-doc.org/stdlib-2.1.0/libdoc/openssl/rdoc/OpenSSL.html), ele explica bem as coisas que vou dizer a seguir.
* Pra escolher TripleDES em modo ECB basta instanciar com "des-ede3", pra ser CBC seria "des-ede3-cbc" ou apenas "des3" (alias)
* Por padrão o padding é [PKCS7](http://ruby-doc.org/stdlib-2.1.0/libdoc/openssl/rdoc/OpenSSL/PKCS7.html), então não precisa especificar.
* Sempre chame o método <tt>#encrypt</tt> antes de configurar a chave.
* Para pegar o resultado precisa chamar o método <tt>#update</tt> antes e concatenar com <tt>#final</tt>.
* Passamos o resultado por Base64 porque ele é binário, se quisermos uma string precisa converter.

Se tentar rodar este método ele vai dar o seguinte problema:

```
> encrypt_data("abc123", "hello world")
OpenSSL::Cipher::CipherError: key length too short
	from (irb):17:in `key='
	from (irb):17:in `encrypt_data'
```

Se passar a mesma cipher key e mensagem pra versão .Net ele vai funcionar. Esta é a curiosidade:

* Tanto a implementação .Net quanto Ruby esperam por padrão uma chave de 24-bytes (192-bits)
* Todo digest MD5 tem 16-bytes de tamanho (128-bits)

No caso do Ruby, como estou passando uma chave menor que o padrão, ele estoura com o erro acima. Já o .Net faz outra coisa: ele acrescenta os 8-bytes que faltam. O problema é com o que.

Especificamente no .Net ele complementa os 8-bytes restantes com os 8-bytes iniciais do que é passado. Se fosse plain-text, por exemplo, e a chave passada fosse "1111111122222222", internamente ele converteria para "111111112222222211111111". Isso é dependente de implementação, no caso de PHP, se não estou enganado, ele complementa os 8-bytes restantes com nulo ou zero.

Por isso, pro método em Ruby ficar correto, precisamos fazer assim:

```ruby
require 'rubygems'
require 'openssl'
require 'digest/md5'
require 'base64'

def encrypt_data(passphrase, message)
  digest = Digest::MD5.digest(passphrase)
  cipher = OpenSSL::Cipher.new('des-ede3')
  cipher.encrypt
  cipher.key = digest + digest[0..7] # <= eis o truque
  Base64.encode64(cipher.update(message) + cipher.final)
end
```

Feito isso, o resultado agora será o mesmo do código em C#:

```ruby
> encrypt_data("abc123", "hello world")
 => "90v60JwFNH+VuIKJgSVWUw==\n"
```

Para comparar, basta compilar e executar na sua máquina (se por acaso for um dev Windows) ou, se não for, ir no site [Compile Online](http://www.compileonline.com/compile_csharp_online.php) que permite compilar e executar código em diversas linguagens diferentes diretamente na Web (dica do [@_carloslopes](https://twitter.com/_carloslopes)).

Em resumo: 

* Só porque está encriptado não quer dizer "seguro";
* Entenda o que está copiando, não apenas copie;
* Não use TripleDES, prefira AES;
* Se for usar TripleDES, prefira CBC sobre ECB;
* NÃO USE MD5, ou mesmo SHA1 para hashing de senhas, use bcrypt ou outra coisa mais moderna;
* O módulo OpenSSL do Ruby vai conseguir replicar praticamente todo código criptografia de outras linguagens, facilitando integrações, mas existem pequenas diferenças a tomar cuidado.
