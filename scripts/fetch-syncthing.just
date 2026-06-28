_resolve-version:
    #!/usr/bin/env bash
    set -euo pipefail
    url="$(curl -fsSL -o /dev/null -w '%{url_effective}' https://github.com/syncthing/syncthing/releases/latest)"
    echo "${url##*/tag/}"

fetch-host:
    #!/usr/bin/env bash
    set -euo pipefail
    case "$(uname -s)" in
      Linux)  os=linux ;;
      Darwin) os=macos ;;
      MINGW*|MSYS*|CYGWIN*|Windows*) os=windows ;;
      *) echo "unsupported host os" >&2; exit 1 ;;
    esac
    case "$(uname -m)" in
      x86_64|amd64) arch=amd64 ;;
      aarch64|arm64) arch=arm64 ;;
      *) echo "unsupported host arch" >&2; exit 1 ;;
    esac
    just fetch-desktop "$os" "$arch"

fetch-desktop os arch:
    #!/usr/bin/env bash
    set -euo pipefail
    tag="$(just _resolve-version)"
    os="{{ os }}"; arch="{{ arch }}"
    bin="syncthing"; [ "$os" = "windows" ] && bin="syncthing.exe"
    mkdir -p assets/bin
    ext="tar.gz"; { [ "$os" = "windows" ] || [ "$os" = "macos" ]; } && ext="zip"
    asset="syncthing-${os}-${arch}-${tag}.${ext}"
    url="https://github.com/syncthing/syncthing/releases/download/${tag}/${asset}"
    tmp="$(mktemp -d)"
    echo "downloading ${url}"
    curl -fsSL "$url" -o "${tmp}/${asset}"
    if [ "$ext" = "zip" ]; then unzip -q "${tmp}/${asset}" -d "$tmp"; else tar -xzf "${tmp}/${asset}" -C "$tmp"; fi
    found="$(find "$tmp" -type f -name "$bin" | head -1)"
    cp "$found" "assets/bin/${bin}"
    chmod +x "assets/bin/${bin}" || true
    rm -rf "$tmp"
    echo "placed assets/bin/${bin} (${tag})"

fetch-android:
    #!/usr/bin/env bash
    set -euo pipefail
    tag="$(just _resolve-version)"
    declare -A map=( [armeabi-v7a]=arm [arm64-v8a]=arm64 [x86]=386 [x86_64]=amd64 )
    for abi in "${!map[@]}"; do
      garch="${map[$abi]}"
      dest="android/app/src/main/jniLibs/${abi}"
      mkdir -p "$dest"
      if [ -f "${dest}/libsyncthing.so" ]; then echo "present: ${abi}"; continue; fi
      asset="syncthing-linux-${garch}-${tag}.tar.gz"
      url="https://github.com/syncthing/syncthing/releases/download/${tag}/${asset}"
      tmp="$(mktemp -d)"
      echo "downloading ${url}"
      curl -fsSL "$url" -o "${tmp}/a.tar.gz"
      tar -xzf "${tmp}/a.tar.gz" -C "$tmp"
      found="$(find "$tmp" -type f -name syncthing | head -1)"
      cp "$found" "${dest}/libsyncthing.so"
      rm -rf "$tmp"
      echo "placed ${dest}/libsyncthing.so"
    done
