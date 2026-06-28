# syncthing-client

A cross-platform **Syncthing** client that bundles and manages its own Syncthing
engine — install one file, no separate Syncthing setup. It can also connect to an
existing/remote Syncthing instance (URL + API key).

## Platforms
linux, macos, windows, android **now**. **iOS is deferred** (iOS forbids
subprocesses; embedding Syncthing needs an in-process static library via
gomobile/c-archive — a later phase; the UI still compiles and runs in remote mode).
**web** is remote-only (cannot bundle a binary).

## Stack
- Flutter + `m3e_core` + `declar_ui` + `flutter_riverpod`.
- State: `flutter_riverpod`. Persistence: `shared_preferences`.
- Engine transport: Syncthing REST API over `package:http`; live updates via the
  `/rest/events` long-poll stream.
- i18n: `slang` (yaml in `lib/i18n`, `en` + `ru`).
- Scripts: `justfile` (+ `scripts/`).

## Cardinal rule
**Material 3 Expressive, latest spec, everywhere.** Every screen, component, motion,
shape and color follows M3 Expressive. Use `m3e_core` components and M3 `ColorScheme`
roles (`context.colors.*`) — never hard-coded colors.

It must read as *visibly Expressive*, not plain Material 3: large/varied corner radii
(~28–32px), stadium buttons, bold emphasized type, spring motion (`m3e_core` / `motor`),
and generous container color roles. Plain M3 defaults are not enough. Theme tokens live
in `lib/ui/theme.dart` via `stTheme`.

## Coding rules
- **No comments.** Code must be self-documenting through naming and structure.
- Code must be easy for a human to read.
- **Max 300 lines per file**; ideally 1–2 screens of height.
- **Dark / light / system** theme support, switchable by the user.
- **8 color schemes**, switchable in Settings.
- **ru / en** locales, switchable in Settings.
- **Use dot shorthands** wherever the language allows (`.system`, `.filled`, `.center`).
- **No C/C++.** Prefer Dart; reach for FFI only behind a profiled hotspot.

## Package gotchas
- `declar_ui` re-exports `package:flutter/material.dart` but **hides** the widgets it
  wraps (`Text`, `Column`, `Row`, `Container`, `SizedBox`, `Scaffold`, `MaterialApp`,
  `Card`, `ListView`, `Stack`, `Icon`, `Image`, `TextField`, `Wrap`, `SafeArea`,
  `CustomScrollView`). In UI files import **`declar_ui` only** (plus `m3e_core`,
  riverpod, local files) — do **not** also import `flutter/material`, or those names
  become ambiguous.
- declar wrappers are chainable: `Scaffold().body(x).appBar(y)`,
  `MaterialApp().theme(t).home(h)`, `Column(children: [...]).spacing(8)`,
  `Text('x').size(16).weight(.bold)`, plus extensions `.padding(...)`, `.onTap(...)`,
  `.expanded()`, `.center()`.
- Context extensions: `context.colors`, `context.theme`, `context.textTheme`,
  `context.width`, `context.push(widget)`, `context.showSnackBar(...)`.
- m3e_core public widgets: `M3EButton` (`.icon` factory), `M3ECard`, `M3ECardList`,
  `M3ECardColumn`, `M3EExpandableItem`, `M3EShape`, `M3EToggleButton(Group)`,
  `M3ESplitButton`. Enums: `M3EButtonStyle`, `M3EButtonSize`, `M3EButtonShape`.
- Need a material `TextField` (declar hides it)? Build that piece in a file that imports
  `package:flutter/material.dart` only, with no declar import (`lib/ui/widgets/text_field.dart`).
- declar `Scaffold` chainable methods are `.body(...)`, `.appBar(...)`,
  `.bottomNavigation(...)`, `.floatingAction(...)` (not `floatingActionButton`),
  `.drawer(...)`, `.backgroundColor(...)`.

## Asset / engine gotchas
- Flutter **directory assets are non-recursive** — `assets/bin/` bundles only files
  directly inside it, not subdirectories. The desktop Syncthing binary therefore lives at
  the flat path `assets/bin/syncthing[.exe]` (one per build/arch), not in arch subdirs.
- Syncthing's GUI host-check rejects requests whose Host doesn't match the configured GUI
  address, so the supervisor sets the listen address + API key via the `STGUIADDRESS` /
  `STGUIAPIKEY` env vars when spawning `serve` (validated against syncthing v2.x).

## UI conventions
- **Side-rail layout (width ≥ 720):** `NavigationRail`-style rail + a `VerticalDivider`
  span the **full window height**. No full-width `AppBar` above them — the screen title
  lives *inside* the content pane (right of the divider).
- **Compact layout (width < 720):** top `AppBar` + bottom `NavigationBar`.

## Engine architecture
`SyncthingSupervisor` abstracts the engine lifecycle and exposes an `endpoint`
(baseUrl + apiKey):
- `BundledProcessSupervisor` (desktop + android): locates the binary via
  `binary_locator`, generates config on first run, starts the process, waits for
  `/rest/noauth/health`, streams logs.
- `RemoteSupervisor`: no process; `endpoint` is the user's URL + key.
Selection is driven by `AppConfig.engineMode` (`bundled` | `remote`). Web is always
remote.

### Where the Syncthing binary comes from
Downloaded from official releases by `just fetch-*` (see `scripts/fetch-syncthing.just`),
never committed:
- desktop → `assets/bin/<os>-<arch>/syncthing[.exe]`, extracted to app-support and
  exec'd at runtime.
- android → `android/app/src/main/jniLibs/<abi>/libsyncthing.so`, exec'd from the
  native library dir.

## Layout
`lib/core` config/models · `lib/api` REST client + models + event stream ·
`lib/engine` supervisor + binary locator · `lib/state` riverpod providers ·
`lib/platform` tray/lifecycle/background/storage · `lib/ui` theme, shell, widgets, screens ·
`lib/i18n` slang yaml + generated.

## Common tasks (just)
- `just get` — pub get.
- `just gen` — regenerate slang strings.
- `just fetch-host` — download the Syncthing binary for the dev machine.
- `just run [linux]` — fetch host binary + run.
- `just analyze` / `just format`.
- `just deb` / `just dmg` / `just msi` / `just apk` — single-file installers with the
  engine bundled.
- `just release [patch|minor|major]` — bump + tag.
