# proprietary side of the device
$(call inherit-product-if-exists, vendor/zte/mooncake-common/mooncake-common-vendor.mk)

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

$(call inherit-product, device/common/gps/gps_eu_supl.mk)

DEVICE_PACKAGE_OVERLAYS := device/zte/mooncake-common/overlay

# Discard inherited values and use our own instead.
PRODUCT_MANUFACTURER := ZTE

PRODUCT_PACKAGES += \
    LiveWallpapers \
    LiveWallpapersPicker \
    VisualizationWallpapers \
    MagicSmokeWallpapers \
    VisualizationWallpapers \
    librs_jni \
    Gallery3d \
    SpareParts \
    Development \
    Term \
    copybit.mooncake \
    gps.mooncake \
    lights.mooncake \
    libOmxCore \
    libOmxVidEnc \
    FM \
    abtfilt \
    RacerParts \
    dexpreopt

DISABLE_DEXPREOPT := false

# Keypad
PRODUCT_COPY_FILES += \
    device/zte/mooncake-common/prebuilt/usr/keylayout/mooncake-keypad.kl:system/usr/keylayout/mooncake-keypad.kl

# Vold
PRODUCT_COPY_FILES += \
    device/zte/mooncake-common/prebuilt/etc/vold.fstab:system/etc/vold.fstab

# Audio + Media profiles
PRODUCT_COPY_FILES += \
    device/zte/mooncake-common/prebuilt/etc/AudioFilter.csv:system/etc/AudioFilter.csv \
    device/zte/mooncake-common/prebuilt/etc/AutoVolumeControl.txt:system/etc/AutoVolumeControl.txt \
    device/zte/mooncake-common/prebuilt/etc/media_profiles.xml:system/etc/media_profiles.xml

# WLAN + BT
PRODUCT_COPY_FILES += \
    device/zte/mooncake-common/prebuilt/etc/init.bt.sh:system/etc/init.bt.sh \
    device/zte/mooncake-common/prebuilt/etc/init.qcom.bt.sh:system/etc/init.qcom.bt.sh \
    device/zte/mooncake-common/prebuilt/etc/wifi/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf \
    device/zte/mooncake-common/prebuilt/etc/wifi/hostapd.conf:system/etc/wifi/hostapd.conf \
    device/zte/mooncake-common/prebuilt/etc/dhcpd/dhcpcd.conf:system/etc/dhcpcd/dhcpcd.conf

# Install the features available on this device.
PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/base/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/base/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/base/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/base/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/base/data/etc/android.hardware.touchscreen.multitouch.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:/system/etc/permissions/android.software.live_wallpaper.xml

# WiFi firmware
PRODUCT_COPY_FILES += \
    device/zte/mooncake-common/prebuilt/wifi/ar6000.ko:system/wifi/ar6000.ko \
    device/zte/mooncake-common/prebuilt/wifi/regcode:system/wifi/regcode \
    device/zte/mooncake-common/prebuilt/wifi/data.patch.hw2_0.bin:system/wifi/data.patch.hw2_0.bin \
    device/zte/mooncake-common/prebuilt/wifi/athwlan.bin.z77:system/wifi/athwlan.bin.z77 \
    device/zte/mooncake-common/prebuilt/wifi/athtcmd_ram.bin:system/wifi/athtcmd_ram.bin \
    device/zte/mooncake-common/prebuilt/wifi/device.bin:system/wifi/device.bin \
    device/zte/mooncake-common/prebuilt/wifi/eeprom.bin:system/wifi/eeprom.bin \
    device/zte/mooncake-common/prebuilt/wifi/eeprom.data:system/wifi/eeprom.data

# Mooncake uses low and medium-density artwork where available
PRODUCT_LOCALES += ldpi mdpi

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

# Properties
PRODUCT_PROPERTY_OVERRIDES += \
    rild.libpath=/system/lib/libril-qc-1.so \
    rild.libargs=-d /dev/smd0 \
    dalvik.vm.lockprof.threshold=500 \
    dalvik.vm.dexopt-flags=m=y \
    dalvik.vm.heapsize=32m \
    dalvik.vm.execution-mode=int:jit \
    dalvik.vm.dexopt-data-only=1 \
    qemu.sf.lcd_density=120 \
    ro.sf.lcd_density=120 \
    ro.sf.hwrotation=0 \
    wifi.interface=wlan0 \
    wifi.supplicant_scan_interval=180 \
    ro.ril.hsxpa=2 \
    ro.ril.gprsclass=10 \
    ro.build.baseband_version=P729BB01 \
    ro.telephony.default_network=0 \
    ro.telephony.call_ring.multiple=false \
    ro.com.google.locationfeatures=1 \
    ro.setupwizard.enable_bypass=1 \
    ro.media.dec.jpeg.memcap=20000000 \
    ro.opengles.version=131072 \
    ro.compcache.default=0 \
    debug.sf.hw=0 \
    persist.sys.rotationanimation=false
