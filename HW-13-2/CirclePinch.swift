
import UIKit

class CirclePinch: UIView {
    var widthConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
    var centerXConstraint: NSLayoutConstraint!
    var centerYConstraint: NSLayoutConstraint!

    var size: CGFloat {
        get { return widthConstraint.constant }
        set {
            widthConstraint.constant = newValue
            heightConstraint.constant = newValue
            self.layer.cornerRadius = newValue / 2
        }
    }

    var currentPosition: CGPoint {
        get {
            return CGPoint(x: centerXConstraint.constant, y: centerYConstraint.constant)
        }
        set {
            centerXConstraint.constant = newValue.x
            centerYConstraint.constant = newValue.y
        }
    }

    init(initialSize: CGFloat) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = [.red, .yellow, .cyan, .blue, .purple, .green].randomElement()
        self.layer.cornerRadius = initialSize / 2
        self.layer.masksToBounds = true
        setupConstraints(initialSize: initialSize)
        addGestureRecognizers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupConstraints(initialSize: CGFloat) {
        widthConstraint = self.widthAnchor.constraint(equalToConstant: initialSize)
        heightConstraint = self.heightAnchor.constraint(equalToConstant: initialSize)

        NSLayoutConstraint.activate([
            widthConstraint,
            heightConstraint
        ])
    }

    private func addGestureRecognizers() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        self.addGestureRecognizer(pinchGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
 
    

    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed {
            let scale = gesture.scale
            size *= scale
            gesture.scale = 1.0
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        self.backgroundColor = [.red, .yellow, .cyan, .blue, .purple, .green]
            .randomElement() ?? .black
    }
    

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let superview = superview else { return }
        
        centerXConstraint = self.centerXAnchor.constraint(equalTo: superview.leftAnchor)
        centerYConstraint = self.centerYAnchor.constraint(equalTo: superview.topAnchor)
        
        NSLayoutConstraint.activate([
            centerXConstraint,
            centerYConstraint
        ])
    }
}

