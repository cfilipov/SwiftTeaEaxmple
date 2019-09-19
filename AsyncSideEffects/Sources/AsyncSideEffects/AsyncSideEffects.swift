import SwiftUI
import SwiftTea
import ActivityIndicator
import Wolfram
import Util

public struct Model {

    enum Prime {
        case button
        case loading
        case nthPrime(Int)
    }

    var count: Int
    var prime: Prime
}

public enum Msg {
    case inc
    case dec
    case getNthPrime
    case showNthPrime(Result<Int, Error>)
}

func getNthPrime(n: Int) -> Cmd<Msg> {
    .httpGet(urlForPrime(n)) {
        .showNthPrime($0.flatMap(decodePrimeResult))
    }
}

public let initialModel = Model(
    count: 0,
    prime: .button
)

public let initialCommand: Cmd<Msg> = Cmd.none

public func subscriptions(_ model: Model) -> [Sub<Msg>] {
    []
}

public func update(model: inout Model, msg: Msg) -> Cmd<Msg> {
    switch msg {
    case .inc:
        model.prime = .button
        model.count += 1
        return Cmd.none

    case .dec:
        model.prime = .button
        model.count += model.count > 0
            ? -1
            : 0
        return Cmd.none

    case .getNthPrime:
        model.prime = .loading
        return getNthPrime(n: model.count)

    case let .showNthPrime(.success(n)):
        model.prime = .nthPrime(n)
        return Cmd.none

    case .showNthPrime(.failure(_)):
        model.prime = .button
        return Cmd.none
    }
}

@available(OSX 10.15, *)
func prime(_ model: Model, _ send: @escaping Send<Msg>) -> AnyView {
    switch model.prime {
    case .button:
        return AnyView(
            Button("Get \(ordinal(model.count)) prime") {
                send(.getNthPrime)
            }
        )

    case .loading:
        return AnyView(
            ActivityIndicator(style: .large)
        )

    case .nthPrime(let prime):
        return AnyView(
            Text("The \(ordinal(model.count)) prime is \(prime)")
        )
    }
}

@available(OSX 10.15, *)
public struct Content: TeaView {

    public let model: Model
    public let send: Send<Msg>

    public var body: some View {
        VStack {
            Text("Count: \(model.count)")
            HStack {
                Button("-") { self.send(.dec) }
                Button("+") { self.send(.inc) }
            }
            prime(model, send)
        }
    }

    public init(model: Model, send: @escaping Send<Msg>) {
        self.model = model
        self.send = send
    }
}
