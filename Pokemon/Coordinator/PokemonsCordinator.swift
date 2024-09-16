import UIKit

// MARK: - CoordinatorProtocol
protocol PokemonCoordinatorProtocol {
    func popViewController()

}

// MARK: - Coordinator
final class PokemonCoordinator: PokemonCoordinatorProtocol {
    weak var viewController: UIViewController?
    
    private enum Constants {
        static let errorPopupTitle: String = "Error"
        static let errorPopupMessage: String = "Error has occured"
        static let popupButtonTitle: String = "OK"
    }
    
    func popViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    
    
}
