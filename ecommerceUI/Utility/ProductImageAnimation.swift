import UIKit

extension UIImageView {

    func addTapEnlargeAnimation() {
        self.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleEnlargeTap))
        self.addGestureRecognizer(tap)
    }

    @objc private func handleEnlargeTap() {
        UIView.animate(withDuration: 0.15,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.6,
                       options: .curveEaseInOut) {
            
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            
        } completion: { _ in
            UIView.animate(withDuration: 0.15) {
                self.transform = .identity
            }
        }
    }
}
