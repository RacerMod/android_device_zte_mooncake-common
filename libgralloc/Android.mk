LOCAL_PATH := $(call my-dir)

# HAL module implemenation, not prelinked and stored in
# hw/<OVERLAY_HARDWARE_MODULE_ID>.<ro.product.board>.so
include $(CLEAR_VARS)
LOCAL_PRELINK_MODULE := false
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_SHARED_LIBRARIES := liblog libcutils libGLESv1_CM

LOCAL_SRC_FILES := 	\
	allocator.cpp 	\
	framebuffer.cpp \
	gpu.cpp			\
	gralloc.cpp		\
	mapper.cpp		\
	pmemalloc.cpp

LOCAL_MODULE_TAGS := optional
	
LOCAL_MODULE := gralloc.$(TARGET_BOOTLOADER_BOARD_NAME)
LOCAL_CFLAGS:= -DLOG_TAG=\"$(TARGET_BOOTLOADER_BOARD_NAME).gralloc\"

LOCAL_CFLAGS += -DTARGET_MSM7x27

ifeq ($(TARGET_HAVE_HDMI_OUT),true)
LOCAL_CFLAGS += -DHDMI_DUAL_DISPLAY
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../liboverlay
LOCAL_SHARED_LIBRARIES += liboverlay
endif

ifeq ($(TARGET_GRALLOC_USES_ASHMEM),true)
LOCAL_CFLAGS += -DUSE_ASHMEM
endif
include $(BUILD_SHARED_LIBRARY)
