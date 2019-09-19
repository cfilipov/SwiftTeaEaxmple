import SwiftUI
import SwiftTea
import Util

public typealias Model = (count: Int, favoritePrimes: [Int])

public enum Msg {
    case saveFavoritePrimeTapped
    case removeFavoritePrimeTapped
}

public func update(model: inout Model, msg: Msg) -> Cmd<Msg> {
    switch msg {
    case .removeFavoritePrimeTapped:
        model.favoritePrimes.removeAll(where: { $0 == model.count })

    case .saveFavoritePrimeTapped:
        model.favoritePrimes.append(model.count)
    }
    return Cmd.none
}

public let initialModel = Model(
    count: 0,
    favoritePrimes: []
)

public let initialCommand: Cmd<Msg> = Cmd.none

public let subscriptions: (Model) -> [Sub<Msg>] = { _ in [] }

public struct Content: View {
    public let model: Model
    public let send: Send<Msg>

    public var body: some View {
        VStack {
            if isPrime(model.count) {
                Text("\(model.count) is prime 🎉")
                if model.favoritePrimes.contains(model.count) {
                    Button("Remove from favorite primes") {
                        self.send(.removeFavoritePrimeTapped)
                    }
                } else {
                    Button("Save to favorite primes") {
                        self.send(.saveFavoritePrimeTapped)
                    }
                }
            } else {
                Text("\(model.count) is not prime :(")
            }
        }
    }

    public init(model: Model, send: @escaping Send<Msg>) {
        self.model = model
        self.send = send
    }
}
