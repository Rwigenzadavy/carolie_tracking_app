#import <CwlCatchException.h>

NSException * _Nullable catchExceptionOfKind(
  Class _Nonnull type,
  void (^ NS_NOESCAPE _Nonnull inBlock)(void)
) {
  @try {
    inBlock();
  } @catch (NSException *exception) {
    if ([exception isKindOfClass:type]) {
      return exception;
    } else {
      @throw;
    }
  }
  return nil;
}
