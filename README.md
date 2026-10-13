# Futoshiki for Adults

A Futoshiki (inequality) logic puzzle for Android, iOS and the web.
Fill every row and column with 1–N exactly once so that every inequality sign
between neighbouring cells holds. 5×5 to 7×7 grids, five levels from Easy to
Insane, notes, hints, mistake counter and timer. Every puzzle has exactly one
solution.

## Platforms

- **Android / iOS:** Home page with level choice, Settings (grid size,
  symbol style), manual Save / Continue.
- **Web (appversegames.com iframe):** opens straight into a game. No app bar,
  Home or Settings (the site shows title, rules and links); New Game dialog for
  level / size / symbols; auto-saves to the browser and resumes; keyboard play.
  Web-only behaviour is gated by `isWebEmbed` (`lib/core/platform.dart`).

## Develop

```sh
flutter pub get
flutter analyze
flutter test
```

## Web build and upload

```sh
flutter build web --release --base-href /play/futoshiki_adults/ --no-web-resources-cdn
```

Upload the **contents** of `build/web` (including `.htaccess`) to
`public_html/play/futoshiki_adults/`, and set the WordPress iframe `src` to
`/play/futoshiki_adults/`.
