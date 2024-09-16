import Foundation
import RxSwift
import RxCocoa

protocol NamePokemonProtocol {
    func viewResultName() -> Observable<[UrlPokemonStruct]>
}

final class APINamePokemon: NamePokemonProtocol {

    func viewResultName() -> Observable<[UrlPokemonStruct]> {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.rx.data(request: request)
            .map { data in
                let pokemonResponse = try JSONDecoder().decode(UrlPokemonResponse.self, from: data)
                CoreDataService.shared.saveUrlPokemon(with: pokemonResponse.results)
                return pokemonResponse.results
            }
            .catch{
                error in
                    Observable.error(ErrorAPI.decodingError(error))
            }
    }
}
