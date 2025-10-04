#! /bin/sh
# bulk-yay – install packages (repo + AUR) from a list using yay
# Usage: ./bulk-yay [-c pkglist.conf] [-y]

set -euo pipefail

CONF_FILE="pkglist.conf"
YAY_OPTS=()

#----------------------------------------------------------
#  helpers
#----------------------------------------------------------
msg()  { printf '\033[1;32m:: %s\033[0m\n' "$*" ;}
die()  { printf '\033[1;31m==> ERROR: %s\033[0m\n' "$*" >&2 ; exit 1 ;}

#----------------------------------------------------------
#  option parsing
#----------------------------------------------------------
while getopts ":c:y" opt; do
    case $opt in
        c) CONF_FILE=$OPTARG ;;
        y) YAY_OPTS+=("--noconfirm") ;;
        *) die "invalid option: -$OPTARG" ;;
    esac
done

[[ -f $CONF_FILE ]] || die "config file '$CONF_FILE' not found"
command -v yay >/dev/null || die "yay not found – install it first"

#----------------------------------------------------------
#  core functions
#----------------------------------------------------------
get_wanted_pkgs(){
    # $1 = file path
    grep -vE '^\s*(#|$)' "$1"   |
    sed 's/#.*//'               |
    tr -s ' \t' '\n'            |
    sort -u
}

is_installed(){
    # $1 = pkg name   (quietly checks both repo and AUR)
    yay -Q "$1" &>/dev/null
}

install_pkg(){
    # $1 = pkg name
    yay -S --needed "${YAY_OPTS[@]}" "$1"
}

#----------------------------------------------------------
#  main
#----------------------------------------------------------
mapfile -t WANTED < <(get_wanted_pkgs "$CONF_FILE")
((${#WANTED[@]})) || die "no packages listed in '$CONF_FILE'"

TODO=()
for pkg in "${WANTED[@]}"; do
    is_installed "$pkg" || TODO+=("$pkg")
done

((${#TODO[@]})) || { msg "all packages already installed"; exit 0 ;}

msg "packages to install: ${TODO[*]}"
for pkg in "${TODO[@]}"; do
    install_pkg "$pkg"
done

msg "finished"
