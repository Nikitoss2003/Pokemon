import Foundation
import RxSwift

protocol ImageResultProtocol {
    func viewResultImage(url: String, name: String) -> Observable<Data>
}

final class APIImage: ImageResultProtocol {
    
    func viewResultImage(url: String, name: String) -> Observable<Data> {
        let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/\(url).png")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.rx.data(request: request)
            .map { data in
                CoreDataService.shared.saveImagePokemon(with: data, name: name )
                return data
            }
            .catch { error in
                Observable.error(ErrorAPI.decodingError(error))
            }
    }
}
