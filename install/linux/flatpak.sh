#!/bin/bash
set -eux

FLATHUB=https://flathub.org/repo/flathub.flatpakrepo

# needed in github-ci
command -v dnf && { dnf upgrade -y ; dnf install -y flatpak-builder git wget; }

NOTFOUND=""
command -v flatpak         >/dev/null 2>&1 || NOTFOUND="$NOTFOUND flatpak"
command -v flatpak-builder >/dev/null 2>&1 || NOTFOUND="$NOTFOUND flatpak-builder"
command -v git             >/dev/null 2>&1 || NOTFOUND="$NOTFOUND git"
command -v wget            >/dev/null 2>&1 || NOTFOUND="$NOTFOUND wget"
test -z "$NOTFOUND" || { echo "$NOTFOUND: not found, but needed. please install. Aborting. "; exit 1; }

flatpak --user remote-add --if-not-exists flathub $FLATHUB
flatpak --user install -y flathub org.freedesktop.Platform 20.08
flatpak --user install -y flathub org.freedesktop.Sdk 20.08
flatpak-builder --repo=repo ./build org.wxformbuilder.wxFormBuilder.json
flatpak build-bundle repo wxformbuilder.flatpak org.wxformbuilder.wxFormBuilder --runtime-repo=$FLATHUB

