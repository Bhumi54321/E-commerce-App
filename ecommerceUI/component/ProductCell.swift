import UIKit

class ProductCell: UICollectionViewCell {
    var product: Product?
    weak var parentVC: UIViewController?

    static let identifier = "ProductCell"
    
    private let productImageView = UIImageView()
    private let priceLabel = UILabel()
    private let heartButton = UIButton()
    private let cartButton = UIButton()
    private let dotIndicator = DotIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.1).cgColor
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4

        productImageView.contentMode = .scaleAspectFit
        productImageView.translatesAutoresizingMaskIntoConstraints = false
       
        priceLabel.font = .boldSystemFont(ofSize: 16)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        heartButton.adjustsImageWhenHighlighted = false
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        
        cartButton.setImage(UIImage(systemName: "cart.fill"), for: .normal)
        cartButton.tintColor = .black
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        
        dotIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dotIndicator)
        contentView.addSubview(productImageView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(heartButton)
        contentView.addSubview(cartButton)
        
        NSLayoutConstraint.activate([
            dotIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            dotIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            
            productImageView.topAnchor.constraint(equalTo: dotIndicator.bottomAnchor, constant: 5),
            productImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            productImageView.heightAnchor.constraint(equalToConstant: 120),
            productImageView.widthAnchor.constraint(equalToConstant: 120),
            
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            heartButton.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            heartButton.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor, constant: -8),
            heartButton.widthAnchor.constraint(equalToConstant: 20),
            heartButton.heightAnchor.constraint(equalToConstant: 20),
            
            cartButton.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            cartButton.widthAnchor.constraint(equalToConstant: 20),
            cartButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with product: Product, parentVC: UIViewController) {
        self.product = product
        self.parentVC = parentVC

        priceLabel.text = "$\(product.price)"
        loadImage(from: product.thumbnail)
        dotIndicator.configure(colors: [.systemOrange, .lightGray, .darkGray])

     
        LikeManager.updateHeart(heartButton: heartButton, productId: product.id)
        heartButton.removeTarget(nil, action: nil, for: .allEvents)
        heartButton.addTarget(self, action: #selector(heartButtonTapped(_:)), for: .touchUpInside)
    }

    @objc private func heartButtonTapped(_ sender: UIButton) {
        guard let product = product else { return }
        
        sender.isHighlighted = false
        
        LikeManager.toggleLike(
            productId: product.id,
            title: product.title,
            imageURL: product.thumbnail,
            button: sender,
            viewController: parentVC!
        )
    }

    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.productImageView.image = image
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        priceLabel.text = nil
      
    }
}
