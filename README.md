<div align="center">

<img src="assets/images/mangia_logo.png" alt="Logo MangIA" width="160"/>

# MangIA

## Benessere alimentare, consapevolezza nutrizionale e AI simulata
### Realizzata da: 
Salvatore Lepore | 
Lorenzo Olivola | 
Salvador Davide Passarelli | 
Nicolle Blanco 
###
Applicazione mobile Flutter progettata per aiutare studenti, studenti-lavoratori e giovani lavoratori a comprendere meglio le proprie abitudini alimentari quotidiane.

</div>

---

## Info progetto

| Voce            | Dettaglio                         |
| --------------- | --------------------------------- |
| Corso           | Interazione Uomo Macchina         |
| Università      | Università degli Studi di Salerno |
| Prof.ssa        | G. Vitiello                       |
| Anno accademico | 2026                              |
| Tecnologia      | Flutter, Material 3, Riverpod     |
| Stato           | Prototipo funzionante             |

---

## Descrizione

**MangIA** è un'app mobile pensata per supportare l’utente nella gestione quotidiana delle proprie abitudini alimentari, senza trasformare il monitoraggio in un conteggio rigido e ansiogeno di calorie.

L’obiettivo non è sostituire un nutrizionista, ma offrire feedback semplici, discorsivi e non giudicanti, aiutando l’utente a prendere decisioni più consapevoli durante la giornata.

L’app segue i principi emersi durante gli assignment di IUM:

* riduzione del carico cognitivo;
* navigazione stabile e prevedibile;
* feedback non giudicante;
* progressive disclosure;
* supporto rapido nei momenti di routine frammentata;
* tecnica del Mago di Oz per simulare funzionalità AI non ancora collegate a servizi reali.

---

## Funzionalità principali

| Sezione         | Funzionalità                                                       |
| --------------- | ------------------------------------------------------------------ |
| Home            | Vitality Score, equilibrio giornaliero, idratazione, pasti recenti |
| Scansione pasto | Fotocamera, overlay, analisi mock AI, aggiunta manuale             |
| Analisi pasto   | Dettaglio pasto, suggerimenti, allergeni, chat contestuale         |
| Chat AI         | Prompt rapidi, input vocale, risposte simulate                     |
| Progressi       | Riepilogo settimanale, nutrizione, idratazione                     |
| Esperti         | Lista specialisti, filtri, profilo, prenotazione consulto          |
| Impostazioni    | Preferenze utente, unità di misura, configurazione idratazione     |

---

## Architettura del progetto

```text
lib/
├── main.dart
├── app/
│   ├── app_shell.dart
│   └── mangia_app.dart
├── core/
│   ├── app_colors.dart
│   ├── app_theme.dart
│   └── navigation.dart
├── models/
│   └── models.dart
├── providers/
│   └── app_providers.dart
├── screens/
│   ├── chat/
│   ├── experts/
│   ├── home/
│   ├── scan/
│   ├── settings/
│   └── stats/
├── services/
│   ├── ai_nutrition_api.dart
│   └── mangia_backend.dart
└── widgets/
    └── shared_widgets.dart
```

---

## Design e usabilità

L’interfaccia è stata progettata con uno stile visivo calmo e rassicurante:

* colore principale: **Mint / Green**;
* sfondo chiaro e caldo;
* card morbide;
* navigazione inferiore sempre disponibile;
* pulsante centrale per la scansione;
* informazioni essenziali mostrate subito;
* dettagli accessibili solo quando utili.

Pattern applicati:

* **Go Back To a Safe Place**
* **Current Location Indicator**
* **Progressive Disclosure**
* **Wizard of Oz / Mago di Oz**

---

## Stack tecnologico

* Flutter
* Material 3
* Riverpod
* Camera plugin
* Speech to Text
* Servizi mock predisposti per backend reale

---

## Installazione

```bash
git clone <url-repository>
cd mang_ia
flutter pub get
flutter run
```

---

## Build APK

```bash
flutter build apk --release
```

Output:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## Test e analisi

```bash
dart analyze
flutter test
```

---

## Permessi Android

L’app richiede:

* fotocamera;
* microfono.

Questi permessi sono necessari per la scansione del pasto e per l’input vocale nella chat AI.

---

## Limitazioni attuali

* L’AI è simulata tramite mock.
* Il riconoscimento del pasto non usa ancora un modello reale.
* Il match con esperti è calcolato tramite dati statici.
* Non è presente autenticazione.
* Non è presente persistenza reale su database.

---

## Possibili sviluppi futuri

* Integrazione Firebase.
* Collegamento a un’API AI reale.
* Notifiche per idratazione e pasti.
* Dashboard settimanale più dettagliata.
* Prenotazione reale con calendario.
* Test di accessibilità con utenti reali.

---

## Nota accademica

**MangIA** è un prototipo funzionante realizzato a fini didattici.
Le informazioni nutrizionali mostrate sono simulate e non devono essere considerate diagnosi, prescrizioni o sostituti del parere di un professionista sanitario.

---
