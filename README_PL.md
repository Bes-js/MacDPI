<div align="center" style="white-space: nowrap;">
  <img src="./MacDPI_logo.png" width=50 height=50 align="center">
  <h1 align="center">MacDPI</h1>
</div>

<div align="center">
  <span>Aplikacja ta zawiera narzędzie do Inspekcji Głębokich Pakietów (DPI) zaprojektowane specjalnie dla macOS. Narzędzie analizuje ruch sieciowy i bada pakiety danych, aby dostarczyć informacji o przepływie danych przez sieć. Jest przydatne dla administratorów sieci, specjalistów ds. bezpieczeństwa oraz wszystkich, którzy chcą monitorować i analizować ruch sieciowy w szczegółach.</span>
</div>

###

<div align="center">
  <img src="./MacDPI_interface.gif" width=400 height=270>
</div>

###

<div align="center">
<span align="center">Domyślne ustawienia usuwają większość przeszkód. Jeśli napotkasz stronę lub usługę, do której nie możesz uzyskać dostępu, spróbuj zmienić ustawienia w sekcji DNS lub Zaawansowane.</span>
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

<h1>📁 Wydania</h1>

[Możesz uzyskać dostęp do pliku .dmg klikając tutaj](https://github.com/Bes-js/MacDPI/releases)

###

<h1>❔ Jak to działa</h1>

###

<h2>HTTP</h2>

Ponieważ większość stron internetowych na świecie obsługuje teraz HTTPS, MacDPI nie omija Inspekcji Głębokich Pakietów dla zapytań HTTP. Jednak wciąż obsługuje połączenie proxy dla wszystkich zapytań HTTP.

<h2>HTTPS</h2>

Chociaż TLS szyfruje każdy proces uzgadniania, nazwy domen wciąż są wyświetlane w postaci tekstu jawnego w pakiecie Client Hello. Innymi słowy, gdy ktoś inny spojrzy na pakiet, łatwo będzie odgadnąć, dokąd zmierza pakiet. Nazwa domeny może dostarczyć istotnych informacji podczas przetwarzania DPI, a my możemy rzeczywiście zobaczyć, że połączenie jest blokowane zaraz po wysłaniu pakietu Client Hello. Próbowałem różnych sposobów, aby obejść ten problem i odkryłem, że wydaje się, że tylko pierwsza część pakietu jest sprawdzana, gdy wysyłamy pakiet Client Hello podzielony na fragmenty. Co MacDPI robi, aby obejść ten problem, to wysyłanie pierwszego bajtu żądania do serwera, a następnie wysyłanie reszty.

###

<h1>✨ Inspiracje</h1>

<div align="center">

[SpoofDPI](https://github.com/xvzc/SpoofDPI) autorstwa @xvzc

<span align="center">MacDPI to aplikacja dla systemu macOS stworzona przy użyciu SpoofDPI.</span>

</div>