import Foundation

class APIService {
    func fetchProducts(for category: String, completion: @escaping ([Product]) -> Void) {
      
        let urlString = "https://dummyjson.com/products/category/\(category)"
        
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let decodedResponse = try? JSONDecoder().decode(ProductResponse.self, from: data) else {
                completion([])
                return
            }
            completion(decodedResponse.products)
        }.resume()
    }
    func fetchProductDetail(id: Int, completion: @escaping (Product?) -> Void) {
            guard let url = URL(string: "https://dummyjson.com/products/\(id)") else {
                completion(nil)
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data {
                    do {
                        let product = try JSONDecoder().decode(Product.self, from: data)
                        completion(product)
                    } catch {
                        print("Decoding error:", error)
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }.resume()
        }
    }



