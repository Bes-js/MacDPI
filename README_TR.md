<div align="center" style="white-space: nowrap;">
   <img src="./AppIcon.png" width=100 height=100 align="center">
  <h1 align="center">MacDPI</h1>
</div>

<div align="center">
  <span>Bu uygulama, özellikle macOS için tasarlanmış bir Derin Paket İnceleme (DPI) aracını içermektedir. Araç, ağ trafiğini analiz eder ve veri paketlerini inceleyerek, ağdaki bilgi akışına dair içgörüler sağlar. Ağ yöneticileri, güvenlik profesyonelleri veya ağ trafiğini detaylı şekilde izlemek isteyen herkes için kullanışlıdır.</span>
</div>

###

<div align="center">
  <img src="./MacDPI_interface.gif" width=400 height=270>
</div>

###

<div align="center">
<span align="center">Varsayılan ayarlar, çoğu engeli ortadan kaldırır. Erişemediğiniz bir site veya hizmet varsa, DNS veya Gelişmiş bölümündeki ayarları deneyerek erişim sağlayabilirsiniz.</span>
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

<h1>📁 Sürümler</h1>

[.dmg dosyasını buradan indirebilirsiniz](https://github.com/Bes-js/MacDPI/releases)

###

<h1>❔ Nasıl Çalışır?</h1>

###

<h2>HTTP</h2>

Dünyadaki çoğu web sitesi artık HTTPS'yi desteklediği için, MacDPI HTTP istekleri için Derin Paket İncelemelerini atlamaz, ancak tüm HTTP istekleri için proxy bağlantısı sağlar.

<h2>HTTPS</h2>

TLS, her el sıkışma sürecini şifrelese de, alan adları istemci "hello" paketinde düz metin olarak görünür. Başka bir deyişle, biri paketi incelediğinde, paketin nereye yönlendirildiğini kolayca tahmin edebilir. Alan adı, DPI işlemi sırasında önemli bilgiler sunabilir ve bağlantının istemci "hello" paketi gönderildikten hemen sonra engellendiğini görebiliriz. Bunu aşmak için bazı yöntemler denedim ve istemci "hello" paketini parçalara ayırarak gönderdiğimizde, yalnızca ilk parçanın incelendiği izlenimini edindim. MacDPI, bu engeli aşmak için isteğin ilk 1 baytını sunucuya gönderir ve ardından geri kalanını gönderir.

###

<h1>✨ İlham Kaynakları</h1>

<div align="center">

[SpoofDPI](https://github.com/xvzc/SpoofDPI) by @xvzc


<span align="center">MacDPI, SpoofDPI kullanılarak geliştirilen macOS işletim sistemi için bir uygulamadır.</span>

</div>
