# BUKI Driving School

Flutter app for studying and testing driving-license theory: pick a language,
pick a license category, then study by subject, browse every question, or
sit a timed random exam.

## Getting started

```
flutter pub get
flutter run
```

## Project layout

```
lib/
  app/            App shell: theming, providers, root widget
  data/           Question/subject models and the content repository
  features/       One folder per screen area (onboarding, subjects,
                   all_questions, question, exam)
  l10n/           Generated localizations (see below) — do not hand-edit
assets/
  data/questions.json   All question content (see "Content" below)
  images/questions/     Question photos, referenced by filename — not
                         every question has one (see below)
  images/answers/       Post-answer animations (arrows recolored to the
                         correct path), for the subset of questions that
                         have one
  brand/logo.jpg        App logo — used as the home background and the
                         Android/iOS/web app icon
```

## Content

All questions, subjects and answers live in `assets/data/questions.json`.
It's plain data — adding, editing or removing a question never requires
touching Dart code. Each question has:

- `id` — stable identifier
- `categories` — which license categories it belongs to (a question can
  belong to any combination, e.g. only `B`, or every category)
- `subjectId` — which topic it groups under in "By Subject"
- `text` / `options` / `explanation` — each localized as `{"ka": ..., "en": ..., "ru": ...}`.
  A missing language falls back to English, then to whichever
  translation exists (see `LocalizedText.resolve`) — a question doesn't
  need every language filled in to work.
- `image` — filename under `assets/images/questions/`, or `null` for a
  text-only question (roughly half the real bank is text-only; the
  question screen simply omits the photo for those)
- `answerMedia` — filename under `assets/images/answers/` for the
  post-answer animation, or `null` if this question only has the
  static photo and text explanation
- `correctIndex` — index into `options`

## Localization

UI strings live in `lib/l10n/app_{ka,en,ru}.arb`. After editing them, regenerate:

```
flutter gen-l10n
```

## App icon

The Android/iOS launcher icon is generated from `assets/brand/logo.jpg`.
After replacing the logo file, regenerate it:

```
dart run flutter_launcher_icons
```

(Web favicon/PWA icons under `web/icons/` are static files and need
regenerating by hand if the logo changes.)

## Web build

The web build is served without Flutter's default service worker
(`--pwa-strategy=none`) so a reload always fetches the latest deploy —
the offline-caching strategy is meant for installable PWAs, not a demo
link that should show the current build every time:

```
flutter build web --release --base-href /your-path/ --pwa-strategy=none
```
