import PlaygroundSupport
import Foundation

PlaygroundPage.current.needsIndefiniteExecution = true

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}

struct StoreItem: Codable {
    var name: String
    var artist: String
    var kind: String
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case artist = "artistName"
        case kind
        case description
    }
    
    enum AdditionalKeys: String, CodingKey {
        case longDescription
    }
    
    init(from decoder: Decoder) throws {
        let valuesContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try valuesContainer.decode(String.self, forKey: CodingKeys.name)
        self.artist = try valuesContainer.decode(String.self, forKey: CodingKeys.artist)
        self.kind = try valuesContainer.decode(String.self, forKey: CodingKeys.kind)
        
        if let description = try? valuesContainer.decode(String.self, forKey: CodingKeys.description) {
            self.description = description
        } else {
            let additionalValuesContainter = try decoder.container(keyedBy: AdditionalKeys.self)
            self.description = (try? additionalValuesContainter.decode(String.self, forKey: AdditionalKeys.longDescription)) ?? ""
        }
    }
}

struct StoreItems: Codable {
    let results: [StoreItem]
}

func fetchItems(matching query: [String: String], completion: @escaping ([StoreItem]?) -> Void) {
    let baseURL = URL(string: "https://itunes.apple.com/search")!
    
    let url = baseURL.withQueries(query)!
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        let jsonDecoder = JSONDecoder()
        
        if let data = data, let storeItems = try? jsonDecoder.decode(StoreItems.self, from: data) {
            completion(storeItems.results)
        } else {
            print("Either no data was returned, or data was not serialized.")
            completion(nil)
        }
    }
    
    task.resume()
}

// -
let query = [
    "term": "Andrzej Sapkowski",
    "media": "ebook",
    "limit": "5"
]

fetchItems(matching: query) { (items) in
    if let items = items {
        for item in items
        {
            print("\(item) \n")
        }
    }
}



