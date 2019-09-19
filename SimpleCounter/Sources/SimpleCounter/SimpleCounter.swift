import SwiftUI
import SwiftTea

public struct Model {
    var count: Int
}

public enum Msg {
    case inc
    case dec
}

public let initialModel = Model(
    count: 0
)

public let initialCommand: Cmd<Msg> = Cmd.none

public func subscriptions(_ model: Model) -> [Sub<Msg>] {
    []
}

public func update(model: inout Model, msg: Msg) -> Cmd<Msg> {
    switch msg {
    case .inc:
        model.count += 1
        return Cmd.none
    case .dec:
        model.count += model.count > 0
            ? -1
            : 0
        return Cmd.none
    }
}

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
        }
    }

    public init(model: Model, send: @escaping Send<Msg>) {
        self.model = model
        self.send = send
    }
}
