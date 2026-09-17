#!/bin/bash

LOG="$HOME/Studium/Master/Forschungsprojekt/test/log.txt"

mkdir -p "$HOME/Studium/Master/Forschungsprojekt/test"

exec /usr/local/bin/nextpnr-himbaechel "$@" >"$LOG" 2>&1