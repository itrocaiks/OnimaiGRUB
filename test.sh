#!/bin/bash

function cleanup () {
    rm -rfv "$TMP_DIR" "$TMP_ISO"
}

TMP_DIR="${HOME}/.OnimaiGRUB.d"
TMP_ISO="${HOME}/.OnimaiGRUB.iso"
QEMU_ARCH=aarch64
GRUB_FONT_SOURCE="/boot/grub/fonts/unicode.pf2"

if [[ ! -f "$GRUB_FONT_SOURCE" ]]; then
    GRUB_FONT_SOURCE="/usr/share/grub/unicode.pf2"
fi

cleanup

mkdir -pv "$TMP_DIR"

cp -rv themes "$TMP_DIR"
mkdir -pv "$TMP_DIR/boot/grub/fonts"

if [[ -f "$GRUB_FONT_SOURCE" ]]; then
    cp -fv "$GRUB_FONT_SOURCE" "$TMP_DIR/boot/grub/fonts/unicode.pf2"
fi

cat > "$TMP_DIR/boot/grub/grub.cfg" <<'EOF'
set default=0
set timeout=5

insmod all_video
insmod gfxterm
insmod gfxmenu
insmod png
insmod jpeg
insmod font

set gfxmode=1920x1200,1280x720,auto
set gfxpayload=keep

terminal_output gfxterm

loadfont /themes/onimai/Anime-font-en.pf2
loadfont /themes/onimai/Anime-font-ru.pf2
loadfont /boot/grub/fonts/unicode.pf2

set theme=/themes/onimai/theme.txt

menuentry "Reboot" {
    reboot
}

menuentry "Power off" {
    halt
}
EOF

grub-mkrescue -o "$TMP_ISO" "$TMP_DIR"

qemu-system-$QEMU_ARCH \
    -M virt -cpu cortex-a57 \
    -bios /usr/share/qemu/edk2-$QEMU_ARCH-code.fd \
    -cdrom "$TMP_ISO" \
    -device virtio-gpu-pci \
    -m 512M \
    -serial stdio \
    -display gtk

cleanup