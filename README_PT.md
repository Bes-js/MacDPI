<div align="center" style="white-space: nowrap;">
   <img src="./AppIcon.png" width=100 height=100 align="center">
  <h1 align="center">MacDPI</h1>
</div>

<div align="center">
  <span>Este aplicativo contém uma ferramenta de Inspeção Profunda de Pacotes (DPI) projetada especificamente para macOS. A ferramenta analisa o tráfego de rede e inspeciona pacotes de dados para fornecer informações detalhadas sobre o fluxo de informações na rede. É útil para administradores de rede, profissionais de segurança ou qualquer pessoa que deseje monitorar e inspecionar o tráfego de rede em detalhes.</span>
</div>

###

<div align="center">
  <img src="./MacDPI_interface.gif" width=400 height=270>
</div>

###

<div align="center">
<span align="center">As configurações padrão removem a maioria dos obstáculos. Se houver um site ou serviço que você não consegue acessar, tente utilizar as configurações na seção de DNS ou Avançado.</span>
</div>

###

[🇬🇧 For English](./README.md)

[🇹🇷 Türkçe İçin](./README_TR.md)

[🇩🇪 Für Deutsch](./README_DE.md)

[🇪🇸 Para Español](./README_ES.md)

[🇫🇷 Pour le Français](./README_FR.md)

[🇮🇹 Per Italiano](./README_IT.md)

[🇧🇷 Para Português](./README_PT.md)

[🇷🇺 Для Русского](./README_RU.md)

[🇯🇵 日本語はこちら](./README_JA.md)

[🇰🇷 한국어 보기](./README_KO.md)

[🇨🇳 查看中文](./README_ZH.md)

[🇸🇦 للغة العربية](./README_AR.md)

[🇵🇱 Dla Polskiego](./README_PL.md)

[🇺🇦 Для української](./README_UK.md)

[🇮🇷 برای فارسی](./README_IR.md)

[🇬🇷 Για Ελληνικά](./README_GR.md)

[🇦🇿 Azərbaycan dili üçün](./README_AZ.md)

###

<h1>📁 Lançamentos</h1>

[Você pode acessar o arquivo .dmg clicando aqui](https://github.com/Bes-js/MacDPI/releases)

###

<h1>❔ Como funciona</h1>

###

<h2>HTTP</h2>

Como a maioria dos sites atualmente utiliza HTTPS, o MacDPI não contorna a inspeção DPI para requisições HTTP. No entanto, ainda fornece uma conexão proxy para todas as requisições HTTP.

<h2>HTTPS</h2>

Embora o TLS criptografe todo o processo de handshake, os nomes de domínio ainda aparecem em texto simples no pacote Client Hello. Em outras palavras, quando outra pessoa observa o pacote, ela pode facilmente deduzir para onde ele está sendo enviado. O nome do domínio pode fornecer informações significativas durante o processo de DPI, e podemos observar que a conexão é bloqueada logo após o envio do pacote Client Hello. Eu testei algumas formas de contornar isso e descobri que parece que apenas o primeiro fragmento é inspecionado quando dividimos o pacote Client Hello. O que o MacDPI faz para contornar isso é enviar primeiro 1 byte da solicitação ao servidor, e depois enviar o restante.

###

<h1>✨ Inspirações</h1>

<div align="center">

[SpoofDPI](https://github.com/xvzc/SpoofDPI) por @xvzc

<span align="center">MacDPI é um aplicativo para macOS desenvolvido com base no SpoofDPI.</span>

</div>
