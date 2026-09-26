class CartManager {
    static let shared = CartManager()
    private init() {}

    func addToCart(item: CartItemModel) {
        CoreDataManager.shared.addOrUpdateCartItem(item)
    }

    func getCartItems() -> [CartItemModel] {
        return CoreDataManager.shared.fetchCartItems()
    }

    func deleteCartItem(id: Int) {
        CoreDataManager.shared.deleteCartItem(by: id)
    }

    func updateItemQuantity(id: Int, quantity: Int) {
        CoreDataManager.shared.updateQuantity(id: id, quantity: quantity)
    }
}
