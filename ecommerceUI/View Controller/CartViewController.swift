import UIKit
import CoreData

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var ProceedCheckoutButton: UIButton!
    @IBOutlet weak var CartTableView: UITableView!
    @IBOutlet weak var cartTableHeight: NSLayoutConstraint!

    @IBOutlet weak var subtotalTitleLabel: UILabel!
    @IBOutlet weak var subtotalPriceLabel: UILabel!

    private var cartItems: [CartItemModel] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableHeight()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCartData()
        setupNavBar()
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
        navigationItem.title = "Cart"
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }

    private func setupTableView() {
        CartTableView.delegate = self
        CartTableView.dataSource = self
        CartTableView.register(CartItemCell.self, forCellReuseIdentifier: "CartItemCell")
        CartTableView.backgroundColor = .clear
        CartTableView.isScrollEnabled = false   // IMPORTANT
    }

    // MARK: - AUTO HEIGHT UPDATE
    private func updateTableHeight() {
        DispatchQueue.main.async {
            self.CartTableView.layoutIfNeeded()
            self.cartTableHeight.constant = self.CartTableView.contentSize.height
            self.view.layoutIfNeeded()
        }
    }


    private func loadCartData() {
        cartItems = CoreDataManager.shared.fetchCartItems()
        CartTableView.reloadData()
        updateTableHeight()
        updateTotal()
    }

    private func updateTotal() {
        let total = cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
        subtotalPriceLabel.text = "$\(String(format: "%.2f", total))"
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let model = cartItems[indexPath.row]

        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", model.id)

        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemCell

        if let entity = try? CoreDataManager.shared.context.fetch(fetchRequest).first {
            cell.cartItem = entity
        }

        cell.configure(with: model)

        // MARK: - Quantity Changed
        cell.onQuantityChanged = { [weak self] newQty in
            guard let self = self else { return }
            self.cartItems[indexPath.row].quantity = newQty
            self.updateTotal()

            self.CartTableView.reloadData()
            self.updateTableHeight()
        }


        cell.onDeleteTapped = { [weak self] in
            guard let self = self else { return }

            CoreDataManager.shared.deleteCartItem(by: model.id)
            self.cartItems.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .automatic)

            self.updateTableHeight()
            self.updateTotal()
        }

        return cell
    }

    @IBAction func CheckoutButtonTapped(_ sender: Any) {}
}

