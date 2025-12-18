<div align="center" style="white-space: nowrap;">
    <img src="./AppIcon.png" width=100 height=100 align="center">
  <h1 align="center">MacDPI</h1>
</div>

<div align="center">
  <span>این برنامه شامل ابزاری برای بازرسی عمیق بسته‌ها (DPI) است که به طور خاص برای macOS طراحی شده است. این ابزار ترافیک شبکه را تجزیه و تحلیل کرده و بسته‌های داده را بازرسی می‌کند تا اطلاعاتی در مورد جریان اطلاعات در سراسر شبکه ارائه دهد. این ابزار برای مدیران شبکه، متخصصان امنیتی یا هر کسی که به دنبال نظارت و بازرسی دقیق ترافیک شبکه است، مفید است.</span>
</div>

###

<div align="center">
  <img src="./MacDPI_interface.gif" width=400 height=270>
</div>

###

<div align="center">
<span align="center">تنظیمات پیش‌فرض بیشتر موانع را از بین می‌برد. اگر به سایت یا سرویسی دسترسی ندارید، می‌توانید با امتحان تنظیمات در بخش DNS یا Advanced به آن دسترسی پیدا کنید.</span>
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

<h1>📁 نسخه‌ها</h1>

[برای دسترسی به فایل .dmg اینجا کلیک کنید](https://github.com/Bes-js/MacDPI/releases)

###

<h1>❔ نحوه کارکرد</h1>

###

<h2>HTTP</h2>

از آنجا که بیشتر سایت‌ها در جهان اکنون از HTTPS پشتیبانی می‌کنند، MacDPI برای درخواست‌های HTTP از بازرسی عمیق بسته‌ها عبور نمی‌کند. با این حال، هنوز اتصال پروکسی برای تمام درخواست‌های HTTP فراهم می‌کند.

<h2>HTTPS</h2>

اگرچه TLS تمام فرآیندهای احراز هویت را رمزنگاری می‌کند، نام‌های دامنه هنوز به صورت متن ساده در بسته Client Hello نمایش داده می‌شوند. به عبارت دیگر، اگر کسی به بسته نگاه کند، به راحتی می‌تواند حدس بزند بسته به کجا ارسال می‌شود. نام دامنه می‌تواند اطلاعات مهمی را هنگام پردازش DPI ارائه دهد، و ما می‌توانیم ببینیم که اتصال بلافاصله پس از ارسال بسته Client Hello مسدود می‌شود. من چندین روش برای عبور از این مسأله امتحان کردم و متوجه شدم که به نظر می‌رسد تنها اولین قسمت از بسته زمانی که بسته Client Hello را به بخش‌های مختلف تقسیم می‌کنیم، مورد بازرسی قرار می‌گیرد. آنچه MacDPI برای عبور از این مسأله انجام می‌دهد، ارسال اولین بایت از درخواست به سرور و سپس ارسال بقیه است.

###

<h1>✨ الهام‌بخش‌ها</h1>

<div align="center">

[SpoofDPI](https://github.com/xvzc/SpoofDPI) توسط @xvzc

<span align="center">MacDPI یک برنامه برای سیستم عامل macOS است که با استفاده از SpoofDPI توسعه یافته است.</span>

</div>
