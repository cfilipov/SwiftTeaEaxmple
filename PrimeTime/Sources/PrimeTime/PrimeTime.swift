import Foundation
import SwiftUI
import Prelude
import SwiftTea
import Counter
import PrimeModal
import FavoritePrimes
import Wolfram
import Util

public struct Model {
    var counter: Counter.Model
    var favoritePrimes: [Int]
    var loggedInUser: User?
    var activityFeed: [Activity]

    struct Activity {
        let timestamp: Date
        let type: ActivityType

        enum ActivityType {
            case addedFavoritePrime(Int)
            case removedFavoritePrime(Int)
        }
    }

    struct User {
        let id: Int
        let name: String
        let bio: String
    }
}

public enum Msg {
    case counter(Counter.Msg)
    case primeModal(PrimeModal.Msg)
    case favoritePrimes(FavoritePrimes.Msg)
}

extension Model {
    var primeModal: PrimeModal.Model {
        get {
            PrimeModal.Model(
                count: counter.count,
                favoritePrimes: self.favoritePrimes
            )
        }
        set {
            counter.count = newValue.count
            favoritePrimes = newValue.favoritePrimes
        }
    }
}

public let initialModel = Model(
    counter: Counter.initialModel,
    favoritePrimes: FavoritePrimes.initialModel,
    loggedInUser: nil,
    activityFeed: []
)

public let initialCommand: Cmd<Msg> = Cmd.batch([
    Counter.initialCommand.map(Msg.counter),
    FavoritePrimes.initialCommand.map(Msg.favoritePrimes)
])

public let subscriptions: (Model) -> [Sub<Msg>] = { _ in [] }

func updateActivityFeed(
    _ update: @escaping (inout Model, Msg) -> Cmd<Msg>
) -> (inout Model, Msg) -> Cmd<Msg> {

    return { model, msg in
        switch msg {
        case .counter:
            break

        case .primeModal(.removeFavoritePrimeTapped):
            model.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(model.counter.count)))

        case .primeModal(.saveFavoritePrimeTapped):
            model.activityFeed.append(.init(timestamp: Date(), type: .addedFavoritePrime(model.counter.count)))

        case let .favoritePrimes(.deleteFavoritePrimes(indexSet)):
            for index in indexSet {
                model.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(model.favoritePrimes[index])))
            }
        }

        return update(&model, msg)
    }
}

private let _update: UpdateFunc<Model, Msg> = combine(
    pullback(Counter.update, model: \.counter, msg: \.counter, msgMap: Msg.counter),
    pullback(PrimeModal.update, model: \.primeModal, msg: \.primeModal, msgMap: Msg.primeModal),
    pullback(FavoritePrimes.update, model: \.favoritePrimes, msg: \.favoritePrimes, msgMap: Msg.favoritePrimes)
)

// Alternately, explicitly construct update.

//public func _update(model: inout Model, msg: Msg) -> Cmd<Msg> {
//    switch msg {
//    case let .counter(subMsg):
////        updateWith(Counter.update, &model.count, subMsg) { .counter($0) }
//        return Counter.update(model: &model.counter, msg: subMsg).map(Msg.counter)
//
//    case let .primeModal(subMsg):
//        return PrimeModal.update(model: &model.primeModal, msg: subMsg).map(Msg.primeModal)
//
//    case let .favoritePrimes(subMsg):
//        return FavoritePrimes.update(model: &model.favoritePrimes, msg: subMsg).map(Msg.favoritePrimes)
//
//    }
//}

public let update = _update
    |> logging <<< updateActivityFeed // with(_update, compose(logging, updateActivityFeed))

public struct Content: TeaView {
    public let model: Model
    public let send: Send<Msg>

    public var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    "Counter demo",
                    destination: Counter.Content(
                        model: model.counter,
                        send: send <<< Msg.counter, // compose(send, Msg.counter)
                        primeModalView: AnyView(PrimeModal.Content(
                            model: model.primeModal,
                            send: send <<< Msg.primeModal // compose(send, Msg.primeModal)
                        ))
                    )
                )
                NavigationLink(
                    "Favorite primes",
                    destination: FavoritePrimes.Content(
                        model: model.favoritePrimes,
                        send: send <<< Msg.favoritePrimes // compose(send, Msg.favoritePrimes)
                    )
                )
            }
            .navigationBarTitle("State management")
        }
    }

    public init(model: Model, send: @escaping Send<Msg>) {
        self.model = model
        self.send = send
    }
}

extension Msg {
    var counter: Counter.Msg? {
        get {
            guard case let .counter(value) = self else { return nil }
            return value
        }
        set {
            guard case .counter = self, let newValue = newValue else { return }
            self = .counter(newValue)
        }
    }

    var primeModal: PrimeModal.Msg? {
        get {
            guard case let .primeModal(value) = self else { return nil }
            return value
        }
        set {
            guard case .primeModal = self, let newValue = newValue else { return }
            self = .primeModal(newValue)
        }
    }

    var favoritePrimes: FavoritePrimes.Msg? {
        get {
            guard case let .favoritePrimes(value) = self else { return nil }
            return value
        }
        set {
            guard case .favoritePrimes = self, let newValue = newValue else { return }
            self = .favoritePrimes(newValue)
        }
    }
}
