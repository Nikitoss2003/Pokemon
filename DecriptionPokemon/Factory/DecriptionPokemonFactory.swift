final class PokemonDetailFactory {
    static func make(pokemon: Pokemon) -> DecriptionPokemonView {
        let viewModel = DecriptionPokemonModel(pokemon: pokemon)
        let viewController = DecriptionPokemonView(viewModel: viewModel)
        return viewController
    }
}

