import UIKit

class CartItemCell: UITableViewCell {
    
    static let identifier = "CartItemCell"
    
    private let productImageView = UIImageView()
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    private let priceLabel = UILabel()
    
    // Quantity section
    private let qtyLabel = UILabel()
    private let quantityContainer = UIView()
    private let quantityLabel = UILabel()
    private let upArrow = UIButton()
    private let downArrow = UIButton()
    private let deleteButton = UIButton()
    var cartItem: CartItemEntity?

    var onQuantityChanged: ((Int) -> Void)?
    var onDeleteTapped: (() -> Void)?
    private var currentQuantity = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // MARK: - Product Image
        productImageView.layer.cornerRadius = 8
        productImageView.clipsToBounds = true
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.contentMode = .scaleAspectFill
        productImageView.addTapEnlargeAnimation()
        contentView.addSubview(productImageView)
        
        // MARK: - Labels
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        detailLabel.font = UIFont.systemFont(ofSize: 13)
        detailLabel.textColor = .gray
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detailLabel)
        
        priceLabel.font = UIFont.boldSystemFont(ofSize: 16)
        priceLabel.textColor = .systemOrange
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)
        
        // MARK: - Quantity Section
        qtyLabel.text = "Qty:"
        qtyLabel.font = UIFont.systemFont(ofSize: 13)
        qtyLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(qtyLabel)
        
        quantityContainer.layer.borderWidth = 1
        quantityContainer.layer.cornerRadius = 9
        quantityContainer.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        quantityContainer.translatesAutoresizingMaskIntoConstraints = false
        quantityContainer.clipsToBounds = true
        contentView.addSubview(quantityContainer)
        
        quantityLabel.textAlignment = .center
        quantityLabel.font = UIFont.systemFont(ofSize: 13)
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let smallConfig = UIImage.SymbolConfiguration(pointSize: 5, weight: .regular)
        upArrow.setImage(UIImage(systemName: "arrowtriangle.up.fill", withConfiguration: smallConfig), for: .normal)
        downArrow.setImage(UIImage(systemName: "arrowtriangle.down.fill", withConfiguration: smallConfig), for: .normal)
        
        upArrow.tintColor = .black
        downArrow.tintColor = .black
        upArrow.translatesAutoresizingMaskIntoConstraints = false
        downArrow.translatesAutoresizingMaskIntoConstraints = false
        
        upArrow.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        downArrow.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
        
        quantityContainer.addSubview(quantityLabel)
        quantityContainer.addSubview(upArrow)
        quantityContainer.addSubview(downArrow)
        
  
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .gray
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        contentView.addSubview(deleteButton)
        

        
        NSLayoutConstraint.activate([
            // Product image
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            productImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Title label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -12),

            
            // Detail label
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            // Qty label
            qtyLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 25),
            qtyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            // Quantity container
            quantityContainer.centerYAnchor.constraint(equalTo: qtyLabel.centerYAnchor),
            quantityContainer.leadingAnchor.constraint(equalTo: qtyLabel.trailingAnchor, constant: 8),
            quantityContainer.widthAnchor.constraint(equalToConstant: 55),
            quantityContainer.heightAnchor.constraint(equalToConstant: 20),
            
            // Delete button
            deleteButton.centerYAnchor.constraint(equalTo: qtyLabel.centerYAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: quantityContainer.trailingAnchor, constant: 15),
            deleteButton.widthAnchor.constraint(equalToConstant: 15),
            deleteButton.heightAnchor.constraint(equalToConstant: 15),
            
            // Price label (right side)
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1),
            priceLabel.centerYAnchor.constraint(equalTo: qtyLabel.centerYAnchor),
            
            // Bottom padding
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: qtyLabel.bottomAnchor, constant: 8)
        ])
        
      
        NSLayoutConstraint.activate([
            // Quantity label 
            quantityLabel.centerYAnchor.constraint(equalTo: quantityContainer.centerYAnchor),
            quantityLabel.leadingAnchor.constraint(equalTo: quantityContainer.leadingAnchor, constant: 8),
            
            // Up arrow (top-right)
            upArrow.topAnchor.constraint(equalTo: quantityContainer.topAnchor, constant: 5),
            upArrow.trailingAnchor.constraint(equalTo: quantityContainer.trailingAnchor, constant: -6),
            upArrow.widthAnchor.constraint(equalToConstant: 5),
            upArrow.heightAnchor.constraint(equalToConstant: 5),
            
            // Down arrow (below up arrow)
            downArrow.topAnchor.constraint(equalTo: upArrow.bottomAnchor, constant: 1),
            downArrow.trailingAnchor.constraint(equalTo: upArrow.trailingAnchor),
            downArrow.widthAnchor.constraint(equalToConstant: 5),
            downArrow.heightAnchor.constraint(equalToConstant: 5)
        ])
    }

    
    func configure(with item: CartItemModel) {
        titleLabel.text = item.title
        detailLabel.text = "Size: \(item.size)     Color: \(item.color)"
        priceLabel.text = "$\(item.price)"
        quantityLabel.text = "\(item.quantity)"
        currentQuantity = item.quantity
        
        if let url = URL(string: item.imageURL) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.productImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        } else {
            productImageView.image = nil
        }
    }


    
    @objc private func increaseQuantity() {
        currentQuantity += 1
        quantityLabel.text = "\(currentQuantity)"

        cartItem?.quantity = Int64(Int16(currentQuantity))


        onQuantityChanged?(currentQuantity)

        CoreDataManager.shared.saveContext()
    }

    @objc private func decreaseQuantity() {
        if currentQuantity > 1 {
            currentQuantity -= 1
            quantityLabel.text = "\(currentQuantity)"

            // Update Core Data object
            cartItem?.quantity = Int64(Int16(currentQuantity))

            onQuantityChanged?(currentQuantity)
            CoreDataManager.shared.saveContext()
        }
    }

    
    @objc private func deleteTapped() {
        onDeleteTapped?()
    }
}
