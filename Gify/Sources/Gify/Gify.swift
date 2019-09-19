import Foundation

private let apiKey = "dc6zaTOxFJmzC"

private struct GifyResponse: Decodable {
    let data: GifyItem
}

public struct GifyItem: Decodable {
    public let title: String
    public let imageURL: URL

    private enum CodingKeys : String, CodingKey {
        case title, imageURL = "image_url"
    }
}

private func decodeGifyResponse(_ data: Data) -> Result<GifyResponse, Error> {
    Result {
        try JSONDecoder().decode(GifyResponse.self, from: data)
    }
}

public func decodeGifyItem(_ data: Data) -> Result<GifyItem, Error> {
    decodeGifyResponse(data).map { $0.data }
}

public func randomGifURL(tag: String) -> URL {
    var components = URLComponents(string: "https://api.giphy.com/v1/gifs/random")!
    components.queryItems = [
        URLQueryItem(name: "tag", value: tag),
        URLQueryItem(name: "api_key", value: apiKey),
    ]
    return components.url(relativeTo: nil)!
}
