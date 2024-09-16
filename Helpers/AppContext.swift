import Foundation

struct AppContext {
    let apiNamePokemon: NamePokemonProtocol
    let apiImage: ImageResultProtocol
    let apiDecription: ResultDecriptionProtocol

    static func makeContext() -> AppContext {
        let apiNamePokemon = APINamePokemon()
        let apiDecription = APIDecription()
        let apiImage = APIImage()

        return AppContext(apiNamePokemon: apiNamePokemon,
                          apiImage: apiImage,
                          apiDecription: apiDecription
        )
    }
}

