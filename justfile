set shell := ["bash", "-uc"]

import 'scripts/fetch-syncthing.just'
import 'scripts/release.just'

default:
    @just --list

setup:
    sudo apt update
    sudo apt install -y build-essential clang cmake ninja-build pkg-config \
      libgtk-3-dev liblzma-dev \
      curl file git unzip xz-utils zip libglu1-mesa jq

get:
    flutter pub get

gen:
    dart run slang

analyze:
    dart analyze lib

format:
    dart format lib

run platform="linux": fetch-host
    flutter run -d {{ platform }}

profile platform="linux": fetch-host
    flutter run --profile -d {{ platform }}

clean:
    flutter clean
