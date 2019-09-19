import Combine
import SwiftUI

public typealias Send<Msg> = (Msg) -> Void

public protocol TeaView: View {
    associatedtype Model
    associatedtype Msg

    var model: Model { get }
    var send: Send<Msg> { get }
}

@available(OSX 10.15, *)
@available(iOS 13.0, *)
public struct RootView<Model, Msg, V: View>: View {

    @ObservedObject private var store: AppState<Model, Msg>
    private let view: (Model, @escaping Send<Msg>) -> V
    private let initialCommand: Cmd<Msg>

    public init(
        initialModel: Model,
        initialCommand: Cmd<Msg>,
        subscriptions: @escaping (Model) -> [Sub<Msg>],
        update: @escaping (inout Model, Msg) -> Cmd<Msg>,
        view: @escaping (Model, @escaping Send<Msg>) -> V
    ) {
        self.store = AppState(
            initialModel: initialModel,
            subscriptions: subscriptions,
            update: update
        )
        self.view = view
        self.initialCommand = initialCommand
    }

    public var body: some View {
        view(store.model, store.send)
    }
}
