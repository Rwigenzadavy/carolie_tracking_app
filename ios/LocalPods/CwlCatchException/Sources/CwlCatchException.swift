import Foundation

#if SWIFT_PACKAGE || COCOAPODS
import CwlCatchExceptionSupport
#endif

private func catchReturnTypeConverter<Exception: NSException>(
  _ type: Exception.Type,
  block: () -> Void
) -> Exception? {
  catchExceptionOfKind(type, block) as? Exception
}

extension NSException {
  public static func catchException(in block: () -> Void) -> Self? {
    catchReturnTypeConverter(self, block: block)
  }
}

public func catchExceptionAsError<Output>(in block: (() throws -> Output)) throws -> Output {
  var result: Result<Output, Error>?

  let exception = NSException.catchException {
    result = Result(catching: block)
  }

  if let exception {
    throw ExceptionError(exception)
  }

  return try result!.get()
}

#if compiler(<6.0)
extension NSException: @unchecked Sendable {}
#else
extension NSException: @unchecked @retroactive Sendable {}
#endif

public struct ExceptionError: CustomNSError {
  public let exception: NSException
  public let domain = "com.cocoawithlove.catch-exception"
  public let errorUserInfo: [String: Any]

  public init(_ exception: NSException) {
    self.exception = exception

    if let userInfo = exception.userInfo {
      self.errorUserInfo = [String: Any](
        uniqueKeysWithValues: userInfo.map { pair in
          (pair.key.description, pair.value)
        }
      )
    } else {
      self.errorUserInfo = [:]
    }
  }
}
