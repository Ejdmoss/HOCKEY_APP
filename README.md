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


- vytvoření flutter projektu, upravení front end pomoci flutter, připojení firebase s flutterem, musel jsem stahnout nodeJS pro zprovozneni npm comandu. Musí bý verze sdk 17 a vyšší takže stáhnout i toto, nastavit sdk path a uložit, dále flutter login a flutter pub global activate flutterfire_cli, flutterfire configure nadsledne pro zvoleni applikace, nasledne flutter pub add firebase_core, jako posledni flutter pub add firebase_auth