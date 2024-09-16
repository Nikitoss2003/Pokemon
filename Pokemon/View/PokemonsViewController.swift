import UIKit
import RxSwift
import RxCocoa
import RxBlocking

final class PokemonsViewController: UIViewController {
    private let viewModel: PokemonsViewModelProtocol
    private let disposeBag = DisposeBag()

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(PokemonsCell.self, forCellReuseIdentifier: PokemonsCell.identifier)
        table.sectionHeaderTopPadding = .zero
        table.backgroundColor = .white
        return table
    }()

    init(viewModel: PokemonsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.networkservice()
        setupBindings()
       
    }

    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    private func setupBindings() {
        viewModel.pokemons
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: PokemonsCell.identifier, cellType: PokemonsCell.self)) { index, pokemon, cell in
                cell.configure(with: pokemon)
            }
            .disposed(by: disposeBag)
        tableView.rx.contentOffset
            .flatMapLatest { [weak self] _ -> Observable<Bool> in
                guard let self = self else { return Observable.empty() }
                let contentOffsetY = self.tableView.contentOffset.y
                let contentHeight = self.tableView.contentSize.height
                let tableViewHeight = self.tableView.frame.height
                return Observable.just(contentOffsetY + tableViewHeight > contentHeight - 100)
            }
            .distinctUntilChanged()
            .filter { $0 }
            .bind { [weak self] _ in
                self?.viewModel.networkservice()
            }
            .disposed(by: disposeBag)
    }
}

extension PokemonsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
