import UIKit
class LikeManager {

    static func toggleLike(productId: Int,
                           title: String,
                           imageURL: String,
                           button: UIButton?,
                           viewController: UIViewController) {

        let wasLiked = CoreDataManager.shared.isProductLiked(id: productId)
        let newLikedState = !wasLiked

        if wasLiked {
            CoreDataManager.shared.unlikeProduct(id: productId)
        } else {
            CoreDataManager.shared.likeProduct(id: productId,
                                               title: title,
                                               imageURL: imageURL)
        }

        if let btn = button {
            updateHeart(heartButton: btn, isLiked: newLikedState)
        }

        viewController.showAutoAlert(newLikedState ? "Added to wishlist" : "Removed from wishlist")
    }


    static func updateHeart(heartButton: UIButton, isLiked: Bool) {
        heartButton.adjustsImageWhenHighlighted = false
        
        heartButton.setImage(
            UIImage(systemName: isLiked ? "heart.fill" : "heart"),
            for: .normal
        )

        heartButton.tintColor = isLiked ? .red : .black
    }


    static func updateHeart(heartButton: UIButton, productId: Int) {
        let isLiked = CoreDataManager.shared.isProductLiked(id: productId)
        updateHeart(heartButton: heartButton, isLiked: isLiked)
    }
}


extension UIViewController {
    func showAutoAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            alert.dismiss(animated: true)
        }
    }
}
