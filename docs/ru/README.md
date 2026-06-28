# Convergence

Красивый **Material 3 Expressive** клиент Syncthing, который **поставляется со встроенным
движком Syncthing** — один установочный файл, никаких отдельных настроек. Может также
подключиться к существующему/удалённому экземпляру Syncthing (URL + API ключ).

Построен на Flutter + `m3e_core` + `declar_ui` + `flutter_riverpod` + `slang`.

## Системные требования

### Разработка
- **Flutter:** 3.16 или позже
- **Dart:** 3.2 или позже
- **just:** последняя версия (`brew install just` или [casey/just](https://github.com/casey/just))
- **Платформо-специфичные инструменты:**
  - **Linux:** `build-essential`, `libgtk-3-dev`, `libx11-dev`, `pkg-config`
  - **macOS:** Xcode Command Line Tools
  - **Windows:** Visual Studio Community (C++ workload)
  - **Android:** Android SDK, NDK (управляется Flutter)

### Использование
- **Linux, macOS, Windows:** нативные установщики (.deb / .dmg / .msi)
- **Android:** Android 6.0 или позже
- **iOS:** только удалённый режим (без встроенного движка)
- **Web:** только удалённый режим

## Платформы

Linux, macOS, Windows, Android. iOS отложен (требует встроенную статическую библиотеку Syncthing; UI работает в удалённом режиме). Web работает только в удалённом режиме.

## Возможности

- Встроенный движок Syncthing, управляемый приложением (desktop subprocess / Android native library), или удалённый движок через REST API.
- Панель статуса, папки (добавление/редактирование/сканирование/пауза/общий доступ), устройства (добавление по ID или QR, статус онлайн, скорость передачи), лента活动 + лог движка.
- Запросы от новых устройств/папок отображаются встроенно.
- 8 цветовых схем, системная/светлая/тёмная темы, английский и русский — всё в Параметрах.

## Разработка

Требуется Flutter, [`just`](https://github.com/casey/just) и стандартные desktop dependencies (`just setup` на Debian/Ubuntu).

```bash
just get          # flutter pub get
just gen          # регенерировать переводы slang
just fetch-host   # скачать бинарник Syncthing для этой машины
just run linux    # запустить (также скачивает бинарник)
just analyze
```

## Сборка установщиков

Каждая задача скачивает соответствующий официальный бинарник Syncthing и встраивает его:

```bash
just deb          # Linux .deb
just dmg          # macOS .dmg
just msi          # Windows установщик (нужен Inno Setup `iscc`)
just apk          # Android .apk (встраивает libsyncthing.so для каждой ABI)
just release [patch|minor|major]
```

## Как работает встраивание

- **Desktop:** бинарник Syncthing поставляется как ресурс Flutter, извлекается в app support директорию при первом запуске и запускается с сгенерированным API ключом на свободном loopback порту.
- **Android:** бинарник поставляется как `jniLibs/<abi>/libsyncthing.so` и запускается из директории native library.

Приложение общается с движком через REST API Syncthing и потребляет `/rest/events` для живых обновлений.
