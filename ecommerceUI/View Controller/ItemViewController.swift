import UIKit

class ItemViewController: UIViewController,
                          UICollectionViewDelegate,
                          UICollectionViewDataSource,
                          UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    var categoryName: String = ""
    private var products: [Product] = []
    private let apiService = APIService()
    @IBOutlet weak var CategoryItemCollectionView: UICollectionView!
    @IBOutlet weak var productLabel: UILabel!
    

    private let filterButton = UIButton(type: .system)
    private let sortButton = UIButton(type: .system)

    private var productListCollectionView: UICollectionView!
    
    var tabs = ["all", "beauty", "furniture", "smartphones", "laptops", "groceries", "fragrances","mens-watches","sports-accessories","tops",
                "womens-bags","Laptops","womens-jewellery","women-watches","home-decoration","womens-dresses","mens-shirts","womens-shoes"]
    var selectedIndex = 0
    

 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar() 
        setupUI()
      
        fetchProducts()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        productListCollectionView.reloadData()
    }

    private func setupNavigationBar() {

        guard let navBar = navigationController?.navigationBar else { return }

        let appearance = UINavigationBarAppearance()
       
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

        

        let config = UIImage.SymbolConfiguration(weight: .bold)
        let backImage = UIImage(systemName: "arrow.left", withConfiguration: config)

        let backButton = UIBarButtonItem(
            image: backImage,
            style: .plain,
            target: self,
            action: #selector(goBack)
        )

        
     
       let searchImage = UIImage(systemName: "magnifyingglass", withConfiguration: config)
        let searchButton = UIBarButtonItem(
            image: searchImage,
            style: .plain,
            target: self,
            action: #selector(searchTapped)
        )
        
       
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = searchButton
        
        
        navigationItem.title = categoryName.capitalized
        
       
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func searchTapped() {

    }
   

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupCategoryCollectionView()
        setupFilterAndSortButtons()
        setupProductListCollectionView()
    
    }

    
    
    private func setupCategoryCollectionView() {
        CategoryItemCollectionView.backgroundColor = .clear
        CategoryItemCollectionView.delegate = self
        CategoryItemCollectionView.dataSource = self
        CategoryItemCollectionView.showsHorizontalScrollIndicator = false
        CategoryItemCollectionView.register(CategoryItemCell.self,
                                            forCellWithReuseIdentifier: CategoryItemCell.identifier)
        
        if let layout = CategoryItemCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 12
            layout.minimumLineSpacing = 12
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    private func setupFilterAndSortButtons() {
        let smallConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)

        // FILTER BUTTON
        filterButton.setTitle("Filter", for: .normal)
        filterButton.setImage(UIImage(systemName: "slider.horizontal.3", withConfiguration: smallConfig), for: .normal)
        filterButton.tintColor = .black
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        filterButton.backgroundColor = .white
        filterButton.layer.cornerRadius = 18
        filterButton.layer.borderWidth = 1
        filterButton.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        filterButton.translatesAutoresizingMaskIntoConstraints = false

        // SORT BUTTON
        sortButton.setTitle("Sort By", for: .normal)
        sortButton.setImage(UIImage(systemName: "chevron.down", withConfiguration: smallConfig), for: .normal)
        sortButton.tintColor = .black
        sortButton.setTitleColor(.black, for: .normal)
        sortButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        sortButton.semanticContentAttribute = .forceRightToLeft
        sortButton.backgroundColor = .white
        sortButton.layer.cornerRadius = 18
        sortButton.layer.borderWidth = 1
        sortButton.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        sortButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(filterButton)
        view.addSubview(sortButton)

        NSLayoutConstraint.activate([
            // FILTER BUTTON
            filterButton.topAnchor.constraint(equalTo: CategoryItemCollectionView.bottomAnchor, constant: 30),
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterButton.heightAnchor.constraint(equalToConstant: 40),
            filterButton.widthAnchor.constraint(equalToConstant: 110),

            // SORT BUTTON
            sortButton.topAnchor.constraint(equalTo: CategoryItemCollectionView.bottomAnchor, constant: 30),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sortButton.heightAnchor.constraint(equalToConstant: 40),
            sortButton.widthAnchor.constraint(equalToConstant: 110)
        ])
    }

    
    private func setupProductListCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 15
        
        productListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        productListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        productListCollectionView.backgroundColor = .clear
        productListCollectionView.delegate = self
        productListCollectionView.dataSource = self
        productListCollectionView.showsVerticalScrollIndicator = false
        productListCollectionView.register(ProductListCell.self,
                                           forCellWithReuseIdentifier: ProductListCell.identifier)
        view.addSubview(productListCollectionView)
        
        NSLayoutConstraint.activate([
            productListCollectionView.topAnchor.constraint(equalTo:productLabel.bottomAnchor, constant: 20),
            productListCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            productListCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            productListCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2)
        ])
    }
    
    private func fetchProducts() {
        apiService.fetchProducts(for: categoryName) { [weak self] products in
            DispatchQueue.main.async {
                self?.products = products
                print("Loaded \(products.count) products for \(self?.categoryName ?? "")")
                self?.productListCollectionView.reloadData()
                self?.CategoryItemCollectionView.reloadData()
            }
        }
    }

  
    
    // MARK: - CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == CategoryItemCollectionView ? tabs.count : products.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == CategoryItemCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryItemCell.identifier, for: indexPath) as! CategoryItemCell
            cell.configure(with: tabs[indexPath.item], isSelected: selectedIndex == indexPath.item)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCell.identifier, for: indexPath) as! ProductListCell
            _ = products[indexPath.item]
            cell.configure(with: products[indexPath.row], parentVC: self)

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == CategoryItemCollectionView {
            // When a category is tapped
            selectedIndex = indexPath.item
            categoryName = tabs[indexPath.item]
            navigationItem.title = categoryName.capitalized
            CategoryItemCollectionView.reloadData()
            fetchProducts()
            
        } else {
            // When a product is tapped
            let selectedProduct = products[indexPath.item]
            print("Selected product:", selectedProduct.title)
            
            //  Navigate to Product Detail Screen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController {
                detailVC.productID = selectedProduct.id 
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }

    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == CategoryItemCollectionView {
            let text = tabs[indexPath.item]
            let width = (text as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]).width
            return CGSize(width: width + 30, height: 40)
        } else {
            let width = (view.frame.width - 48) / 2
            return CGSize(width: width, height: width + 45)
    }
}
}
