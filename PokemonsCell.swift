import Foundation
import UIKit
import SnapKit

final class PokemonsCell: UITableViewCell{
    private let nameLable =  UILabel()
    private let imagePokemonsView =  UIImageView()
    
    static let identifier = "PokemonsCellIdentifier"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
}

private extension PokemonsCell{
    func setupUI() {
        setupHierarchy()
        setupConstraints()
    }
    
    func setupHierarchy() {
        contentView.addSubview(nameLable)
        contentView.addSubview(imagePokemonsView)
    }
    
    func setupConstraints() {
        nameLable.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
        imagePokemonsView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(10)
            make.center.equalToSuperview()
        }
    }
    
    
    
}
