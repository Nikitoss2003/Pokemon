import Foundation
import RxSwift

protocol ResultDecriptionProtocol {
    func viewResultDecription(url: String?) -> Observable<DecriptionPokemonResponse?>
}

final class APIDecription: ResultDecriptionProtocol {
    
    func viewResultDecription(url: String?) -> Observable<DecriptionPokemonResponse?> {
        guard let urlString = url, let url = URL(string: urlString) else {
            return Observable.just(nil)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.rx.data(request: request)
            .map { data in
                let pokemonDecription = try JSONDecoder().decode(DecriptionPokemonResponse?.self, from: data)
                if let pokemonDecription = pokemonDecription {
                    CoreDataService.shared.saveDescriptionPokemon(with: pokemonDecription)
                }
                return pokemonDecription
            }
            .catch { error in
                Observable.error(ErrorAPI.decodingError(error))
            }
    }
}
