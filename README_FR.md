<div align="center" style="white-space: nowrap;">
    <img src="./AppIcon.png" width=100 height=100 align="center">
  <h1 align="center">MacDPI</h1>
</div>

<div align="center">
  <span>Cette application contient un outil d'Inspection Approfondie des Paquets (DPI) spécialement conçu pour macOS. L'outil analyse le trafic réseau et inspecte les paquets de données pour fournir des informations sur le flux d'informations à travers le réseau. Il est utile pour les administrateurs réseau, les professionnels de la sécurité ou toute personne souhaitant surveiller et inspecter le trafic réseau en détail.</span>
</div>

###

<div align="center">
  <img src="./MacDPI_interface.gif" width=400 height=270>
</div>

###

<div align="center">
<span align="center">Les paramètres par défaut suppriment la plupart des obstacles. Si un site ou un service reste inaccessible, vous pouvez essayer les réglages dans la section DNS ou Avancée.</span>
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

<h1>📁 Versions</h1>

[Vous pouvez accéder au fichier .dmg en cliquant ici](https://github.com/Bes-js/MacDPI/releases)

###

<h1>❔ Comment ça fonctionne</h1>

###

<h2>HTTP</h2>

Comme la plupart des sites web utilisent désormais HTTPS, MacDPI ne contourne pas l'inspection DPI pour les requêtes HTTP. Cependant, il agit toujours comme un proxy pour toutes les requêtes HTTP.

<h2>HTTPS</h2>

Bien que TLS chiffre chaque processus de poignée de main, les noms de domaine apparaissent toujours en clair dans le paquet "Client Hello". Autrement dit, lorsqu’une autre personne regarde le paquet, elle peut facilement deviner vers quel site il se dirige. Le nom de domaine fournit des informations significatives lors de l’analyse DPI, et nous pouvons constater que la connexion est bloquée juste après l’envoi du paquet "Client Hello". J’ai essayé plusieurs méthodes pour contourner cela et j’ai découvert qu’il semble que seul le premier fragment est inspecté si nous divisons le paquet "Client Hello". Ce que fait MacDPI pour contourner cela, c’est d’envoyer d’abord 1 octet de la requête au serveur, puis d’envoyer le reste.

###

<h1>✨ Inspirations</h1>

<div align="center">

[SpoofDPI](https://github.com/xvzc/SpoofDPI) par @xvzc

<span align="center">MacDPI est une application pour macOS développée à partir de SpoofDPI.</span>

</div>
