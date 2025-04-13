<div align="center" style="white-space: nowrap;">
  <img src="./MacDPI_logo.png" width=50 height=50 align="center">
  <h1 align="center">MacDPI</h1>
</div>

<div align="center">
  <span>このアプリケーションは、macOS向けに特別に設計されたディープパケットインスペクション（DPI）ツールを含んでいます。このツールはネットワークトラフィックを分析し、データパケットを調査して、ネットワーク上での情報の流れに関する洞察を提供します。ネットワーク管理者、セキュリティ専門家、またはネットワークトラフィックを詳細に監視し、調査したい人々に役立ちます。</span>
</div>

###

<div align="center">
  <img src="./MacDPI_interface.gif" width=400 height=270>
</div>

###

<div align="center">
<span align="center">デフォルト設定でほとんどの障害は取り除かれます。もしアクセスできないサイトやサービスがあれば、DNSまたは詳細設定のセクションで設定を変更して試してみてください。</span>
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

<h1>📁 リリース</h1>

[ここをクリックすると.dmgファイルにアクセスできます](https://github.com/Bes-js/MacDPI/releases)

###

<h1>❔ 使い方</h1>

###

<h2>HTTP</h2>

現在、ほとんどのウェブサイトはHTTPSをサポートしているため、MacDPIはHTTPリクエストに対してディープパケットインスペクションをバイパスしません。しかし、すべてのHTTPリクエストにはプロキシ接続を提供します。

<h2>HTTPS</h2>

TLSはすべてのハンドシェイクプロセスを暗号化しますが、ドメイン名はClient Helloパケットの中でプレーンテキストとして表示されます。つまり、誰かがパケットを覗き見ると、そのパケットがどこに送られるのかを簡単に推測できます。ドメイン名はDPI解析中に重要な情報を提供し、Client Helloパケットを送信した直後に接続がブロックされるのが確認できます。この問題を回避する方法をいくつか試してみましたが、Client Helloパケットを分割して送信した場合、最初のチャンクだけが検査されるようだということが分かりました。MacDPIが行う回避策は、リクエストの最初の1バイトだけをサーバーに送信し、その後残りを送信することです。

###

<h1>✨ インスピレーション</h1>

<div align="center">

[SpoofDPI](https://github.com/xvzc/SpoofDPI) by @xvzc

<span align="center">MacDPIはSpoofDPIを使用して開発されたMacOS用アプリケーションです。</span>

</div>