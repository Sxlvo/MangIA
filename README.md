# MangIA

Applicazione mobile Flutter per il benessere alimentare e la consapevolezza nutrizionale.

Progetto realizzato per il corso di **Interazione Uomo Macchina**  
Universita degli Studi di Salerno  
Prof.ssa **G. Vitiello**  
Anno accademico **2026**

## Descrizione

**MangIA** e un'app mobile pensata per aiutare studenti, studenti-lavoratori e giovani lavoratori a comprendere meglio le proprie abitudini alimentari quotidiane senza trasformare il monitoraggio in un conteggio rigido e ansiogeno di calorie.

L'obiettivo principale non e sostituire un nutrizionista, ma supportare l'utente nel prendere decisioni piu consapevoli attraverso feedback semplici, discorsivi e immediati.

L'app segue i principi emersi durante gli assignment di IUM:

- riduzione del carico cognitivo;
- navigazione stabile e prevedibile;
- feedback non giudicante;
- progressive disclosure;
- supporto rapido nei momenti di routine frammentata;
- tecnica del Mago di Oz per simulare funzioni AI non ancora collegate a servizi reali.

## Funzionalita principali

### Home

- Riepilogo giornaliero con **Vitality Score**.
- Card "Equilibrio della giornata" con feedback discorsivo.
- Tracker idratazione rapido con pulsanti `+` e `-`.
- Lista dei pasti recenti.
- Accesso alle impostazioni utente.

### Scansione pasto

- Schermata fotocamera integrata.
- Overlay grafico per inquadrare il piatto.
- Analisi mock del pasto tramite AI.
- Gestione del caso "pasto non riconosciuto".
- Form per aggiunta manuale del pasto.

### Analisi pasto

- Dettaglio del pasto riconosciuto.
- Suggerimenti nutrizionali discorsivi.
- Avvisi su possibili carenze o allergeni.
- Chat contestuale con MangIA direttamente nella pagina di analisi.

### Chat AI

- Interfaccia conversazionale.
- Prompt rapidi cliccabili.
- Input vocale tramite microfono.
- Risposte simulate con approccio non giudicante.

### Progressi

- Riepilogo settimanale.
- Vitality Score.
- Percentuale di idratazione collegata al contatore della Home.
- Metriche sintetiche per nutrizione e idratazione.

### Esperti

- Lista di nutrizionisti/specialisti.
- Match rate personalizzato.
- Filtri per budget, specializzazione e disponibilita.
- Pagina profilo dettagliata.
- Pagina per prenotare un consulto.

### Impostazioni

- Preferenze utente.
- Configurazione idratazione.
- Scelta dell'unita di misura: bicchieri, millilitri o litri.
- Personalizzazione della quantita di acqua per bicchiere.

## Design e usabilita

L'interfaccia e stata progettata con uno stile visivo calmo e rassicurante:

- colore principale: **Mint / Green**;
- sfondo chiaro e caldo;
- card morbide;
- navigazione inferiore sempre disponibile;
- pulsante centrale per la scansione;
- informazioni essenziali mostrate subito;
- dettagli accessibili solo quando utili.

Pattern di interaction design applicati:

- **Go Back To a Safe Place**: l'utente puo tornare rapidamente a una schermata conosciuta.
- **Current Location Indicator**: la navigazione evidenzia la sezione attiva.
- **Progressive Disclosure**: la Home mostra solo le informazioni essenziali.
- **Wizard of Oz / Mago di Oz**: le funzionalita AI sono simulate tramite servizi mock, predisposti per endpoint reali.

## Stack tecnologico

- **Flutter**
- **Material 3**
- **Riverpod**
- **Camera plugin**
- **Speech to Text**
- Architettura modulare per separare UI, stato, modelli e servizi.

## Architettura del progetto

```text
lib/
|-- main.dart
|-- app/
|   |-- app_shell.dart
|   `-- mangia_app.dart
|-- core/
|   |-- app_colors.dart
|   |-- app_theme.dart
|   `-- navigation.dart
|-- models/
|   `-- models.dart
|-- providers/
|   `-- app_providers.dart
|-- screens/
|   |-- chat/
|   |-- experts/
|   |-- home/
|   |-- scan/
|   |-- settings/
|   `-- stats/
|-- services/
|   |-- ai_nutrition_api.dart
|   `-- mangia_backend.dart
`-- widgets/
    `-- shared_widgets.dart
```

### Scelte architetturali

- `main.dart` contiene solo l'avvio dell'app.
- `app/` contiene configurazione generale e shell di navigazione.
- `core/` contiene tema, colori e utility di navigazione.
- `models/` contiene le entita principali del dominio.
- `providers/` contiene provider e controller Riverpod.
- `services/` contiene interfacce e mock per AI/backend.
- `screens/` contiene le schermate principali.
- `widgets/` contiene componenti riutilizzabili.

## Servizi mock e predisposizione backend

Il progetto non usa un backend reale. Le informazioni sono simulate nel codice per rispettare le specifiche dell'Assignment 4.

Sono comunque presenti interfacce gia predisposte:

- `AiNutritionApi`: per collegare in futuro un servizio AI reale.
- `MangiaBackend`: per collegare Firebase, Firestore o un backend custom.

I mock attuali simulano:

- riconoscimento del pasto;
- suggerimenti nutrizionali;
- chat AI;
- lista esperti;
- salvataggio idratazione.

## Requisiti

- Flutter SDK installato.
- Android Studio o VS Code.
- Emulatore Android o dispositivo Android reale.
- Per fotocamera e microfono e consigliato un dispositivo reale.

## Installazione

Clonare il repository:

```bash
git clone <url-repository>
cd mang_ia
```

Installare le dipendenze:

```bash
flutter pub get
```

Avviare l'app:

```bash
flutter run
```

## Build APK

Per generare un APK installabile:

```bash
flutter build apk --release
```

Output:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Per generare APK separati per architettura:

```bash
flutter build apk --split-per-abi
```

## Test e analisi

Analisi statica:

```bash
dart analyze
```

Test Flutter:

```bash
flutter test
```

## Permessi Android

L'app richiede:

- fotocamera;
- microfono.

Questi permessi sono necessari per:

- scansione del pasto;
- input vocale nella chat AI.

Su emulatore alcune funzioni possono dipendere dalla configurazione dell'AVD. Per la camera virtuale e consigliato impostare:

```text
Back Camera: VirtualScene
```

## Limitazioni attuali

- L'AI e simulata tramite mock.
- Il riconoscimento del pasto non usa ancora un modello reale.
- Il match con esperti e calcolato tramite dati statici.
- Non e presente autenticazione.
- Non e presente persistenza reale su database.

## Possibili sviluppi futuri

- Integrazione Firebase per utenti, preferenze e storico pasti.
- Collegamento a un'API AI reale per riconoscimento immagini e chat.
- Sistema di notifiche per idratazione e pasti.
- Dashboard settimanale piu dettagliata.
- Prenotazione reale con calendario.
- Accessibilita avanzata e test con utenti reali.

## Autori

Progetto sviluppato nell'ambito del corso di **Interazione Uomo Macchina**.

Gruppo di progetto: **MangIA**  
Prof.ssa: **G. Vitiello**  
Anno: **2026**

## Nota accademica

MangIA e un prototipo funzionante realizzato a fini didattici. Le informazioni nutrizionali mostrate sono simulate e non devono essere considerate diagnosi, prescrizioni o sostituti del parere di un professionista sanitario.
