<div align="center" style="white-space: nowrap;">
  <img src="./MacDPI_logo.png" width=50 height=50 align="center">
  <h1 align="center">MacDPI</h1>
</div>

<div align="center">
  <span>이 애플리케이션은 macOS용으로 특별히 설계된 깊은 패킷 검사(DPI) 도구를 포함하고 있습니다. 이 도구는 네트워크 트래픽을 분석하고 데이터 패킷을 검사하여 네트워크에서 정보의 흐름에 대한 통찰을 제공합니다. 이는 네트워크 관리자, 보안 전문가 또는 네트워크 트래픽을 자세히 모니터링하고 검사하려는 사람들에게 유용합니다.</span>
</div>

###

<div align="center">
  <img src="./MacDPI_interface.gif" width=400 height=270>
</div>

###

<div align="center">
<span align="center">기본 설정은 대부분의 장애물을 제거하지만, 액세스할 수 없는 사이트나 서비스가 있는 경우 DNS 또는 고급 설정 섹션에서 설정을 시도하여 액세스할 수 있습니다.</span>
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

<h1>📁 릴리스</h1>

[여기를 클릭하면 .dmg 파일에 액세스할 수 있습니다](https://github.com/Bes-js/MacDPI/releases)

###

<h1>❔ 작동 원리</h1>

###

<h2>HTTP</h2>

현재 대부분의 웹사이트는 HTTPS를 지원하므로 MacDPI는 HTTP 요청에 대해 깊은 패킷 검사를 우회하지 않습니다. 그러나 모든 HTTP 요청에 대해서는 여전히 프록시 연결을 제공합니다.

<h2>HTTPS</h2>

TLS는 모든 핸드셰이크 프로세스를 암호화하지만, 도메인 이름은 Client Hello 패킷에 평문으로 표시됩니다. 즉, 누군가가 패킷을 살펴보면 해당 패킷이 어디로 향하는지 쉽게 추측할 수 있습니다. 도메인 이름은 DPI 분석 중 중요한 정보를 제공하며, 실제로 Client Hello 패킷을 전송한 직후 연결이 차단된다는 것을 볼 수 있습니다. 이를 우회하기 위해 몇 가지 방법을 시도해 본 결과, Client Hello 패킷을 조각으로 나누어 보낼 때 첫 번째 조각만 검사되는 것 같습니다. MacDPI는 이를 우회하기 위해 요청의 첫 번째 바이트만 서버에 보내고 나머지를 전송하는 방법을 사용합니다.

###

<h1>✨ 영감을 준 프로젝트</h1>

<div align="center">

[SpoofDPI](https://github.com/xvzc/SpoofDPI) by @xvzc

<span align="center">MacDPI는 SpoofDPI를 사용하여 개발된 macOS용 애플리케이션입니다.</span>

</div>