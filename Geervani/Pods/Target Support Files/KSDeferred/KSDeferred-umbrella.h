#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "KSCancellable.h"
#import "KSDeferred.h"
#import "KSGenericsCompat.h"
#import "KSNetworkClient.h"
#import "KSNullabilityCompat.h"
#import "KSPromise.h"
#import "KSURLConnectionClient.h"
#import "KSURLSessionClient.h"

FOUNDATION_EXPORT double KSDeferredVersionNumber;
FOUNDATION_EXPORT const unsigned char KSDeferredVersionString[];

