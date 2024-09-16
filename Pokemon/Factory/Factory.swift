import UIKit

final class PokemonsFactory {
    static func make() -> PokemonsViewController {
        let coreDataService = CoreDataService.shared
        let appContext: AppContext = SceneDelegate.shared.appContext
        let coordinator = PokemonCoordinator()
        let viewModel = PokemonsViewModel(coreDataService: coreDataService, apiNamePokemon: appContext.apiNamePokemon, apiImage: appContext.apiImage, apiDescription: appContext.apiDecription)
        let viewController = PokemonsViewController(viewModel: viewModel)
        coordinator.viewController = viewController
        return viewController
    }
}
