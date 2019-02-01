import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

extension URL
{
    func withQueries(_ queries: [String: String]) -> URL?
    {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap{ URLQueryItem(name: $0.0, value: $0.1)}
        return components?.url
    }
}

let baseUrl = URL(string: "https://www.apple.com/search")!

let query:[String: String] =
[
    "term": "Andrzej Sapkowski",
    "contry": "Pl",
    "media": "ebook",
    "entity": "ebook"
]

let url = baseUrl.withQueries(query)!

let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
    if let data = data
    {
        let string = String(data: data, encoding: .utf8)
        print(string)
        PlaygroundPage.current.finishExecution()
    }
}
task.resume()

