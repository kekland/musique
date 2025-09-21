#include <stdint.h>
#import <Foundation/Foundation.h>
#import <objc/message.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVAudioSession.h>
#import <MediaPlayer/MPRemoteCommandCenter.h>
#import <MediaPlayer/MPRemoteCommand.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <AppKit/NSImage.h>
#import <CoreMedia/CMTime.h>
#import <Foundation/Foundation.h>
#import "../build/ffigen/musique_darwin-Swift.h"

#if !__has_feature(objc_arc)
#error "This file must be compiled with ARC enabled"
#endif

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

typedef struct {
  int64_t version;
  void* (*newWaiter)(void);
  void (*awaitWaiter)(void*);
  void* (*currentIsolate)(void);
  void (*enterIsolate)(void*);
  void (*exitIsolate)(void);
  int64_t (*getMainPortId)(void);
  bool (*getCurrentThreadOwnsIsolate)(int64_t);
} DOBJC_Context;

id objc_retainBlock(id);

#define BLOCKING_BLOCK_IMPL(ctx, BLOCK_SIG, INVOKE_DIRECT, INVOKE_LISTENER)    \
  assert(ctx->version >= 1);                                                   \
  void* targetIsolate = ctx->currentIsolate();                                 \
  int64_t targetPort = ctx->getMainPortId == NULL ? 0 : ctx->getMainPortId();  \
  return BLOCK_SIG {                                                           \
    void* currentIsolate = ctx->currentIsolate();                              \
    bool mayEnterIsolate =                                                     \
        currentIsolate == NULL &&                                              \
        ctx->getCurrentThreadOwnsIsolate != NULL &&                            \
        ctx->getCurrentThreadOwnsIsolate(targetPort);                          \
    if (currentIsolate == targetIsolate || mayEnterIsolate) {                  \
      if (mayEnterIsolate) {                                                   \
        ctx->enterIsolate(targetIsolate);                                      \
      }                                                                        \
      INVOKE_DIRECT;                                                           \
      if (mayEnterIsolate) {                                                   \
        ctx->exitIsolate();                                                    \
      }                                                                        \
    } else {                                                                   \
      void* waiter = ctx->newWaiter();                                         \
      INVOKE_LISTENER;                                                         \
      ctx->awaitWaiter(waiter);                                                \
    }                                                                          \
  };


Protocol* _DarwinNativeBindings_AVAsynchronousKeyValueLoading(void) { return @protocol(AVAsynchronousKeyValueLoading); }

typedef void  (^ListenerTrampoline)(id arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline _DarwinNativeBindings_wrapListenerBlock_pfv6jd(ListenerTrampoline block) NS_RETURNS_RETAINED {
  return ^void(id arg0, id arg1) {
    objc_retainBlock(block);
    block((__bridge id)(__bridge_retained void*)(arg0), (__bridge id)(__bridge_retained void*)(arg1));
  };
}

typedef void  (^BlockingTrampoline)(void * waiter, id arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline _DarwinNativeBindings_wrapBlockingBlock_pfv6jd(
    BlockingTrampoline block, BlockingTrampoline listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(id arg0, id arg1), {
    objc_retainBlock(block);
    block(nil, (__bridge id)(__bridge_retained void*)(arg0), (__bridge id)(__bridge_retained void*)(arg1));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, (__bridge id)(__bridge_retained void*)(arg0), (__bridge id)(__bridge_retained void*)(arg1));
  });
}

typedef id  (^ProtocolTrampoline)(void * sel);
__attribute__((visibility("default"))) __attribute__((used))
id  _DarwinNativeBindings_protocolTrampoline_1mbt9g9(id target, void * sel) {
  return ((ProtocolTrampoline)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel);
}

typedef AVKeyValueStatus  (^ProtocolTrampoline_1)(void * sel, id arg1, id * arg2);
__attribute__((visibility("default"))) __attribute__((used))
AVKeyValueStatus  _DarwinNativeBindings_protocolTrampoline_qz1oen(id target, void * sel, id arg1, id * arg2) {
  return ((ProtocolTrampoline_1)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2);
}

typedef void  (^ListenerTrampoline_1)();
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_1 _DarwinNativeBindings_wrapListenerBlock_1pl9qdv(ListenerTrampoline_1 block) NS_RETURNS_RETAINED {
  return ^void() {
    objc_retainBlock(block);
    block();
  };
}

typedef void  (^BlockingTrampoline_1)(void * waiter);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_1 _DarwinNativeBindings_wrapBlockingBlock_1pl9qdv(
    BlockingTrampoline_1 block, BlockingTrampoline_1 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(), {
    objc_retainBlock(block);
    block(nil);
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter);
  });
}

typedef void  (^ListenerTrampoline_2)(id arg0);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_2 _DarwinNativeBindings_wrapListenerBlock_xtuoz7(ListenerTrampoline_2 block) NS_RETURNS_RETAINED {
  return ^void(id arg0) {
    objc_retainBlock(block);
    block((__bridge id)(__bridge_retained void*)(arg0));
  };
}

typedef void  (^BlockingTrampoline_2)(void * waiter, id arg0);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_2 _DarwinNativeBindings_wrapBlockingBlock_xtuoz7(
    BlockingTrampoline_2 block, BlockingTrampoline_2 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(id arg0), {
    objc_retainBlock(block);
    block(nil, (__bridge id)(__bridge_retained void*)(arg0));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, (__bridge id)(__bridge_retained void*)(arg0));
  });
}

typedef void  (^ListenerTrampoline_3)(void * arg0, id arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_3 _DarwinNativeBindings_wrapListenerBlock_jk1ljc(ListenerTrampoline_3 block) NS_RETURNS_RETAINED {
  return ^void(void * arg0, id arg1, id arg2) {
    objc_retainBlock(block);
    block(arg0, (__bridge id)(__bridge_retained void*)(arg1), objc_retainBlock(arg2));
  };
}

typedef void  (^BlockingTrampoline_3)(void * waiter, void * arg0, id arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_3 _DarwinNativeBindings_wrapBlockingBlock_jk1ljc(
    BlockingTrampoline_3 block, BlockingTrampoline_3 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(void * arg0, id arg1, id arg2), {
    objc_retainBlock(block);
    block(nil, arg0, (__bridge id)(__bridge_retained void*)(arg1), objc_retainBlock(arg2));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, (__bridge id)(__bridge_retained void*)(arg1), objc_retainBlock(arg2));
  });
}

typedef void  (^ProtocolTrampoline_2)(void * sel, id arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
void  _DarwinNativeBindings_protocolTrampoline_jk1ljc(id target, void * sel, id arg1, id arg2) {
  return ((ProtocolTrampoline_2)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2);
}

typedef void  (^ListenerTrampoline_4)(BOOL arg0);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_4 _DarwinNativeBindings_wrapListenerBlock_1s56lr9(ListenerTrampoline_4 block) NS_RETURNS_RETAINED {
  return ^void(BOOL arg0) {
    objc_retainBlock(block);
    block(arg0);
  };
}

typedef void  (^BlockingTrampoline_4)(void * waiter, BOOL arg0);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_4 _DarwinNativeBindings_wrapBlockingBlock_1s56lr9(
    BlockingTrampoline_4 block, BlockingTrampoline_4 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(BOOL arg0), {
    objc_retainBlock(block);
    block(nil, arg0);
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0);
  });
}

Protocol* _DarwinNativeBindings_AVVideoCompositing(void) { return @protocol(AVVideoCompositing); }

Protocol* _DarwinNativeBindings_AVMetricEventStreamPublisher(void) { return @protocol(AVMetricEventStreamPublisher); }

typedef void  (^ListenerTrampoline_5)(CMTime arg0);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_5 _DarwinNativeBindings_wrapListenerBlock_1hznzoi(ListenerTrampoline_5 block) NS_RETURNS_RETAINED {
  return ^void(CMTime arg0) {
    objc_retainBlock(block);
    block(arg0);
  };
}

typedef void  (^BlockingTrampoline_5)(void * waiter, CMTime arg0);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_5 _DarwinNativeBindings_wrapBlockingBlock_1hznzoi(
    BlockingTrampoline_5 block, BlockingTrampoline_5 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(CMTime arg0), {
    objc_retainBlock(block);
    block(nil, arg0);
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0);
  });
}

typedef void  (^ListenerTrampoline_6)(BOOL arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_6 _DarwinNativeBindings_wrapListenerBlock_hk7n97(ListenerTrampoline_6 block) NS_RETURNS_RETAINED {
  return ^void(BOOL arg0, id arg1) {
    objc_retainBlock(block);
    block(arg0, (__bridge id)(__bridge_retained void*)(arg1));
  };
}

typedef void  (^BlockingTrampoline_6)(void * waiter, BOOL arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_6 _DarwinNativeBindings_wrapBlockingBlock_hk7n97(
    BlockingTrampoline_6 block, BlockingTrampoline_6 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(BOOL arg0, id arg1), {
    objc_retainBlock(block);
    block(nil, arg0, (__bridge id)(__bridge_retained void*)(arg1));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, (__bridge id)(__bridge_retained void*)(arg1));
  });
}

Protocol* _DarwinNativeBindings_AVAudioSessionDelegate(void) { return @protocol(AVAudioSessionDelegate); }

Protocol* _DarwinNativeBindings_AVAudioPlayerDelegate(void) { return @protocol(AVAudioPlayerDelegate); }

Protocol* _DarwinNativeBindings_NSPasteboardReading(void) { return @protocol(NSPasteboardReading); }

Protocol* _DarwinNativeBindings_NSPasteboardWriting(void) { return @protocol(NSPasteboardWriting); }

typedef id  (^ProtocolTrampoline_3)(void * sel, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
id  _DarwinNativeBindings_protocolTrampoline_xr62hr(id target, void * sel, id arg1) {
  return ((ProtocolTrampoline_3)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1);
}

Protocol* _DarwinNativeBindings_NSImageDelegate(void) { return @protocol(NSImageDelegate); }

typedef BOOL  (^ProtocolTrampoline_4)(void * sel);
__attribute__((visibility("default"))) __attribute__((used))
BOOL  _DarwinNativeBindings_protocolTrampoline_e3qsqz(id target, void * sel) {
  return ((ProtocolTrampoline_4)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel);
}

typedef void  (^ListenerTrampoline_7)(void * arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_7 _DarwinNativeBindings_wrapListenerBlock_18v1jvf(ListenerTrampoline_7 block) NS_RETURNS_RETAINED {
  return ^void(void * arg0, id arg1) {
    objc_retainBlock(block);
    block(arg0, (__bridge id)(__bridge_retained void*)(arg1));
  };
}

typedef void  (^BlockingTrampoline_7)(void * waiter, void * arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_7 _DarwinNativeBindings_wrapBlockingBlock_18v1jvf(
    BlockingTrampoline_7 block, BlockingTrampoline_7 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(void * arg0, id arg1), {
    objc_retainBlock(block);
    block(nil, arg0, (__bridge id)(__bridge_retained void*)(arg1));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, (__bridge id)(__bridge_retained void*)(arg1));
  });
}

typedef void  (^ProtocolTrampoline_5)(void * sel, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
void  _DarwinNativeBindings_protocolTrampoline_18v1jvf(id target, void * sel, id arg1) {
  return ((ProtocolTrampoline_5)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1);
}

typedef NSPasteboardReadingOptions  (^ProtocolTrampoline_6)(void * sel, id arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
NSPasteboardReadingOptions  _DarwinNativeBindings_protocolTrampoline_1jypdhr(id target, void * sel, id arg1, id arg2) {
  return ((ProtocolTrampoline_6)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2);
}

typedef id  (^ProtocolTrampoline_7)(void * sel, id arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
id  _DarwinNativeBindings_protocolTrampoline_zi5eed(id target, void * sel, id arg1, id arg2) {
  return ((ProtocolTrampoline_7)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2);
}

typedef NSPasteboardWritingOptions  (^ProtocolTrampoline_8)(void * sel, id arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
NSPasteboardWritingOptions  _DarwinNativeBindings_protocolTrampoline_zs9fen(id target, void * sel, id arg1, id arg2) {
  return ((ProtocolTrampoline_8)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2);
}

typedef id  (^ProtocolTrampoline_9)(void * sel, id arg1, id arg2, id * arg3);
__attribute__((visibility("default"))) __attribute__((used))
id  _DarwinNativeBindings_protocolTrampoline_10z9f5k(id target, void * sel, id arg1, id arg2, id * arg3) {
  return ((ProtocolTrampoline_9)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2, arg3);
}

typedef NSItemProviderRepresentationVisibility  (^ProtocolTrampoline_10)(void * sel, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
NSItemProviderRepresentationVisibility  _DarwinNativeBindings_protocolTrampoline_1ldqghh(id target, void * sel, id arg1) {
  return ((ProtocolTrampoline_10)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1);
}

typedef id  (^ProtocolTrampoline_11)(void * sel, id arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
id  _DarwinNativeBindings_protocolTrampoline_1q0i84(id target, void * sel, id arg1, id arg2) {
  return ((ProtocolTrampoline_11)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2);
}
#undef BLOCKING_BLOCK_IMPL

#pragma clang diagnostic pop
