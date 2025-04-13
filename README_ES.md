<div align="center" style="white-space: nowrap;">
  <img src="./MacDPI_logo.png" width=50 height=50 align="center">
  <h1 align="center">MacDPI</h1>
</div>

<div align="center">
  <span>Esta aplicación contiene una herramienta de Inspección Profunda de Paquetes (DPI) diseñada específicamente para macOS. La herramienta analiza el tráfico de red e inspecciona los paquetes de datos para proporcionar información sobre el flujo de información a través de la red. Es útil para administradores de red, profesionales de seguridad o cualquier persona que desee monitorear e inspeccionar el tráfico de red en detalle.</span>
</div>

###

<div align="center">
  <img src="./MacDPI_interface.gif" width=400 height=270>
</div>

###

<div align="center">
<span align="center">La configuración predeterminada elimina la mayoría de los obstáculos. Si hay un sitio o servicio al que no puedes acceder, puedes probar con los ajustes en la sección de DNS o Avanzado.</span>
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

<h1>📁 Lanzamientos</h1>

[Puedes acceder al archivo .dmg haciendo clic aquí](https://github.com/Bes-js/MacDPI/releases)

###

<h1>❔ ¿Cómo funciona?</h1>

###

<h2>HTTP</h2>

Dado que la mayoría de los sitios web ahora utilizan HTTPS, MacDPI no evita la inspección profunda de paquetes para solicitudes HTTP. Sin embargo, aún proporciona conexión proxy para todas las solicitudes HTTP.

<h2>HTTPS</h2>

Aunque TLS cifra cada proceso de enlace, los nombres de dominio aún se muestran como texto plano en el paquete de "Client Hello". En otras palabras, cuando alguien analiza el paquete, puede adivinar fácilmente hacia dónde se dirige. El nombre de dominio ofrece información significativa durante el análisis DPI, y de hecho podemos ver que la conexión se bloquea justo después de enviar el paquete "Client Hello". Probé varias maneras de evitar esto y descubrí que parece que solo se inspecciona el primer fragmento cuando se divide el paquete. Lo que hace MacDPI para evitar esto es enviar el primer byte de la solicitud al servidor y luego enviar el resto.

###

<h1>✨ Inspiraciones</h1>

<div align="center">

[SpoofDPI](https://github.com/xvzc/SpoofDPI) por @xvzc

<span align="center">MacDPI es una aplicación para macOS desarrollada utilizando SpoofDPI.</span>

</div>