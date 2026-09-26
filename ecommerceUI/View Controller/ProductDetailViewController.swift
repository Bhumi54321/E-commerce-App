import UIKit

class ProductDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var productID: Int?
    private var product: Product?
    private let apiService = APIService()
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    
    @IBOutlet weak var addToCartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupCollectionView()
        setupUI()
        setupAddToCartButton()
     
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        fetchProductDetail()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        updateHeartIcon()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewHeightConstraint.constant = imageCollectionView.collectionViewLayout.collectionViewContentSize.height
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(hex: "#FFE6CF")
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
                .font: UIFont(name: "PlayfairDisplayRoman-ExtraBold", size: 20)!,
                .foregroundColor: UIColor.black
            ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance

    }

    private func setupNavBar() {

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white        
        appearance.shadowColor = .clear

        appearance.titleTextAttributes = [
            .font: UIFont(name: "PlayfairDisplayRoman-ExtraBold", size: 20)!,
            .foregroundColor: UIColor.black
        ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .black

        let config = UIImage.SymbolConfiguration(weight: .bold)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left", withConfiguration: config),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(heartTapped)
        )

        navigationItem.title = "Product Detail"
    }

    
    private func setupUI() {
        
        view.backgroundColor = .white
        
       
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        
   
        updateHeartIcon()

     
        ratingStackView.axis = .horizontal
        ratingStackView.spacing = 2
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        imageCollectionView.collectionViewLayout = layout
        imageCollectionView.isPagingEnabled = true
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.backgroundColor = .clear
      
        
      
        imageCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
    }

    private func setupAddToCartButton() {
       
     
        addToCartButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
      
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func heartTapped() {
        guard let product = product else { return }

        LikeManager.toggleLike(
            productId: product.id,
            title: product.title,
            imageURL: product.thumbnail,
            button: nil,
            viewController: self
        )

        updateHeartIcon()
    }


    

    
    @IBAction func addToCartTapped(_ sender: Any) {
    guard let product = product else { return }

        let image = product.thumbnail.isEmpty ? (product.images.first ?? "") : product.thumbnail

     
        let item = CartItemModel(
            id: Int(product.id),
            title: product.title,
            price: product.price,
            imageURL: image,
            quantity: 1,
            size: "3",
            color: "Blue"
        )

 
        CartManager.shared.addToCart(item: item)


        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let cartVC = storyboard.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
            navigationController?.pushViewController(cartVC, animated: true)
        }
    }

    // MARK: - CollectionView DataSource & Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.images.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let img = UIImageView(frame: cell.bounds)
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        img.addTapEnlargeAnimation()
        if let url = URL(string: product?.images[indexPath.item] ?? "") {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        img.image = UIImage(data: data)
                    }
                }
            }.resume()
        }

        cell.contentView.addSubview(img)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == imageCollectionView {
            let page = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
            pageControl.currentPage = page
        }
    }

    // MARK: - API
    private func fetchProductDetail() {
        guard let id = productID else { return }

        apiService.fetchProductDetail(id: id) { [weak self] product in
            DispatchQueue.main.async {
                self?.product = product
                if let product = product {
                    self?.updateUI(product)
                    self?.updateHeartIcon()
                }
                self?.imageCollectionView.reloadData()
            }
        }
    }

    private func updateUI(_ product: Product) {
        titleLabel.text = product.title
        descriptionLabel.text = product.description
        priceLabel.text = "$\(product.price)"

        if let discount = product.discountPercentage {
            let oldVal = Double(product.price) / (1 - discount / 100)
            let oldPrice = "$\(Int(oldVal))"
            let at = NSMutableAttributedString(string: oldPrice)

            at.addAttributes([
                 .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                 .strikethroughColor: UIColor.orange
             ], range: NSRange(location: 0, length: at.length))
            oldPriceLabel.attributedText = at
        }

        pageControl.numberOfPages = product.images.count
        setupRatingStars(rating: product.rating, totalReviews: product.reviews?.count ?? 0)
    }
    private func updateHeartIcon() {
        guard let product = product else { return }

        let isLiked = CoreDataManager.shared.isProductLiked(id: product.id)

        let config = UIImage.SymbolConfiguration(weight: .bold)
        let image = UIImage(
            systemName: isLiked ? "heart.fill" : "heart",
            withConfiguration: config
        )

        navigationItem.rightBarButtonItem?.image = image
        navigationItem.rightBarButtonItem?.tintColor = isLiked ? .red : .black
    }


    private func setupRatingStars(rating: Double, totalReviews: Int) {
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let full = Int(rating)
        let half = (rating - Double(full)) >= 0.5
        let empty = 5 - full - (half ? 1 : 0)

        // Full stars
        for _ in 0..<full {
            let star = UIImageView(image: UIImage(systemName: "star.fill"))
            star.tintColor = .systemOrange
            star.contentMode = .scaleAspectFit
            ratingStackView.addArrangedSubview(star)
        }
        // Half star
        if half {
            let star = UIImageView(image: UIImage(systemName: "star.leadinghalf.fill"))
            star.tintColor = .systemOrange
            star.contentMode = .scaleAspectFit
            ratingStackView.addArrangedSubview(star)
        }
        // Empty stars
        for _ in 0..<empty {
            let star = UIImageView(image: UIImage(systemName: "star"))
            star.tintColor = .lightGray
            star.contentMode = .scaleAspectFit
            ratingStackView.addArrangedSubview(star)

        }
        
        reviewsLabel.text = "\(String(format: "%.1f", rating)) (\(totalReviews) reviews)"
    }
}
