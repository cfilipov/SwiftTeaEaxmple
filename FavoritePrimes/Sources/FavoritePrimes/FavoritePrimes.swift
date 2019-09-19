import Foundation
import SwiftUI
import SwiftTea

public enum Msg {
    case deleteFavoritePrimes(IndexSet)
}

public typealias Model = [Int]

public let initialModel: Model = []

public let initialCommand: Cmd<Msg> = Cmd.none

public let subscriptions: (Model) -> [Sub<Msg>] = { _ in [] }

public func update(model: inout Model, msg: Msg) ->  Cmd<Msg> {
    switch msg {
    case let .deleteFavoritePrimes(indexSet):
        for index in indexSet {
            model.remove(at: index)
        }
    }
    return Cmd.none
}

public struct Content: View {
    public let model: FavoritePrimes.Model
    public let send: Send<FavoritePrimes.Msg>

    public var body: some View {
        List {
            ForEach(model, id: \.self) { prime in
                Text("\(prime)")
            }
            .onDelete { indexSet in
                self.send(.deleteFavoritePrimes(indexSet))
            }
        }
        .navigationBarTitle("Favorite primes")
    }

    public init(model: Model, send: @escaping Send<Msg>) {
        self.model = model
        self.send = send
    }
}
