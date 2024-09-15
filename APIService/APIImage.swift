import Foundation

protocol ImageResult {
    func viewResultImage(url: String, completion: @escaping (Result<Data?, ErrorAPI>) -> Void)
}

final class APIImage: ImageResult {
    
    func viewResultImage(url: String, completion: @escaping (Result<Data?, ErrorAPI>) -> Void) {
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.decodingError(error)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
            CoreDataService.shared.saveImagePokemon(with: data)
        }
        task.resume()
    }
}
