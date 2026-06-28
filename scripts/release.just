release type="patch":
    #!/usr/bin/env bash
    set -euo pipefail
    current="$(grep '^version:' pubspec.yaml | sed 's/version: *//')"
    semver="$(echo "$current" | sed 's/[-+].*//')"
    build="$(echo "$current" | sed -n 's/.*+//p')"; build="${build:-1}"
    IFS='.' read -r major minor patch <<< "$semver"
    case "{{ type }}" in
      patch) patch=$((patch + 1)) ;;
      minor) minor=$((minor + 1)); patch=0 ;;
      major) major=$((major + 1)); minor=0; patch=0 ;;
      *) echo "error: unknown type '{{ type }}'" >&2; exit 1 ;;
    esac
    new_ver="${major}.${minor}.${patch}"; new_build=$((build + 1))
    sed -i "s/^version: .*/version: ${new_ver}+${new_build}/" pubspec.yaml
    git add pubspec.yaml
    git commit -m "release: v${new_ver}"
    git tag "v${new_ver}"
    echo "Released v${new_ver} (build ${new_build})"

apk: fetch-android
    #!/usr/bin/env bash
    set -euo pipefail
    flutter build apk --release
    echo "APK: build/app/outputs/flutter-apk/app-release.apk"

deb:
    #!/usr/bin/env bash
    set -euo pipefail
    just fetch-desktop linux amd64
    flutter build linux --release
    pkg="syncthing-client"
    appid="tech.hammerhead.syncthing_client"
    binary="syncthing_client"
    arch="amd64"
    version="$(grep '^version:' pubspec.yaml | sed 's/version: *//; s/+.*//')"
    bundle="build/linux/x64/release/bundle"
    root="build/deb/${pkg}_${version}"
    deb="build/deb/${pkg}_${version}_${arch}.deb"
    rm -rf build/deb
    mkdir -p "$root/DEBIAN" "$root/usr/lib/$pkg" "$root/usr/bin" \
      "$root/usr/share/applications" "$root/usr/share/icons/hicolor/512x512/apps"
    cp -r "$bundle/." "$root/usr/lib/$pkg/"
    ln -sf "/usr/lib/$pkg/$binary" "$root/usr/bin/$pkg"
    cat > "$root/usr/share/applications/$appid.desktop" <<EOF
    [Desktop Entry]
    Type=Application
    Name=Syncthing Client
    Comment=Material 3 Expressive Syncthing client with a bundled engine
    Exec=/usr/bin/$pkg
    Icon=$appid
    Terminal=false
    Categories=Network;FileTransfer;Utility;
    EOF
    cat > "$root/DEBIAN/control" <<EOF
    Package: $pkg
    Version: $version
    Section: net
    Priority: optional
    Architecture: $arch
    Maintainer: Hammerhead Software <hammerhead.software@gmail.com>
    Installed-Size: $(du -sk "$root/usr" | cut -f1)
    Depends: libgtk-3-0, liblzma5
    Description: Material 3 Expressive Syncthing client
     A beautiful Syncthing client that bundles and manages its own Syncthing engine.
    EOF
    fakeroot dpkg-deb --build "$root" "$deb"
    echo "Built $deb"

dmg:
    #!/usr/bin/env bash
    set -euo pipefail
    just fetch-desktop macos "$(uname -m | sed 's/x86_64/amd64/; s/aarch64/arm64/')"
    flutter build macos --release
    app="$(find build/macos/Build/Products/Release -maxdepth 1 -name '*.app' | head -1)"
    version="$(grep '^version:' pubspec.yaml | sed 's/version: *//; s/+.*//')"
    dmg="build/dmg/syncthing-client_${version}.dmg"
    rm -rf build/dmg; mkdir -p build/dmg
    hdiutil create -volname "Syncthing Client" -srcfolder "$app" -ov -format UDZO "$dmg"
    echo "Built $dmg"

msi:
    #!/usr/bin/env bash
    set -euo pipefail
    just fetch-desktop windows amd64
    flutter build windows --release
    version="$(grep '^version:' pubspec.yaml | sed 's/version: *//; s/+.*//')"
    src="build/windows/x64/runner/Release"
    out="build/msi"
    rm -rf "$out"; mkdir -p "$out"
    iss="${out}/installer.iss"
    cat > "$iss" <<EOF
    [Setup]
    AppName=Syncthing Client
    AppVersion=${version}
    AppId=tech.hammerhead.syncthing_client
    DefaultDirName={autopf}\\Syncthing Client
    DefaultGroupName=Syncthing Client
    OutputDir=${out}
    OutputBaseFilename=syncthing-client_${version}_x64
    Compression=lzma2
    SolidCompression=yes
    ArchitecturesInstallIn64BitMode=x64compatible
    [Files]
    Source: "${src}\\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs
    [Icons]
    Name: "{group}\\Syncthing Client"; Filename: "{app}\\syncthing_client.exe"
    Name: "{autodesktop}\\Syncthing Client"; Filename: "{app}\\syncthing_client.exe"
    [Run]
    Filename: "{app}\\syncthing_client.exe"; Description: "Launch Syncthing Client"; Flags: nowait postinstall skipifsilent
    EOF
    iscc "$iss"
    echo "Built ${out}/syncthing-client_${version}_x64.exe"

buy:
    #!/usr/bin/env bash
    set -euo pipefail
    version="$(grep '^version:' pubspec.yaml | sed 's/version: *//; s/+.*//')"
    case "$(uname -s)" in
     Linux)
      just deb
      deb="build/deb/syncthing-client_${version}_amd64.deb"
      sudo dpkg -i "$deb" || sudo apt-get install -f -y
      sudo update-desktop-database -q 2>/dev/null || true
      echo "Installed syncthing-client $version" ;;
     Darwin)
      just dmg
      app="$(find build/macos/Build/Products/Release -maxdepth 1 -name '*.app' | head -1)"
      rm -rf "/Applications/$(basename "$app")"; cp -R "$app" /Applications/
      echo "Installed $(basename "$app")" ;;
     *) echo "unsupported" >&2; exit 1 ;;
    esac
