//Home  Screen
import UIKit

class CategoryCell: UICollectionViewCell {
    
    static let identifier = "CategoryCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
   
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.1).cgColor
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let iconSize: CGFloat = 20
        iconImageView.frame = CGRect(
            x: 10,
            y: 5,
            width: iconSize,
            height: iconSize
        )
        
        titleLabel.frame = CGRect(
            x: 20,
            y: 5,
            width: contentView.frame.width - 10 ,
            height: 18
        )
    }
    
    func configure(imageName: String, title: String) {
        iconImageView.image = UIImage(named: imageName)
        titleLabel.text = title
    }
}
