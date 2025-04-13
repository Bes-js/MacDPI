<div align="center" style="white-space: nowrap;">
  <img src="./MacDPI_logo.png" width=50 height=50 align="center">
  <h1 align="center">MacDPI</h1>
</div>

<div align="center">
  <span>Diese Anwendung enthält ein Deep Packet Inspection (DPI)-Tool, das speziell für macOS entwickelt wurde. Das Tool analysiert den Netzwerkverkehr und inspiziert Datenpakete, um Einblicke in den Informationsfluss innerhalb des Netzwerks zu geben. Es ist nützlich für Netzwerkadministratoren, Sicherheitsexperten oder alle, die den Netzwerkverkehr im Detail überwachen und analysieren möchten.</span>
</div>

###

<div align="center">
  <img src="./MacDPI_interface.gif" width=400 height=270>
</div>

###

<div align="center">
<span align="center">Die Standardeinstellungen beseitigen die meisten Hindernisse. Wenn Sie dennoch keinen Zugriff auf eine Website oder einen Dienst haben, können Sie es mit den Einstellungen im DNS- oder Erweitert-Bereich versuchen.</span>
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

<h1>📁 Veröffentlichungen</h1>

[Sie können die .dmg-Datei hier herunterladen](https://github.com/Bes-js/MacDPI/releases)

###

<h1>❔ Funktionsweise</h1>

###

<h2>HTTP</h2>

Da die meisten Websites heutzutage HTTPS verwenden, umgeht MacDPI keine Deep Packet Inspections für HTTP-Anfragen. Es bietet jedoch weiterhin eine Proxy-Verbindung für alle HTTP-Anfragen.

<h2>HTTPS</h2>

Obwohl TLS jeden Handshake verschlüsselt, werden Domainnamen im Client-Hello-Paket weiterhin als Klartext angezeigt. Das bedeutet, dass jemand, der sich das Paket ansieht, leicht erkennen kann, wohin es gesendet wird. Der Domainname kann beim DPI-Prozess wichtige Informationen liefern, und es ist ersichtlich, dass die Verbindung direkt nach dem Senden des Client-Hello-Pakets blockiert wird. Ich habe verschiedene Methoden ausprobiert und festgestellt, dass anscheinend nur das erste Fragment überprüft wird, wenn das Client-Hello-Paket in Teile aufgeteilt wird. MacDPI umgeht dies, indem es zunächst nur 1 Byte an den Server sendet und dann den Rest der Anfrage nachschickt.

###

<h1>✨ Inspirationen</h1>

<div align="center">

[SpoofDPI](https://github.com/xvzc/SpoofDPI) von @xvzc

<span align="center">MacDPI ist eine Anwendung für macOS, die auf Basis von SpoofDPI entwickelt wurde.</span>

</div>