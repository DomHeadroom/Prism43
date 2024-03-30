#!/usr/bin/env bash

clear='\033[0m'
green='\033[0;32m'
red='\033[0;31m'
yellow='\033[0;33m'

root_check() {
  [[ $EUID -eq 0 ]] && { echo -e "${red}Error:${clear} This script should not be run with root permissions.\n${clear}Please rerun it without root permissions." >&2; exit 1; }
}

linux_setup() {
    root_check
    paths=("$HOME/.local/share/PrismLauncher" "$HOME/.var/app/org.prismlauncher.PrismLauncher/data/PrismLauncher")
    install
}

mac_setup() {
    paths=("$HOME/Library/Application Support/PrismLauncher/")
    install
}

install() {
  for path in "${paths[@]}"; do
    if [ -d "$path" ]; then
        found='true'
        echo -e "Installation found in:\n${yellow}${path}\n${clear}Downloading accounts.json..."
        curl -f -sL "https://raw.githubusercontent.com/DomHeadroom/Prism43/main/accounts.json" 1> "${path}/accounts.json" ||
        { echo -e "${red}Error:${clear} A problem occurred while downloading accounts.json.\n${clear}Exiting..." >&2; exit 1; }
    fi
  done
  [[ ! "${found}" ]] && { echo -e "${red}Error:${clear} Installation directory not found.\n${clear}Exiting..." >&2; exit 1; }
  echo -e "${green}Success:${clear} All done without any problems!"
}

echo "\`7MM\"\"\"Mq.            db                                                "
echo "  MM   \`MM.                                                             "
echo "  MM   ,M9 \`7Mb,od8 \`7MM  ,pP\"Ybd \`7MMpMMMb.pMMMb.       ,AM    pd\"\"b.  "
echo "  MMmmdM9    MM' \"'   MM  8I   \`\"   MM    MM    MM      AVMM   (O)  \`8b "
echo "  MM         MM       MM  \`YMMMa.   MM    MM    MM    ,W' MM        ,89 "
echo "  MM         MM       MM  L.   I8   MM    MM    MM  ,W'   MM      \"\"Yb. "
echo ".JMML.     .JMML.   .JMML.M9mmmP' .JMML  JMML  JMML.AmmmmmMMmm       88 "
echo "                                                          MM   (O)  .M' "
echo "                                                          MM    bmmmd'  "
echo

case $(uname | tr '[:upper:]' '[:lower:]') in
  darwin*) mac_setup ;;
        *) linux_setup ;;
esac
