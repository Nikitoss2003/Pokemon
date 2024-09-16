import Foundation
import UIKit
import SnapKit

struct Pokemon {
    var name: String
    var imageData: Data?
}

final class PokemonsCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let imagePokemonsView = UIImageView()
    
    static let identifier = "PokemonsCellIdentifier"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func configure(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name
        if let imageData = pokemon.imageData {
            imagePokemonsView.image = UIImage(data: imageData)
        } else {
            imagePokemonsView.image = nil
        }
    }
    
    private func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(imagePokemonsView)
        
        nameLabel.font = UIFont.systemFont(ofSize: 30)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
        
       
        imagePokemonsView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(80)
        }
    }
}
