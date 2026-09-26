import UIKit

class DotIndicatorView: UIView {

    private var dotViews: [UIView] = []
    private var stack: UIStackView?

    func configure(colors: [UIColor]) {
        stack?.removeFromSuperview()
        dotViews.removeAll()

        for color in colors {
            let dot = UIView()
            dot.backgroundColor = color
            dot.layer.cornerRadius = 4
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.widthAnchor.constraint(equalToConstant: 8).isActive = true
            dot.heightAnchor.constraint(equalToConstant: 8).isActive = true
            dotViews.append(dot)
        }

        let stack = UIStackView(arrangedSubviews: dotViews)
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.stack = stack
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

        func setActiveDot(_ index: Int) {
 
            guard let dotsContainer = self.subviews.first else { return }
            
            for (i, dot) in dotsContainer.subviews.enumerated() {
                dot.backgroundColor = i == index ? .systemOrange : .lightGray
            }
        }
}
