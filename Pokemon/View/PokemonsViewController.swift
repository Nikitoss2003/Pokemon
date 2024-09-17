import UIKit
import RxSwift
import RxCocoa
import RxBlocking

final class PokemonsViewController: UIViewController {
    private let viewModel: PokemonsViewModelProtocol
    private let disposeBag = DisposeBag()
    let englishButton = UIButton(type: .system)
    let russianButton = UIButton(type: .system)

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
        view.backgroundColor = .white
        setupUI()
        viewModel.networkservice()
        setupBindings()
       
    }

     func setupUI() {
        englishButton.setTitle("EN", for: .normal)
        englishButton.setTitleColor(.blue, for: .normal)
        englishButton.addTarget(self, action: #selector(selectEnglish), for: .touchUpInside)
        
        russianButton.setTitle("RU", for: .normal)
        russianButton.setTitleColor(.blue, for: .normal)
        russianButton.addTarget(self, action: #selector(selectRussian), for: .touchUpInside)
        
        let views = UIView()
        views.backgroundColor = .blue
        views.snp.makeConstraints { make in
            make.width.equalTo(3)
            make.height.equalTo(18)
        }
        
        let stackView = UIStackView(arrangedSubviews: [englishButton, views, russianButton])
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.alignment = .center
        stackView.backgroundColor = .white
        
        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.right.equalToSuperview().inset(15)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
            
        }

        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    
    @objc private func selectEnglish(){
        englishButton.setTitleColor(.black, for: .normal)
        russianButton.setTitleColor(.blue, for: .normal)
    }
    @objc private func selectRussian(){
        russianButton.setTitleColor(.black, for: .normal)
        englishButton.setTitleColor(.blue, for: .normal)
    }
    
    

    private func setupBindings() {
        viewModel.pokemons
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: PokemonsCell.identifier, cellType: PokemonsCell.self)) { index, pokemon, cell in
                cell.configure(with: pokemon)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Pokemon.self)
            .subscribe(onNext: { [weak self] selectedPokemon in
                guard let self = self else { return }
                self.viewModel.cordinatorDecription(pokemon: selectedPokemon)
            })
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



