import UIKit

final class PokemonsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.register(PokemonsCell.self, forCellReuseIdentifier: PokemonsCell.identifier)
        table.sectionHeaderTopPadding = .zero
        table.backgroundColor = .white
        return table
    }()
}

extension PokemonsViewController: UITableViewDelegate{
    
}

