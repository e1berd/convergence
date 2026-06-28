# Convergence

A beautiful, **Material 3 Expressive** Syncthing client that **bundles and manages its
own Syncthing engine** — one installable file, no separate Syncthing setup. It can also
connect to an existing/remote Syncthing instance (URL + API key).

Built with Flutter + `m3e_core` + `declar_ui` + `flutter_riverpod` + `slang`.

## System Requirements

### Development
- **Flutter:** 3.16 or later
- **Dart:** 3.2 or later
- **just:** latest version (`brew install just` or [casey/just](https://github.com/casey/just))
- **Platform-specific build tools:**
  - **Linux:** `build-essential`, `libgtk-3-dev`, `libx11-dev`, `pkg-config`
  - **macOS:** Xcode Command Line Tools
  - **Windows:** Visual Studio Community (C++ workload)
  - **Android:** Android SDK, NDK (handled by Flutter)

### Running
- **Linux, macOS, Windows:** native installers (.deb / .dmg / .msi)
- **Android:** Android 6.0 or later
- **iOS:** remote mode only (no bundled engine)
- **Web:** remote mode only

## Platforms

Linux, macOS, Windows, Android. iOS is deferred (needs an in-process Syncthing static
library; the UI runs in remote mode). Web is remote-only.

## Features

- Bundled Syncthing engine, spawned and supervised by the app (desktop subprocess /
  Android native library), or a remote engine over the REST API.
- Status dashboard, folders (add/edit/scan/pause/share), devices (add by ID or QR,
  online state, transfer rates), live activity feed + engine log.
- Pending device / folder requests surfaced inline.
- 8 color schemes, system/light/dark themes, English & Russian — all in Settings.

## Develop

Requires Flutter, [`just`](https://github.com/casey/just), and the usual desktop build
deps (`just setup` on Debian/Ubuntu).

```bash
just get          # flutter pub get
just gen          # regenerate slang translations
just fetch-host   # download the Syncthing binary for this machine
just run linux    # run (also fetches the host binary)
just analyze
```

## Build single-file installers

Each task downloads the matching official Syncthing binary and bundles it:

```bash
just deb          # Linux .deb
just dmg          # macOS .dmg
just msi          # Windows installer (needs Inno Setup `iscc`)
just apk          # Android .apk (bundles libsyncthing.so per ABI)
just release [patch|minor|major]
```

## How bundling works

- **Desktop:** the Syncthing binary ships as a Flutter asset, is extracted to the app
  support dir at first run, and spawned with a generated API key on a free loopback port.
- **Android:** the binary ships as `jniLibs/<abi>/libsyncthing.so` and is exec'd from the
  native library dir.

The app talks to the engine over the Syncthing REST API and streams `/rest/events` for
live updates.
