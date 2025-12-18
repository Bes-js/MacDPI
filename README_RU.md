<div align="center" style="white-space: nowrap;">
  <img src="./AppIcon.png" width=100 height=100 align="center">
  <h1 align="center">MacDPI</h1>
</div>

<div align="center">
  <span>Это приложение содержит инструмент глубокой инспекции пакетов (DPI), специально разработанный для macOS. Инструмент анализирует сетевой трафик и проверяет пакеты данных, чтобы предоставить информацию о потоке данных в сети. Он полезен для сетевых администраторов, специалистов по безопасности и всех, кто хочет подробно контролировать и анализировать сетевой трафик.</span>
</div>

###

<div align="center">
  <img src="./MacDPI_interface.gif" width=400 height=270>
</div>

###

<div align="center">
<span align="center">Настройки по умолчанию устраняют большинство препятствий. Если вы не можете получить доступ к какому-либо сайту или сервису, попробуйте изменить настройки в разделе DNS или Расширенные.</span>
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

<h1>📁 Релизы</h1>

[Вы можете скачать файл .dmg, нажав здесь](https://github.com/Bes-js/MacDPI/releases)

###

<h1>❔ Как это работает</h1>

###

<h2>HTTP</h2>

Так как большинство сайтов в настоящее время используют HTTPS, MacDPI не обходит DPI для HTTP-запросов. Однако он по-прежнему предоставляет прокси-соединение для всех HTTP-запросов.

<h2>HTTPS</h2>

Хотя TLS шифрует весь процесс рукопожатия, имена доменов всё ещё видны в открытом виде в пакете Client Hello. Другими словами, любой, кто перехватывает трафик, может легко определить, куда направлен пакет. Доменное имя даёт значимую информацию при DPI-анализе, и можно наблюдать, что соединение блокируется сразу после отправки Client Hello. Я попробовал несколько методов обхода и обнаружил, что, похоже, DPI проверяет только первый фрагмент, если разбить Client Hello на части. Что делает MacDPI — отправляет сначала 1 байт запроса на сервер, а затем остальную часть.

###

<h1>✨ Вдохновение</h1>

<div align="center">

[SpoofDPI](https://github.com/xvzc/SpoofDPI) от @xvzc

<span align="center">MacDPI — это приложение для macOS, разработанное на основе SpoofDPI.</span>

</div>
