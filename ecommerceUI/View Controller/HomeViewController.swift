import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var Contentview: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var focusCollectionView: UICollectionView!
    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var BannerIndicatorView: DotIndicatorView!
    @IBOutlet weak var CardView: UIView!
    // MARK: - View All Buttons
    @IBOutlet weak var categoryViewAllButton: UIButton!
    @IBOutlet weak var productViewAllButton: UIButton!


    // MARK: - Height Constraints
    @IBOutlet weak var categoryCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var productCollectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var CardViewHeight: NSLayoutConstraint!
    var categoryName: String = ""
    let categoryTitles = [
        "beauty", "furniture", "smartphones", "tablets",
        "groceries", "fragrances", "mens-watches","sports-accessories","tops",
        "womens-bags","Laptops","womens-jewellery","women-watches","home-decoration","womens-dresses","mens-shirts","womens-shoes"]
    let categoryImages = [
        "beauty", "sleeping", "iphone", "laptop-computer",
        "groceries", "fragrances","watches","sports","fashion","women-bag","laptop-computer","necklace","watches","living-room","fashion","fashion","female-boots"
        
    ]

    let focusItems: [(title: String, subtitle: String)] = [
        ("Focus on sofas!", "Up to 30% off on selected soafs for limited"),
        ("Focus on phones!", "Up to 50% off on selected soafs for limited"),
        ("Focus on shoes!", "Up to 20% off on selected soafs for limited")
    
    ]

    private var originalProductHeight: CGFloat = 0

    private var products: [Product] = []
    private let apiService = APIService()
    
    
    private var showAllCategories = false
    private var showAllProducts = false
    private func setupNavigationBar() {

        guard let navBar = navigationController?.navigationBar else { return }
      
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(hex: "#FFE6CF")
        appearance.shadowColor = .clear
 
        appearance.titleTextAttributes = [
            .font: UIFont(name: "PlayfairDisplayRoman-ExtraBold", size: 20)!,
            .foregroundColor: UIColor.black
        ]

        navBar.standardAppearance = appearance
        navBar.compactAppearance = appearance
        navBar.scrollEdgeAppearance = appearance

        navBar.tintColor = .black


        let cartButton = UIBarButtonItem(
            image: UIImage(systemName: "cart.fill"),
            style: .plain,
            target: self,
            action: #selector(CartTapped)
        )
       
      
        navigationItem.rightBarButtonItem = cartButton
        
        
        navigationItem.title = "Furni Store"
        
       
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    @objc private func CartTapped() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        originalProductHeight = productCollectionHeight.constant
        setupUI()
        fetchProducts()
        
        BannerIndicatorView.configure(colors: [
            .systemOrange, .lightGray, .lightGray
        ])
        BannerIndicatorView.setActiveDot(0)
        

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        focusCollectionView.collectionViewLayout.invalidateLayout()
        focusCollectionView.layoutIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.focusCollectionView.reloadData()
            self.BannerIndicatorView.setActiveDot(0)
        }
    }


    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        productCollectionView.reloadData()
    }
    
  
    
    private func setupUI() {
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search products",
            attributes: [.foregroundColor: UIColor.black,
                         .font: UIFont.systemFont(ofSize: 16, weight: .regular)]
        )
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: searchTextField.frame.height))
        searchTextField.leftView = paddingView
        searchTextField.rightView = paddingView
        searchTextField.rightViewMode = .always
        searchTextField.leftViewMode = .always
        
        if let leftView = searchTextField.leftView {
            leftView.frame = CGRect(x: 20, y: 20, width: leftView.frame.width + 40, height: leftView.frame.height)
        }
        
        if let rightView = searchTextField.rightView {
            rightView.frame = CGRect(x: 0, y: 10, width: rightView.frame.width + 10, height: rightView.frame.height)
        }
        
        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        productCollectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        focusCollectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)
     

        focusCollectionView.isPagingEnabled = true
        focusCollectionView.showsHorizontalScrollIndicator = false



        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        focusCollectionView.delegate = self
        focusCollectionView.dataSource = self
        
    }
    
    private func fetchProducts() {
        apiService.fetchProducts(for: "smartphones") { [weak self] products in
            DispatchQueue.main.async {
                self?.products = products
                print("Loaded \(products.count) products")
                self?.productCollectionView.reloadData()
            }
        }
    }
    private func updateBannerDots(activeIndex: Int) {
        for (index, dot) in BannerIndicatorView.subviews.first!.subviews.enumerated() {
            dot.backgroundColor = index == activeIndex ? .systemOrange : .lightGray
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == focusCollectionView {
            let page = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
            BannerIndicatorView.setActiveDot(page)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == focusCollectionView {
            let page = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
            BannerIndicatorView.setActiveDot(page)
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == focusCollectionView && !decelerate {
            let page = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
            BannerIndicatorView.setActiveDot(page)
        }
    }

    @IBAction func viewAllCategoriesTapped(_ sender: UIButton) {
        showAllCategories.toggle()
        categoryViewAllButton.setTitle(showAllCategories ? "View less" : "View all", for: .normal)
        categoryCollectionView.reloadData()
   
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateCategoryCollectionHeight()
        }
    }

    @IBAction func viewAllProductsTapped(_ sender: UIButton) {
        showAllProducts.toggle()
        productViewAllButton.setTitle(showAllProducts ? "View less" : "View all", for: .normal)
        
        productCollectionView.reloadData()

      
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.updateProductCollectionHeight()

            self.scrollView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    private func updateCardViewHeight() {
        self.CardView.layoutIfNeeded()

        let totalHeight =
            categoryCollectionHeight.constant +
            productCollectionHeight.constant +
            400   
        CardViewHeight.constant = totalHeight

        self.view.layoutIfNeeded()
    }


    private func updateCategoryCollectionHeight() {
        categoryCollectionView.layoutIfNeeded()
        categoryCollectionHeight.constant = categoryCollectionView.contentSize.height
        updateCardViewHeight()
    }


    private func updateProductCollectionHeight() {
        productCollectionView.layoutIfNeeded()
        
        if showAllProducts {
        
            productCollectionHeight.constant = productCollectionView.contentSize.height
        } else {
          
            productCollectionHeight.constant = originalProductHeight
        }

        updateCardViewHeight()

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }



    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == focusCollectionView {
            return focusItems.count
        } else if collectionView == categoryCollectionView {
            return showAllCategories ? categoryTitles.count : min(6, categoryTitles.count)
        } else {
            return showAllProducts ? products.count : min(16, products.count)
        }
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            let selected = categoryTitles[indexPath.item]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "ItemViewController") as? ItemViewController {
                vc.categoryName = selected
                navigationController?.pushViewController(vc, animated: true)
            }
        }
      
        else if collectionView == productCollectionView {
            let selectedProduct = products[indexPath.item]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController {
                detailVC.productID = selectedProduct.id
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == focusCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier, for: indexPath) as! BannerCell
            let item = focusItems[indexPath.item]
            cell.configure(title: item.title, subtitle: item.subtitle)
            return cell
        } else if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
            cell.configure(imageName: categoryImages[indexPath.row], title: categoryTitles[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
            cell.configure(with: products[indexPath.row], parentVC: self)
            return cell
        }
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView == focusCollectionView {
            return CGSize(width: collectionView.frame.width, height: 168)

        }

    
        if collectionView == categoryCollectionView {
            let text = categoryTitles[indexPath.item]
            let font = UIFont.systemFont(ofSize: 16, weight: .medium)
            let textWidth = text.size(withAttributes: [.font: font]).width
            return CGSize(width: textWidth + 30, height: 30)
        }

        let cellsPerRow: CGFloat = 2
        let spacing: CGFloat = 15
        let availableWidth = collectionView.frame.width - spacing
        let cellWidth = availableWidth / cellsPerRow
        let cellHeight: CGFloat = 170
        
        return CGSize(width: cellWidth, height: cellHeight)
    }

     }

