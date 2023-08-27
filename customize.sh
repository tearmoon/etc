### INSTALLATION ###
# # speed / speed-profile / bg-dexopt
# MODE="bg-dexopt"

if [ "$BOOTMODE" != true ]; then
  ui_print "-----------------------------------------------------------"
  ui_print "! Please install in Magisk Manager or KernelSU Manager"
  ui_print "! Install from recovery is NOT supported"
  abort "-----------------------------------------------------------"
elif [ "$KSU" = true ] && [ "$KSU_VER_CODE" -lt 10670 ]; then
  abort "ERROR: Please update your KernelSU and KernelSU Manager"
fi

# check android
if [ "$API" -lt 30 ]; then
  ui_print "! Unsupported sdk: $API"
  abort "! Minimal supported sdk is 30 (Android 11)"
else
  ui_print "- Device sdk: $API"
fi

# check version
service_dir="/data/adb/service.d"
if [ "$KSU" = true ]; then
  ui_print "- kernelSU version: $KSU_VER ($KSU_VER_CODE)"
  [ "$KSU_VER_CODE" -lt 10683 ] && service_dir="/data/adb/ksu/service.d"
else
  ui_print "- Magisk version: $MAGISK_VER ($MAGISK_VER_CODE)"
fi

if [ ! -d "${service_dir}" ]; then
  mkdir -p "${service_dir}"
fi

# Install ETC
ui_print "- Installing ETC"
ui_print "- Extract the files uninstall.sh and etc_service.sh"
# ui_print "- Mode = $MODE"
unzip -o "$ZIPFILE" -x 'META-INF/*' -d "$MODPATH" >&2
unzip -j -o "$ZIPFILE" 'uninstall.sh' -d "$MODPATH" >&2
unzip -j -o "$ZIPFILE" 'etc_service.sh' -d "$service_dir" >&2

# ui_print starting configuration
# ui_print "- Starting Configuration"
# ui_print "$(date)"
# ui_print "--------------------------------------------------"

# Loop through each installed app and compile using bg-dexopt
# cmd package list packages | cut -f 2 -d ":" | while IFS= read -r app; do
    # result=$(cmd package compile -r "$MODE" "$app")
    # ui_print "$app | $result"
# done

set_perm_recursive $MODPATH 0 0 0755 0644
set_perm_recursive $service_dir 0 0 0755 0755
set_perm $MODPATH/uninstall.sh  0  0  0755
set_perm $service_dir/etc_service.sh  0  0  0755

# description() {
    # current_time=$(date +"%I:%M %P")
    # sed -Ei "s/^description=(\[.*][[:space:]]*)?/description=[ 🤩 $current_time | mode: $MODE !!! ] /g" $MODPATH/module.prop
# }

# description

rm -f $MODPATH/etc_service.sh