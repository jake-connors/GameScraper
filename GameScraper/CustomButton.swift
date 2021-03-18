import UIKit

class CustomButton: UIButton {
    
    required public init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor

    }
    
    override var isHighlighted: Bool {

        didSet {
            backgroundColor = isHighlighted ? .gray : .systemGray2
        }
    }
}
