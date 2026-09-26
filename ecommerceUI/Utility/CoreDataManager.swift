import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CartModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
            }
            if let url = storeDescription.url {
                        print("Core Data SQLite file location: \(url.path)")
                    }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }


    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Failed to save context: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
  
    
    // Create or Update item
    func addOrUpdateCartItem(_ item: CartItemModel) {
        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", item.id)

        do {
            let results = try context.fetch(fetchRequest)
            if let existingItem = results.first {
     
                existingItem.quantity += Int64(item.quantity)
            } else {
             
                let newItem = CartItemEntity(context: context)
                newItem.id = Int64(item.id)
                newItem.title = item.title
                newItem.price = item.price
                newItem.imageURL = item.imageURL
                newItem.quantity = Int64(item.quantity)
                newItem.size = item.size
                newItem.color = item.color
            }
            saveContext()
        } catch {
            print("Failed to add or update cart item: \(error)")
        }
    }
    

    func fetchCartItems() -> [CartItemModel] {
        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        do {
            let entities = try context.fetch(fetchRequest)
            return entities.map { entity in
                CartItemModel(
                    id: Int(entity.id),
                    title: entity.title ?? "",
                    price: entity.price,
                    imageURL: entity.imageURL ?? "",
                    quantity: Int(entity.quantity),
                    size: entity.size ?? "",
                    color: entity.color ?? ""
                )
            }
        } catch {
            print("Failed to fetch cart items: \(error)")
            return []
        }
    }
    
    
    func deleteCartItem(by id: Int) {
        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let items = try context.fetch(fetchRequest)
            for item in items {
                context.delete(item)
            }
            saveContext()
        } catch {
            print("Failed to delete cart item: \(error)")
        }
    }
    
    // Update quantity for item by id
    func updateQuantity(id: Int, quantity: Int) {
        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let items = try context.fetch(fetchRequest)
            if let item = items.first {
                item.quantity = Int64(quantity)
                saveContext()
            }
        } catch {
            print("Failed to update quantity: \(error)")
        }
    }
    func likeProduct(id: Int, title: String, imageURL: String) {
        let fetchRequest: NSFetchRequest<LikedProductEntity> = LikedProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                let likedItem = LikedProductEntity(context: context)
                likedItem.id = Int64(id)
                likedItem.title = title
                likedItem.imageURL = imageURL
                saveContext()
            }
        } catch {
            print("Failed to like product: \(error)")
        }
    }

    // Remove from Like
    func unlikeProduct(id: Int) {
        let fetchRequest: NSFetchRequest<LikedProductEntity> = LikedProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let results = try context.fetch(fetchRequest)
            for item in results {
                context.delete(item)
            }
            saveContext()
        } catch {
            print("Failed to unlike product: \(error)")
        }
    }

    // Check if product is liked
    func isProductLiked(id: Int) -> Bool {
        let fetchRequest: NSFetchRequest<LikedProductEntity> = LikedProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let results = try context.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print("Failed to check like status: \(error)")
            return false
        }
    }

    // Fetch all liked items
    func fetchLikedProducts() -> [LikedProductEntity] {
        let fetchRequest: NSFetchRequest<LikedProductEntity> = LikedProductEntity.fetchRequest()

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch liked products: \(error)")
            return []
        }
    }
}
