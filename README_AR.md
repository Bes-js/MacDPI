<div align="center" style="white-space: nowrap;">
    <img src="./AppIcon.png" width=100 height=100 align="center">
  <h1 align="center">MacDPI</h1>
</div>

<div align="center">
  <span>هذا التطبيق يحتوي على أداة لفحص الحزم العميقة (DPI) مصممة خصيصًا لنظام macOS. تقوم الأداة بتحليل حركة المرور الشبكية وفحص الحزم لتوفير رؤى حول تدفق المعلومات عبر الشبكة. هي مفيدة لمسؤولي الشبكات، المتخصصين في الأمان، أو أي شخص يبحث عن مراقبة وفحص حركة المرور الشبكية بالتفصيل.</span>
</div>

###

<div align="center">
  <img src="./MacDPI_interface.gif" width=400 height=270>
</div>

###

<div align="center">
<span align="center">الإعدادات الافتراضية تزيل معظم العقبات، إذا كان هناك موقع أو خدمة لا يمكنك الوصول إليها، يمكنك الوصول إليها عن طريق تجربة الإعدادات في قسم DNS أو الإعدادات المتقدمة.</span>
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

<h1>📁 الإصدارات</h1>

[يمكنك الوصول إلى ملف .dmg بالنقر هنا](https://github.com/Bes-js/MacDPI/releases)

###

<h1>❔ كيف يعمل</h1>

###

<h2>HTTP</h2>

نظرًا لأن معظم المواقع في العالم تدعم الآن HTTPS، لا يتجاوز MacDPI فحص الحزم العميقة لطلبات HTTP. ومع ذلك، فإنه لا يزال يقدم اتصال وكيل لجميع طلبات HTTP.

<h2>HTTPS</h2>

على الرغم من أن TLS يقوم بتشفير كل عملية مصافحة، فإن أسماء النطاقات لا تزال تظهر كنص عادي في حزمة Client Hello. بمعنى آخر، عندما ينظر شخص آخر إلى الحزمة، يمكنه بسهولة تخمين المكان الذي تتجه إليه الحزمة. يمكن أن تقدم أسماء النطاقات معلومات هامة أثناء معالجة DPI، ويمكننا في الواقع رؤية أن الاتصال يتم حظره بعد إرسال حزمة Client Hello. جربت بعض الطرق لتجاوز هذا ووجدت أنه يبدو أن أول جزء فقط يتم فحصه عندما نقوم بإرسال حزمة Client Hello مقسمة إلى أجزاء. ما يفعله MacDPI لتجاوز هذه المشكلة هو إرسال أول بايت من الطلب إلى الخادم، ثم إرسال البقية.

###

<h1>✨ الإلهام</h1>

<div align="center">

[SpoofDPI](https://github.com/xvzc/SpoofDPI) بواسطة @xvzc

<span align="center">MacDPI هو تطبيق لنظام macOS تم تطويره باستخدام SpoofDPI.</span>

</div>
