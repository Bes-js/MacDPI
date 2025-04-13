<div align="center" style="white-space: nowrap;">
  <img src="./MacDPI_logo.png" width=50 height=50 align="center">
  <h1 align="center">MacDPI</h1>
</div>

<div align="center">
  <span>此应用程序包含专门为 macOS 设计的深度数据包检测（DPI）工具。该工具分析网络流量并检查数据包，以提供关于网络中信息流的洞察。它对于网络管理员、安全专业人士或任何希望详细监控和检查网络流量的人都非常有用。</span>
</div>

###

<div align="center">
  <img src="./MacDPI_interface.gif" width=400 height=270>
</div>

###

<div align="center">
<span align="center">默认设置移除了大多数障碍，如果有无法访问的网站或服务，您可以尝试在 DNS 或高级设置部分进行设置来访问。</span>
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

<h1>📁 发布</h1>

[点击这里可以访问 .dmg 文件](https://github.com/Bes-js/MacDPI/releases)

###

<h1>❔ 工作原理</h1>

###

<h2>HTTP</h2>

由于现在世界上大多数网站都支持 HTTPS，MacDPI 不会绕过 HTTP 请求的深度数据包检查。然而，它仍然为所有 HTTP 请求提供代理连接。

<h2>HTTPS</h2>

尽管 TLS 对每个握手过程进行加密，但域名仍然以明文形式显示在 Client Hello 数据包中。换句话说，当别人查看数据包时，他们可以轻松猜测数据包的目的地。域名在 DPI 处理中提供了重要信息，我们实际上可以看到在发送 Client Hello 数据包后，连接会被阻止。我尝试了几种绕过方法，发现当我们将 Client Hello 数据包分成多个块时，似乎只有第一个块会被检查。MacDPI 绕过此问题的方法是先发送请求的第一个字节，然后发送其余部分。

###

<h1>✨ 灵感来源</h1>

<div align="center">

[SpoofDPI](https://github.com/xvzc/SpoofDPI) by @xvzc

<span align="center">MacDPI 是一个使用 SpoofDPI 开发的 macOS 应用程序。</span>

</div>