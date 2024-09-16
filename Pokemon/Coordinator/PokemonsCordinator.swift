import UIKit

// MARK: - CoordinatorProtocol
protocol PokemonCoordinatorProtocol {
    func showPokemonDetail(pokemon: Pokemon)

}

// MARK: - Coordinator
final class PokemonCoordinator: PokemonCoordinatorProtocol {
    weak var viewController: UIViewController?
    func showPokemonDetail(pokemon: Pokemon) {
        let detailViewController = PokemonDetailFactory.make(pokemon: pokemon)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
    
    
    
    
}

