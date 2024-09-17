import RxSwift
import RxCocoa

protocol PokemonsViewModelProtocol {
    var pokemons: Observable<[Pokemon]> { get }
    func networkservice()
    func cordinatorDecription(pokemon: Pokemon)
    func setLanguage(_ languageCode: String)
}

class PokemonsViewModel: PokemonsViewModelProtocol {

    private let coreDataService: CoreDataService
    private let disposeBag = DisposeBag()
    private let apiNamePokemon: NamePokemonProtocol
    private let apiImage: ImageResultProtocol
    private let apiDescription: ResultDecriptionProtocol
    private let coordinator: PokemonCoordinator
    private let network = NetworkMonitor()

    private let pokemonsSubject = BehaviorSubject<[Pokemon]>(value: [])
    var pokemons: Observable<[Pokemon]> {
        return pokemonsSubject.asObservable()
    }

    private var currentPage = 1
    private let pageSize = 5
    private var totalPokemonsCount = 0
    private var hasMoreData = true

    init(coreDataService: CoreDataService, apiNamePokemon: NamePokemonProtocol, apiImage: ImageResultProtocol, apiDescription: ResultDecriptionProtocol, coordinator: PokemonCoordinator) {
        self.apiNamePokemon = apiNamePokemon
        self.apiImage = apiImage
        self.apiDescription = apiDescription
        self.coreDataService = coreDataService
        self.coordinator = coordinator
    }
    
    func networkservice(){
        if network.isInternetAvailable() {
            apiGettingData()
        }
        else {
            loadPokemonsFromCoreData()
        }
    }
    
    func cordinatorDecription(pokemon: Pokemon){
        coordinator.showPokemonDetail(pokemon: pokemon)
    }

  private func apiGettingData() {
        guard hasMoreData else { return }
        apiNamePokemon.viewResultName()
            .flatMap { urlPokemonStructs -> Observable<(urls: [String], totalCount: Int)> in
                self.totalPokemonsCount = urlPokemonStructs.count
                let startIndex = (self.currentPage - 1) * self.pageSize
                let endIndex = min(startIndex + self.pageSize, urlPokemonStructs.count)
                
                self.currentPage += 1
                if startIndex >= urlPokemonStructs.count {
                    self.hasMoreData = false
                    return Observable.empty()
                }
                
                let urls = Array(urlPokemonStructs[startIndex..<endIndex]).map { $0.url }
                return Observable.just((urls: urls, totalCount: urlPokemonStructs.count))
            }
            .flatMap { result -> Observable<[DecriptionPokemonResponse?]> in
                let descriptionObservables = result.urls.map { url in
                    self.apiDescription.viewResultDecription(url: url)
                }
                
                return Observable.zip(descriptionObservables)
            }
            .flatMap { descriptionResponses -> Observable<[Pokemon]> in
                let pokemonObservables = descriptionResponses.compactMap { response -> Observable<Pokemon> in
                    guard let response = response else {
                        return Observable.empty()
                    }
                    let imageUrl = response.id
                    return self.apiImage.viewResultImage(url: String(imageUrl), name: response.name)
                        .map { imageData in
                            Pokemon(name: response.name, imageData: imageData)
                        }
                }
                return Observable.zip(pokemonObservables)
            }
            .do(onError: { error in
                print("Ошибка сети: \(error)")
            })
            .subscribe(onNext: { pokemons in
                let currentPokemons = (try? self.pokemonsSubject.value()) ?? []
                self.pokemonsSubject.onNext(currentPokemons + pokemons)
            }, onError: { error in
                print("Ошибка: \(error)")
            }, onCompleted: {
                print("Все запросы успешно выполнены")
            })
            .disposed(by: disposeBag)
    }

    private func loadPokemonsFromCoreData() {
        let savedUrls = coreDataService.fetchUrl()
        let descriptions = savedUrls.flatMap { url in
            coreDataService.fetchDescription(name: url)
        }
        let pokemonObservables = descriptions.map { description -> Observable<Pokemon> in
            return Observable.just(description)
                .flatMap { desc in
                    if let imageData = self.coreDataService.fetchImage(name: desc.name ?? "") {
                        return Observable.just(Pokemon(name: desc.name ?? "", imageData: imageData))
                    } else {
                        return Observable.empty()
                    }
                }
        }
        
        Observable.zip(pokemonObservables)
            .subscribe(onNext: { pokemons in
                self.pokemonsSubject.onNext(pokemons)
            }, onError: { error in
                print("Ошибка загрузки из Core Data: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
   



}
