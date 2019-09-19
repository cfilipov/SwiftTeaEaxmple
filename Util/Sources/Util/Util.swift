import Foundation
import Combine

@available(OSX 10.11, *)
@available(iOS 9.0, *)
public func ordinal(_ n: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    return formatter.string(for: n) ?? ""
}

public func isPrime (_ p: Int) -> Bool {
    if p <= 1 { return false }
    if p <= 3 { return true }
    for i in 2...Int(sqrtf(Float(p))) {
        if p % i == 0 { return false }
    }
    return true
}

public func compose<A, B, C>(
    _ f: @escaping (B) -> C,
    _ g: @escaping (A) -> B
)
    -> (A) -> C {

        return { (a: A) -> C in
            f(g(a))
        }
}

public func with<A, B>(_ a: A, _ f: (A) throws -> B) rethrows -> B {
    return try f(a)
}

public extension Optional {
    func toResult<Failure>(failure: Failure) -> Result<Wrapped, Failure> {
        if let value = self {
            return .success(value)
        } else {
            return .failure(failure)
        }
    }
}

/// A type-erased error which wraps an arbitrary error instance. This should be
/// useful for generic contexts.
/// https://github.com/antitypical/Result/blob/master/Result/AnyError.swift
public struct AnyError: Swift.Error {
    /// The underlying error.
    public let error: Swift.Error

    public init(_ error: Swift.Error) {
        if let anyError = error as? AnyError {
            self = anyError
        } else {
            self.error = error
        }
        print(self.error.localizedDescription)
    }

    struct ErrorMessage: Error {
        let message: String
    }

    public init(_ message: String = "Unknown Error") {
        if message == "Unknown Error" {
            print("Unknown Error")
        }
        self.init(ErrorMessage(message: message))
    }
}

@available(iOS 13.0, *)
public final class ObservableValue<T>: ObservableObject {
    @Published public var value: T

    public init(_ value: T) {
        self.value = value
    }
}
