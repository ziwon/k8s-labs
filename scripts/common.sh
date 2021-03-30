#!/bin/bash
#shellcheck disable=SC2046,SC2086,SC2006

info() {
  tput setaf 4; echo "Info> $*" && tput sgr0
}

warn() {
  tput setaf 3; echo "Warn> $*" && tput sgr0
}

err() {
  tput setaf 1; echo "Error> $*" && tput sgr0
  exit 1
}
