import Foundation

struct ProductResponse: Codable {
    let products: [Product]
}

struct Review: Codable {
    let rating: Double

}

struct Product: Codable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let discountPercentage: Double?
    let rating: Double
    let thumbnail: String
    let images: [String]
    let reviews: [Review]?  
}
