import Foundation

public typealias UpdateFunc<Model, Msg> = (inout Model, Msg) -> Cmd<Msg>
public typealias Expect<T, Msg> = (T) -> Msg

@available(OSX 10.15, *)
@available(iOS 13.0, *)
public final class AppState<Model, Msg>: ObservableObject {

    private let update: UpdateFunc<Model, Msg>
    @Published public private(set) var model: Model

    public init(
        initialModel: Model,
        subscriptions: @escaping (Model) -> [Sub<Msg>],
        update: @escaping UpdateFunc<Model, Msg>
    ) {
        self.update = update
        self.model = initialModel
    }

    public func send(_ msg: Msg) {
        DispatchQueue.main.async {
            let cmd = self.update(&self.model, msg)
            cmd.exec(self.send)
        }
    }
}

public func combine<Model, Msg>(
    _ updaters: UpdateFunc<Model, Msg>...
) -> UpdateFunc<Model, Msg> {
    return { model, msg in
        updaters.reduce(Cmd.none) { acc, update in
            .batch([acc, update(&model, msg)])
        }
    }
}

public func updateWith<LocalModel, LocalMsg, GlobalMsg>(
    _ update: UpdateFunc<LocalModel, LocalMsg>,
    _ localModel: inout LocalModel,
    _ localMsg: LocalMsg,
    _ cmdMap: @escaping (LocalMsg) -> GlobalMsg
) -> Cmd<GlobalMsg> {
    update(&localModel, localMsg).map(cmdMap)
}

public func pullback<LocalModel, GlobalModel, LocalMsg, GlobalMsg>(
    _ update: @escaping (inout LocalModel, LocalMsg) -> Cmd<LocalMsg>,
    model: WritableKeyPath<GlobalModel, LocalModel>,
    msg: WritableKeyPath<GlobalMsg, LocalMsg?>,
    msgMap: @escaping (LocalMsg) -> GlobalMsg
) -> (inout GlobalModel, GlobalMsg) -> Cmd<GlobalMsg> {

    return { globalModel, globalMsg in
        guard let localMsg = globalMsg[keyPath: msg] else { return Cmd.none }
        return update(&globalModel[keyPath: model], localMsg).map(msgMap)
    }
}

public func logging<Model, Msg>(
    _ update: @escaping (inout Model, Msg) -> Cmd<Msg>
) -> (inout Model, Msg) -> Cmd<Msg> {

    return { model, msg in
        let cmd = update(&model, msg)
        print("Message: \(msg)")
        print("Model:")
        dump(model)
        print("Cmds:")
        dump(cmd)
        print("---")
        return cmd
    }
}

// MARK: Subscriptions

public enum Sub<Msg> {
    case timer(TimeInterval, Expect<Void, Msg>)
}

// MARK: Commands

public enum Cmd<Msg> {
    case none
    case httpGet(URL, Expect<Result<Data, Error>, Msg>)
    case delay(TimeInterval, Expect<Void, Msg>)
    case batch([Cmd<Msg>])
}

extension Cmd {
    internal func exec(_ send: @escaping (Msg) -> Void) {
        switch self {
        case .none:
            return

        case let .httpGet(url, expect):
            URLSession.shared.dataTask(with: url) { data, response, error in
                let res: Result<Data, Error> = error.flatMap { .failure($0) } ?? .success(data!)
                send(expect(res))
            }
            .resume()

        case let .delay(seconds, expect):
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                send(expect(()))
            }

        case let .batch(cmds):
            cmds.forEach { $0.exec(send) }
        }
    }

    public func map<OutMsg>(_ f: @escaping (Msg) -> OutMsg) -> Cmd<OutMsg> {
        switch self {
        case .none:
            return .none

        case let .httpGet(url, expect):
            return .httpGet(url) { f(expect($0)) }

        case let .delay(seconds, expect):
            return .delay(seconds) { f(expect($0)) }

        case let .batch(cmds):
            return .batch(cmds.map { $0.map(f) })
        }
    }

    public func append(_ cmd: Cmd<Msg>) -> Cmd<Msg> {
        if case let .batch(cmds) = self {
            return .batch(cmds + [cmd])
        } else {
            return .batch([cmd, self])
        }
    }
}
