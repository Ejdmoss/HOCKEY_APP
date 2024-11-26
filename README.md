![Version](https://img.shields.io/badge/Verze-Alpha_0.1-green.svg?logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI0MCIgaGVpZ2h0PSI0MCIgdmlld0JveD0iMTIgMTIgNDAgNDAiPjxwYXRoIGZpbGw9IiMzMzMzMzMiIGQ9Ik0zMiwxMy40Yy0xMC41LDAtMTksOC41LTE5LDE5YzAsOC40LDUuNSwxNS41LDEzLDE4YzEsMC4yLDEuMy0wLjQsMS4zLTAuOWMwLTAuNSwwLTEuNywwLTMuMiBjLTUuMywxLjEtNi40LTIuNi02LjQtMi42QzIwLDQxLjYsMTguOCw0MSwxOC44LDQxYy0xLjctMS4yLDAuMS0xLjEsMC4xLTEuMWMxLjksMC4xLDIuOSwyLDIuOSwyYzEuNywyLjksNC41LDIuMSw1LjUsMS42IGMwLjItMS4yLDAuNy0yLjEsMS4yLTIuNmMtNC4yLTAuNS04LjctMi4xLTguNy05LjRjMC0yLjEsMC43LTMuNywyLTUuMWMtMC4yLTAuNS0wLjgtMi40LDAuMi01YzAsMCwxLjYtMC41LDUuMiwyIGMxLjUtMC40LDMuMS0wLjcsNC44LTAuN2MxLjYsMCwzLjMsMC4yLDQuNywwLjdjMy42LTIuNCw1LjItMiw1LjItMmMxLDIuNiwwLjQsNC42LDAuMiw1YzEuMiwxLjMsMiwzLDIsNS4xYzAsNy4zLTQuNSw4LjktOC43LDkuNCBjMC43LDAuNiwxLjMsMS43LDEuMywzLjVjMCwyLjYsMCw0LjYsMCw1LjJjMCwwLjUsMC40LDEuMSwxLjMsMC45YzcuNS0yLjYsMTMtOS43LDEzLTE4LjFDNTEsMjEuOSw0Mi41LDEzLjQsMzIsMTMuNHoiLz48L3N2Zz4%3D)
[![Developer](https://img.shields.io/badge/Developer-Adam_Stuchlík-green)](https://github.com/Ejdmoss)
[![Framework](https://img.shields.io/badge/Framework-Flutter-green)](https://flutter.dev/)
[![Framework](https://img.shields.io/badge/Framework-dart-orange)](https://dart.dev/)
[![Database](https://img.shields.io/badge/Database-FireBase-blue)](https://firebase.google.com/)

# Aplikace pro sledování ledního hokeje
Tato aplikace je navržena pro fanoušky ledního hokeje, kteří chtějí sledovat výsledky, tabulky týmů, soupisky a další důležité informace o své oblíbené lize a týmech. Umožňuje uživatelům prohlížet aktuální výsledky, soupisky týmů a detaily jednotlivých hráčů. Je ideální jak pro fanoušky, tak pro ty, kteří chtějí mít přehled o své oblíbené hokejové lize.

# Funkcionality
- Výběr ligy: Uživatelé si mohou vybrat různé ligy, které sledují, například NHL, KHL nebo národní ligy.
- Tabulka týmů: Aplikace zobrazuje aktuální tabulku vybrané ligy včetně počtu bodů, výher, remíz a proher.
- Detail týmů a soupisky: Možnost prohlédnout si detaily týmů včetně kompletních soupisek hráčů s informacemi jako pozice, věk, a statistiky.
- Historie zápasů: Uživatelé mohou sledovat historii zápasů jednotlivých týmů, včetně výsledků a statistik.
- Personalizace: Možnost uložit oblíbené týmy a hráče pro rychlý přístup k informacím.

# Technologie
Tento projekt bude postaven pomocí moderních technologií:

- Flutter pro multiplatformní vývoj mobilních aplikací.
- Firebase pro backend a ukládání dat.
- REST API pro přístup k aktuálním výsledkům, statistikám a dalším údajům z různých hokejových soutěží.
# Reference:

- https://www.youtube.com/watch?v=8sAyPDLorek - youtube video o první Flutter aplikaci
- https://codelabs.developers.google.com/codelabs/flutter-codelab-first#3 - zakládání projektu a první Flutter aplikace
- https://fonts.google.com/icons - ikony pro flutter
- https://www.geeksforgeeks.org/flutter-set-background-image/ - Nastavení pozadí reference
- https://www.hokej.cz/tipsport-extraliga - reference pro webscraping
- https://nodejs.org/en - nodejs pro npm
- https://www.youtube.com/watch?v=FYcYVkTowRs - tutoriál pro firebase instalaci
- https://chatgpt.com/ - chatGPT jako pomoc k nejruznějším věcem
- https://www.youtube.com/watch?v=uYgbwOrW-p4 - tutoriál na live database v Firebase


- vytvoření flutter projektu, upravení front end pomoci flutter, připojení firebase s flutterem, musel jsem stahnout nodeJS pro zprovozneni npm comandu. Musí bý verze sdk 17 a vyšší takže stáhnout i toto, nastavit sdk path a uložit, dále flutter login a flutter pub global activate flutterfire_cli, flutterfire configure nadsledne pro zvoleni applikace, nasledne flutter pub add firebase_core, jako posledni flutter pub add firebase_auth