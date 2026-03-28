#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSException * _Nullable catchExceptionOfKind(
  Class type,
  void (^ NS_NOESCAPE inBlock)(void)
);

NS_ASSUME_NONNULL_END
