<div align="center" style="white-space: nowrap;">
    <img src="./AppIcon.png" width=100 height=100 align="center">
  <h1 align="center">MacDPI</h1>
</div>

<div align="center">
  <span>Bu tətbiq, macOS üçün xüsusi olaraq hazırlanmış bir Dərin Paket Təsnifatı (DPI) alətini ehtiva edir. Alət, şəbəkə trafikini analiz edir və məlumat paketlərini yoxlayaraq şəbəkə üzərindəki məlumat axını haqqında məlumat verir. Bu alət, şəbəkə administratorları, təhlükəsizlik mütəxəssisləri və ya şəbəkə trafikini ətraflı şəkildə izləmək və təftiş etmək istəyən hər kəs üçün faydalıdır.</span>
</div>

###

<div align="center">
  <img src="./MacDPI_interface.gif" width=400 height=270>
</div>

###

<div align="center">
<span align="center">Varsayılan ayarlar əksər maneələri aradan qaldırır, əgər bir sayt və ya xidmətə daxil ola bilmirsinizsə, DNS və ya Advanced bölmələrindəki parametrləri yoxlayaraq buna daxil ola bilərsiniz.</span>
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

<h1>📁 Yayımlar</h1>

[DMG faylına buradan daxil ola bilərsiniz](https://github.com/Bes-js/MacDPI/releases)

###

<h1>❔ Necə işləyir</h1>

###

<h2>HTTP</h2>

Dünyadakı əksər saytlar artıq HTTPS-ni dəstəklədiyi üçün, MacDPI HTTP sorğuları üçün Dərin Paket Təsnifatını keçmir, lakin bütün HTTP sorğuları üçün proxy bağlantısı təmin edir.

<h2>HTTPS</h2>

Hər nə qədər TLS hər bir əl sıxışma prosesini şifrələsə də, domen adları hələ də Client hello paketində düz mətn kimi göstərilir. Başqa sözlə desək, birisi paketi izləsə, paket hara gedir asanlıqla təxmin edilə bilər. Domen adı DPI işlənərkən mühüm məlumatlar təmin edə bilər və biz əslində Client hello paketini göndərdikdən dərhal sonra əlaqənin bloklandığını görə bilərik. Mən bunu keçmək üçün bir neçə yol sınadım və anladım ki, yalnız ilk hissə yoxlanılır, biz Client hello paketini parçalara ayırdıqda. MacDPI bunu keçmək üçün ilk sorğu bytesini serverə göndərir, sonra isə qalan hissəsini göndərir.

###

<h1>✨ İlhamlar</h1>

<div align="center">

[SpoofDPI](https://github.com/xvzc/SpoofDPI) @xvzc tərəfindən

<span align="center">MacDPI, SpoofDPI istifadə edilərək inkişaf etdirilmiş bir macOS tətbiqidir.</span>

</div>
