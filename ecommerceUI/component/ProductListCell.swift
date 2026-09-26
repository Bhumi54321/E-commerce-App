// Item Screen

import UIKit

class ProductListCell: UICollectionViewCell {
    var product: Product?
    weak var parentVC: UIViewController?

    static let identifier = "ProductListCell"
    
    private let productImageView = UIImageView()
    private let priceLabel = UILabel()
    private let oldPriceLabel = UILabel()
    private let heartButton = UIButton()
    private let cartButton = UIButton()
    private let dotContainer = UIView()
    private let discountBadge = UILabel()
    private var isFavorite = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
     
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 8


        
        
     
        priceLabel.font = UIFont.boldSystemFont(ofSize: 14)
        priceLabel.textColor = .black
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.minimumScaleFactor = 0.5
        priceLabel.lineBreakMode = .byClipping

        oldPriceLabel.font = UIFont.systemFont(ofSize: 11)
        oldPriceLabel.textColor = .gray
        

        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        cartButton.setImage(UIImage(systemName: "cart"), for: .normal)
        cartButton.tintColor = .black
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        dotContainer.translatesAutoresizingMaskIntoConstraints = false
        setupTriangleDots()
        

        [productImageView,  oldPriceLabel, priceLabel, heartButton, cartButton, dotContainer, discountBadge].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
      
        NSLayoutConstraint.activate([
         
            heartButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            heartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            heartButton.widthAnchor.constraint(equalToConstant: 20),
            heartButton.heightAnchor.constraint(equalToConstant: 20),
            
        
            dotContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dotContainer.centerYAnchor.constraint(equalTo: heartButton.centerYAnchor),
            dotContainer.widthAnchor.constraint(equalToConstant: 18),
            dotContainer.heightAnchor.constraint(equalToConstant: 16),
            
     
            
    
            productImageView.topAnchor.constraint(equalTo: heartButton.bottomAnchor, constant: 8),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor, multiplier: 1.0),
            
    
           
            oldPriceLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 1),
            oldPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
         
            priceLabel.topAnchor.constraint(equalTo: oldPriceLabel.bottomAnchor, constant: 0),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
      
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            cartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cartButton.widthAnchor.constraint(equalToConstant: 20),
            cartButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
       
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        contentView.backgroundColor = .white
    }


    @objc private func heartButtonTapped() {
        guard let product = product else { return }

        LikeManager.toggleLike(
            productId: product.id,
            title: product.title,
            imageURL: product.thumbnail,
            button: heartButton,
            viewController: parentVC!
        )
    }


    private func setupTriangleDots() {
        let colors: [UIColor] = [.systemPurple, .systemOrange, .systemBlue]
        var dots: [UIView] = []
        
        for color in colors {
            let dot = UIView()
            dot.backgroundColor = color
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.layer.cornerRadius = 3.5
            dot.clipsToBounds = true
            dotContainer.addSubview(dot)
            dots.append(dot)
            
            NSLayoutConstraint.activate([
                dot.widthAnchor.constraint(equalToConstant: 7),
                dot.heightAnchor.constraint(equalToConstant: 7)
            ])
        }
        
        NSLayoutConstraint.activate([
            dots[0].centerXAnchor.constraint(equalTo: dotContainer.centerXAnchor),
            dots[0].topAnchor.constraint(equalTo: dotContainer.topAnchor),
            
            dots[1].leadingAnchor.constraint(equalTo: dotContainer.leadingAnchor),
            dots[1].bottomAnchor.constraint(equalTo: dotContainer.bottomAnchor),
            
            dots[2].trailingAnchor.constraint(equalTo: dotContainer.trailingAnchor),
            dots[2].bottomAnchor.constraint(equalTo: dotContainer.bottomAnchor)
        ])
    }
    func configure(with product: Product, parentVC: UIViewController) {
        self.product = product
        self.parentVC = parentVC
        LikeManager.updateHeart(heartButton: heartButton, productId: product.id)
    
        if let imageUrl = URL(string: product.thumbnail) {
            loadImage(from: imageUrl)
        } else {
            productImageView.image = UIImage(systemName: "photo")
            productImageView.tintColor = .lightGray
        }

        // MARK: - Price
        let price = product.price
        priceLabel.text = String(format: "$%.1f", price)

        // Discount
        if let discount = product.discountPercentage, discount > 0 {
            
            let oldPriceValue = price / (1 - (discount / 100))  // original price

            let attributedString = NSAttributedString(
                string: String(format: "$%.1f", oldPriceValue),

                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.gray
                ]
            )

            oldPriceLabel.attributedText = attributedString

        } else {
            oldPriceLabel.text = ""   // hide old price if no discount
        }

      
    }

    
    private func loadImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.productImageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.productImageView.image = UIImage(systemName: "photo")
                    self.productImageView.tintColor = .lightGray
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        priceLabel.text = nil
        oldPriceLabel.text = nil
        discountBadge.isHidden = true
    }
}
