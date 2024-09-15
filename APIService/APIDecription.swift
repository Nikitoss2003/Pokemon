import Foundation

protocol ResultDecription {
    func viewResultDecription( url: String?, completion: @escaping (Result<DecriptionPokemonResponse?, ErrorAPI>) -> Void)
}

final class APIDecription: ResultDecription  {
    
    func viewResultDecription( url: String?, completion: @escaping (Result<DecriptionPokemonResponse?, ErrorAPI>) -> Void) {
        let url = URL(string: url ?? "")!
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
            do {
                let pokemonDecription = try JSONDecoder().decode(DecriptionPokemonResponse?.self, from: data)
                if let pokemonDecription = pokemonDecription {
                    CoreDataService.shared.saveDecriptionPokemon(with: pokemonDecription)
                }
                completion(.success(pokemonDecription))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        task.resume()
    }
}


