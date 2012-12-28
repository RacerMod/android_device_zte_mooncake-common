LOCAL_PATH:= $(call my-dir)
# HAL module implemenation, not prelinked and stored in
# hw/<COPYPIX_HARDWARE_MODULE_ID>.<ro.board.platform>.so

include $(CLEAR_VARS)
ifeq ($(TARGET_GRALLOC_USES_ASHMEM),true)
     LOCAL_CFLAGS += -DUSE_ASHMEM
     LOCAL_CFLAGS += -DTARGET_7x27
endif

LOCAL_MODULE_TAGS := optional
LOCAL_PRELINK_MODULE := false
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_SHARED_LIBRARIES := liblog
LOCAL_SRC_FILES := copybit.cpp
LOCAL_MODULE := copybit.mooncake
LOCAL_C_INCLUDES += device/zte/mooncake/libgralloc
LOCAL_CFLAGS += -DCOPYBIT_MSM7K=1
include $(BUILD_SHARED_LIBRARY)
