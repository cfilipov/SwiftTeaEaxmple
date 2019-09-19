import SwiftUI
import SwiftTea
import ActivityIndicator
import Gify
import Util

public struct Model {

    enum Gify {
        case button
        case loading
        case result(GifyItem)
        case resultWithData(GifyItem, Data)
        case error(String)
    }

    var gify: Gify
}

public enum Msg {
    case getRandomGif
    case showGifItem(Result<GifyItem, Error>)
    case showGifData(Result<Data, Error>)
}

func getRandomGif() -> Cmd<Msg> {
    .httpGet(randomGifURL(tag: "cat")) {
        .showGifItem($0.flatMap(decodeGifyItem))
    }
}

func downloadGif(_ url: URL) -> Cmd<Msg> {
    .httpGet(randomGifURL(tag: "cat")) { .showGifData($0) }
}

public let initialModel = Model(
    gify: .button
)

public let initialCommand: Cmd<Msg> = getRandomGif()

public func subscriptions(_ model: Model) -> [Sub<Msg>] {
    []
}

public func update(model: inout Model, msg: Msg) -> Cmd<Msg> {
    switch msg {
    case .getRandomGif:
        model.gify = .loading
        return getRandomGif()

    case let .showGifItem(.success(res)):
        model.gify = .result(res)
        return downloadGif(res.imageURL)

    case let .showGifItem(.failure(err)):
        model.gify = .error(err.localizedDescription)
        return Cmd.none

    case let .showGifData(.success(data)):
        switch model.gify {
        case let .result(res):
            model.gify = .resultWithData(res, data)
        default:
            fatalError("Invalid State")
        }
        return Cmd.none

    case let .showGifData(.failure(err)):
        model.gify = .error(err.localizedDescription)
        return Cmd.none
    }
}

extension Model.Gify {

    var button: ()? {
        if case .button = self { return () }
        if let _ = error { return () }
        if let _ = data { return () }
        return nil
    }

    var loading: ()? {
        if case .loading = self { return () }
        if let _ = error { return nil }
        if let _ = result, data == nil { return () }
        return nil
    }

    var result: GifyItem? {
        if case let .resultWithData(res, _) = self { return res }
        if case let .result(res) = self { return res }
        if let _ = error { return nil }
        return nil
    }

    var data: Data? {
        if case let .resultWithData(_, data) = self { return data }
        if let _ = error { return nil }
        return nil
    }

    var error: String? {
        if case let .error(err) = self { return err }
        return nil
    }
}

public struct Content: TeaView {

    public let model: Model
    public let send: Send<Msg>

    public var body: some View {
        VStack {
            model.gify.result.map { res in Text(res.title) }
            model.gify.error.map { err in Text(err).foregroundColor(.red) }
            model.gify.data.map { data in Text("Bytes: \(data.count)") }
            model.gify.loading.map { ActivityIndicator(style: .large) }
            model.gify.button.map { Button("Get Random Cat Gif") { self.send(.getRandomGif) } }
        }
    }

    public init(model: Model, send: @escaping Send<Msg>) {
        self.model = model
        self.send = send
    }
}
