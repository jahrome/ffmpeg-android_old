LOCAL_PATH := $(call my-dir)

LIB_PATH := build/ffmpeg/lib/

include $(CLEAR_VARS)

LOCAL_PREBUILT_LIBS := \
	$(LIB_PATH)/libavformat.so	\
	$(LIB_PATH)/libavutil.so	\
	$(LIB_PATH)/libswscale.so	\
	$(LIB_PATH)/libavcodec.so	

include $(BUILD_MULTI_PREBUILT)
