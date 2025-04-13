<div align="center" style="white-space: nowrap;">
  <img src="./MacDPI_logo.png" width=50 height=50 align="center">
  <h1 align="center">MacDPI</h1>
</div>

<div align="center">
  <span>Questa applicazione contiene uno strumento di Ispezione Approfondita dei Pacchetti (DPI) progettato specificamente per macOS. Lo strumento analizza il traffico di rete e ispeziona i pacchetti di dati per fornire informazioni sul flusso di dati attraverso la rete. È utile per amministratori di rete, professionisti della sicurezza o chiunque desideri monitorare e ispezionare il traffico di rete in dettaglio.</span>
</div>

###

<div align="center">
  <img src="./MacDPI_interface.gif" width=400 height=270>
</div>

###

<div align="center">
<span align="center">Le impostazioni predefinite rimuovono la maggior parte degli ostacoli. Se c'è un sito o un servizio a cui non puoi accedere, prova a utilizzare le impostazioni nella sezione DNS o Avanzate.</span>
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

<h1>📁 Rilasci</h1>

[Puoi accedere al file .dmg cliccando qui](https://github.com/Bes-js/MacDPI/releases)

###

<h1>❔ Come funziona</h1>

###

<h2>HTTP</h2>

Poiché la maggior parte dei siti web oggi utilizza HTTPS, MacDPI non aggira l'ispezione DPI per le richieste HTTP. Tuttavia, fornisce comunque una connessione proxy per tutte le richieste HTTP.

<h2>HTTPS</h2>

Sebbene TLS crittografi ogni fase dell'handshake, i nomi di dominio sono ancora visibili in chiaro nel pacchetto Client Hello. In altre parole, quando qualcun altro osserva il pacchetto, può facilmente indovinare dove è diretto. Il nome di dominio può offrire informazioni significative durante il processo di DPI, e possiamo effettivamente vedere che la connessione viene bloccata subito dopo l'invio del pacchetto Client Hello. Ho provato alcuni modi per aggirare questo e ho scoperto che sembra che solo il primo frammento venga ispezionato se suddividiamo il pacchetto Client Hello. Quello che fa MacDPI per aggirare ciò è inviare prima 1 byte della richiesta al server, e poi inviare il resto.

###

<h1>✨ Ispirazioni</h1>

<div align="center">

[SpoofDPI](https://github.com/xvzc/SpoofDPI) di @xvzc

<span align="center">MacDPI è un'applicazione per macOS sviluppata utilizzando SpoofDPI.</span>

</div>