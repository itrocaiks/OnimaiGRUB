#!/bin/bash
# Oniichan wa Oshimai! GRUB Theme Uninstaller

set -o pipefail

# Constants

readonly THEME_DIR="/usr/share/grub/themes/onimai"
readonly GRUB_FILE="/etc/default/grub"
readonly GRUB_BAK="${GRUB_FILE}.bak"
# Regular
readonly CDEF="\033[0m"       # Default
readonly CCIN="\033[0;36m"    # Info (canyon)
readonly CGSC="\033[0;32m"    # Success (green)
readonly CRER="\033[0;31m"    # Error (red)
readonly CWAR="\033[0;33m"    # Warning (yellow)
# Bold
readonly b_CDEF="\033[1;37m"
readonly b_CCIN="\033[1;36m"
readonly b_CGSC="\033[1;32m"
readonly b_CRER="\033[1;31m"
readonly b_CWAR="\033[1;33m"

# Utility functions

prompt () {
  local color="$CDEF"
  local opt="$1"

  case "$opt" in
    -s|--success)
      color="$b_CGSC"
      shift
      ;;
    -e|--error)
      color="$b_CRER"
      shift
      ;;
    -w|--warning)
      color="$b_CWAR"
      shift
      ;;
    -i|--info)
      color="$b_CCIN"
      shift
      ;;
    *)
      color="$CDEF"
      ;;
  esac

  local message="$*"

  printf "%b%b%b" "$color" "$message" "$CDEF"
}

has_command() {
  command -v "$1" >/dev/null 2>&1
}

die() {
  prompt -e "Error: $*\n"
  exit 1
}

# Detect location of grub.cfg (common paths)
get_grub_cfg_path() {
  local paths=(
    "/boot/grub/grub.cfg"
    "/boot/grub2/grub.cfg"
    "/boot/efi/EFI/fedora/grub.cfg"
    "/boot/efi/EFI/ubuntu/grub.cfg"
  )
  for p in "${paths[@]}"; do
    if [[ -f "$p" ]]; then
      echo "$p"
      return 0
    fi
  done
  return 1
}

# Main

# Check for root access
if [[ $EUID -ne 0 ]]; then
  die "Root permission required."
fi

# Welcome
prompt -s "\n\t\tOniichan wa Oshimai! GRUB theme uninstaller\n\t\t\tby zenith-chan\n\n"

# # Check which theme variant was installed
# while true; do
#   prompt -i "Did you install the theme with the option menu? [Y/N] "
#   read -r answer
#   case "$answer" in
#     [Yy]* )
#       theme_name="onimai"
#       break
#       ;;
#     [Nn]* )
#       theme_name="onimai_no_menu"
#       break
#       ;;
#     * )
#       prompt -w "Sorry, response '$answer' not understood.\n"
#       ;;
#   esac
# done

# Confirm uninstallation
while true; do
  prompt -i "Are you sure to uninstall? [Y/N] "
  read -r answer
  case "$answer" in
    [Yy]* )
      break
      ;;
    [Nn]* )
      prompt -i "Quitting.\n"
      exit 0
      ;;
    * )
      prompt -w "Sorry, response '$answer' not understood.\n"
      ;;
  esac
done

# Delete theme directory
prompt -i "Removing theme directory '${THEME_DIR}'...\n"
if [[ -d "$THEME_DIR" ]]; then
  rm -rf "$THEME_DIR" || die "Failed to remove theme directory: $THEME_DIR"
else
  prompt -w "Warning: Theme directory not found, skipping...\n"
fi

# Remove GRUB_THEME line from /etc/default/grub
prompt -i "Removing GRUB_THEME setting from '$GRUB_FILE'...\n"
if grep -q "^GRUB_THEME=" "$GRUB_FILE" 2>/dev/null; then
  sed -i '/^GRUB_THEME=/d' "$GRUB_FILE" || die "Failed to edit '$GRUB_FILE'."
else
  prompt -w "Warning: No GRUB_THEME entry found, skipping...\n"
fi

# Update GRUB configuration
prompt -i "Updating GRUB configuration...\n"

update_cmd=""
if has_command update-grub; then
  update_cmd="update-grub"
elif has_command grub-mkconfig; then
  cfg_path=$(get_grub_cfg_path) || die "Could not locate grub.cfg. Please update it manually."
  update_cmd="grub-mkconfig -o $cfg_path"
elif has_command grub2-mkconfig; then
  cfg_path=$(get_grub_cfg_path) || die "Could not locate grub.cfg. Please update it manually."
  update_cmd="grub2-mkconfig -o $cfg_path"
else
  die "Unknown command to update grub.cfg. Please do it yourself."
fi

prompt -i "Executing: '$update_cmd'\n"
if ! eval "$update_cmd"; then
  die "Failed to update grub.cfg. Please do it yourself."
fi

# Finished
prompt -s "\n\t\tOniichan wa Oshimai Theme Uninstalled!\n\t\t\tdamn, onii-chan\n"

exit 0