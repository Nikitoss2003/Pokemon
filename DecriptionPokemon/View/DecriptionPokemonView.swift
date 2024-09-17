import UIKit
import Foundation
import SnapKit

final class DecriptionPokemonView: UIViewController{
    private let viewModel: DecriptionPokemoProtocol
    
    init(viewModel: DecriptionPokemoProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private lazy var imagePokemons: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(data: (viewModel.resultDescription()?.imageData)!)
        return image
    }()
    private lazy var namePokemons: UILabel = {
        let label = UILabel()
        label.text = viewModel.resultDescription()?.name
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var weightPokemons: UILabel = {
        let label = UILabel()
        label.text = String(viewModel.resultDescription()?.weight ?? 0)
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)

        return label
    }()
    private lazy var heightPokemons: UILabel = {
        let label = UILabel()
        label.text = String(viewModel.resultDescription()?.height ?? 0)
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)

        return label
    }()
    private lazy var typesLable: UILabel = {
        let lable = UILabel()
        lable.text = viewModel.resultDescription()?.types
        lable.textColor = .black
        lable.font = UIFont.boldSystemFont(ofSize: 20)
        return lable
    }()
    
    private lazy var kgLable: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("kg", comment: "kg")
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)

        return label
    }()
    private lazy var cmLable: UILabel = {
        let lable = UILabel()
        lable.text = NSLocalizedString("cm", comment: "cm")
        lable.textColor = .black
        lable.font = UIFont.boldSystemFont(ofSize: 20)

        return lable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
       
    }
    
    private func setupUI(){
        
        view.addSubview(imagePokemons)
        imagePokemons.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(200)
        }

        view.addSubview(namePokemons)
        namePokemons.snp.makeConstraints { make in
            make.top.equalTo(imagePokemons.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(50)
        }

        view.addSubview(weightPokemons)
        weightPokemons.snp.makeConstraints { make in
            make.top.equalTo(namePokemons.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(50)
        }

        view.addSubview(heightPokemons)
        heightPokemons.snp.makeConstraints { make in
            make.top.equalTo(weightPokemons.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(50)
        }

        view.addSubview(typesLable)
        typesLable.snp.makeConstraints { make in
            make.top.equalTo(imagePokemons.snp.bottom).offset(20)
            make.right.equalToSuperview().inset(50)
        }

        view.addSubview(kgLable)
        kgLable.snp.makeConstraints { make in
            make.top.equalTo(typesLable.snp.bottom).offset(20)
            make.right.equalToSuperview().inset(50)
        }

        view.addSubview(cmLable)
        cmLable.snp.makeConstraints { make in
            make.top.equalTo(kgLable.snp.bottom).offset(20)
            make.right.equalToSuperview().inset(50)
        }
    }

}
