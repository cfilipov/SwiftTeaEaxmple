import SwiftUI
import SwiftTea
import Wolfram
import Util

public enum Msg {
    case decrTapped
    case incrTapped
    case nthPrimeTapped
    case showIsPrime
    case showNthPrime(Result<Int, Error>)
    case dismiss
}

public struct Model {

    public enum Prime {
        case none
        case showingIsPrime
        case loadingNthPrime
        case showingNthPrime(Int)
    }

    public var count: Int
    public var prime: Prime
}

public let initialModel = Model(
    count: 0,
    prime: .none
)

public let initialCommand: Cmd<Msg> = Cmd.none

public let subscriptions: (Model) -> [Sub<Msg>] = { _ in [] }

func getNthPrime(n: Int) -> Cmd<Msg> {
    .httpGet(urlForPrime(n)) {
        .showNthPrime($0.flatMap(decodePrimeResult))
    }
}

public func update(model: inout Model, msg: Msg) -> Cmd<Msg> {
    switch msg {
    case .decrTapped:
        model.count -= 1
        return Cmd.none
        
    case .incrTapped:
        model.count += 1
        return Cmd.none

    case .nthPrimeTapped:
        model.prime = .loadingNthPrime
        return getNthPrime(n: model.count)

    case .showIsPrime:
        model.prime = .showingIsPrime
        return Cmd.none

    case let .showNthPrime(.success(n)):
        model.prime = .showingNthPrime(n)
        return Cmd.none

    case .showNthPrime(.failure(_)):
        model.prime = .none
        return Cmd.none

    case .dismiss:
        model.prime = .none
        return Cmd.none
    }
}

struct PrimeAlert: Identifiable {
    let prime: Int
    var id: Int { self.prime }
}

extension Model.Prime {

    var none: Bool {
        if case .none = self { return true }
        return false
    }

    var showingIsPrime: Bool {
        if case .showingIsPrime = self { return true }
        return false
    }

    var loadingNthPrime: Bool {
        if case .loadingNthPrime = self { return true }
        return false
    }

    var showingNthPrime: Int? {
        if case let .showingNthPrime(n) = self { return n }
        return nil
    }

}

public struct Content: View {

    let model: Counter.Model
    let send: Send<Counter.Msg>
    let primeModalView: AnyView

    @ObservedObject private var isPrimeModalShown: ObservableValue<Bool>
    @ObservedObject private var alertNthPrime: ObservableValue<PrimeAlert?>

    public var body: some View {
        VStack {
            HStack {
                Button("-") { self.send(.decrTapped) }
                Text("\(model.count)")
                Button("+") { self.send(.incrTapped) }
            }
            Button("Is this prime?") { self.send(.showIsPrime) }
            Button("What is the \(ordinal(model.count)) prime?") {
                self.send(.nthPrimeTapped)
            }
            .disabled(model.prime.loadingNthPrime)
        }
        .font(.title)
        .navigationBarTitle("Counter demo")
        .sheet(
            isPresented: self.$isPrimeModalShown.value,
            onDismiss: { self.send(.dismiss) }
        ) { self.primeModalView }
            .alert(item: self.$alertNthPrime.value) { alert in
            Alert(
                title: Text("The \(ordinal(model.count)) prime is \(alert.prime)"),
                dismissButton: .default(Text("Ok")) { self.send(.dismiss) }
            )
        }
    }

    public init(
        model: Model,
        send: @escaping Send<Msg>,
        primeModalView: AnyView
    ) {
        self.model = model
        self.send = send
        self.primeModalView = primeModalView

        isPrimeModalShown = ObservableValue(model.prime.showingIsPrime)
        alertNthPrime = ObservableValue(model.prime.showingNthPrime.map(PrimeAlert.init(prime:)))
    }
}
