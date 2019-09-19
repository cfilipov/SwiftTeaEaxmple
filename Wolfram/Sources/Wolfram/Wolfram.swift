import Foundation
import Util

private let wolframAlphaApiKey = "6H69Q3-828TKQJ4EP"

private struct WolframAlphaResult: Decodable {
  let queryresult: QueryResult

  struct QueryResult: Decodable {
    let pods: [Pod]

    struct Pod: Decodable {
      let primary: Bool?
      let subpods: [SubPod]

      struct SubPod: Decodable {
        let plaintext: String
      }
    }
  }
}

private func urlForQuery(_ query: String) -> URL {
    var components = URLComponents(string: "https://api.wolframalpha.com/v2/query")!
    components.queryItems = [
      URLQueryItem(name: "input", value: query),
      URLQueryItem(name: "format", value: "plaintext"),
      URLQueryItem(name: "output", value: "JSON"),
      URLQueryItem(name: "appid", value: wolframAlphaApiKey),
    ]
    return components.url(relativeTo: nil)!
}

public func urlForPrime(_ n: Int) -> URL {
    urlForQuery("prime \(n)")
}

private func decodeWolframResult(
    _ data: Data
) -> Result<WolframAlphaResult, Error> {
    Result {
        try JSONDecoder().decode(WolframAlphaResult.self, from: data)
    }
}

public func decodePrimeResult(_ data: Data) -> Result<Int, Error> {
    return decodeWolframResult(data)
        .flatMap {
            return ($0.queryresult
                .pods
                .first(where: { $0.primary == .some(true) })?
                .subpods
                .first?
                .plaintext)
                .flatMap(Int.init)
                .toResult(failure: AnyError("Could not parse response"))
        }
}
