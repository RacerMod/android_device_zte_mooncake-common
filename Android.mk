ifneq ($(filter mooncake mooncakec,$(TARGET_DEVICE)),)
    include $(all-subdir-makefiles)
endif
