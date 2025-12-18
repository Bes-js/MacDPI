<div align="center" style="white-space: nowrap;">
  <img src="./AppIcon.png" width=100 height=100 align="center">
  <h1 align="center"> MacDPI </h1>
</div>

<div align="center">
  <span>This application contains a Deep Packet Inspection (DPI) tool designed specifically for macOS. The tool analyzes network traffic and inspects data packets to provide insights into the flow of information across the network. It is useful for network administrators, security professionals, or anyone looking to monitor and inspect network traffic in detail.</span>
</div>

###

<div align="center">
<span align="center">Default settings remove most obstacles, if there is a site or service that you cannot access, you can access it by trying the settings in the DNS or Advanced section.</span>
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

<h1>📁 Releases</h1>

[You can access the .dmg file by clicking here](https://github.com/Bes-js/MacDPI/releases)

###

<h1>❔ How it works</h1>

###

<h2>HTTP</h2>

Since most websites in the world now support HTTPS, MacDPI doesn't bypass Deep Packet Inspections for HTTP requests, However, it still serves proxy connection for all HTTP requests.

<h2>HTTPS</h2>

Although TLS encrypts every handshake process, the domain names are still shown as plaintext in the Client hello packet. In other words, when someone else looks on the packet, they can easily guess where the packet is headed to. The domain name can offer significant information while DPI is being processed, and we can actually see that the connection is blocked right after sending Client hello packet. I had tried some ways to bypass this and found out that it seemed like only the first chunk gets inspected when we send the Client hello packet split into chunks. What MacDPI does to bypass this is to send the first 1 byte of a request to the server, and then send the rest.

###

<h1>✨ Inspirations</h1>

<div align="center">

[SpoofDPI](https://github.com/xvzc/SpoofDPI) by @xvzc


<span align="center">MacDPI is an application for the MacOS operating system developed using SpoofDPI.</span>

</div>

