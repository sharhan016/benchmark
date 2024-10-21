LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := cpu_info
LOCAL_SRC_FILES := cpu_info.c

APP_PLATFORM := android-21

include $(BUILD_SHARED_LIBRARY)