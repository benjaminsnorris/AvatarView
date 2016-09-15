/*
 |  _   ____   ____   _
 | ⎛ |‾|  ⚈ |-| ⚈  |‾| ⎞
 | ⎝ |  ‾‾‾‾| |‾‾‾‾  | ⎠
 |  ‾        ‾        ‾
 */

import UIKit

public typealias AvatarHeaderPresentable = protocol<NamePresentable, AvatarPresentable>

@IBDesignable public class AvatarHeader: UIView {
    
    // MARK: - Inspectable properties
    
    @IBInspectable public var borderColor: UIColor = UIColor(red: 29 / 255.0, green: 30 / 255.0, blue: 29 / 255.0, alpha: 1.0) {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable public var textColor: UIColor = UIColor(red: 29 / 255.0, green: 30 / 255.0, blue: 29 / 255.0, alpha: 1.0) {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0.5 {
        didSet {
            updateSizes()
        }
    }
    
    @IBInspectable public var innerMargin: CGFloat = 16 {
        didSet {
            updateSizes()
        }
    }
    
    @IBInspectable public var innerHeight: CGFloat = 40 {
        didSet {
            updateSizes()
        }
    }
    
    @IBInspectable public var avatarFontName: String? = nil {
        didSet {
            updateName()
        }
    }

    @IBInspectable public var fontName: String? = nil {
        didSet {
            updateName()
        }
    }
    
    @IBInspectable public var fontSize: CGFloat = 17.0 {
        didSet {
            updateName()
        }
    }
    
    
    // MARK: - Public properties
    
    public var person: AvatarHeaderPresentable? {
        didSet {
            if let person = person {
                avatar.update(with: person)
                name.text = person.name
            } else {
                avatar.reset()
                name.text = nil
            }
        }
    }
    public let avatar = AvatarView(frame: .zero)
    
    
    // MARK: - Private properties
    
    private let name = UILabel()
    private let stackView = UIStackView()
    private let topLine = UIView()
    private let bottomLine = UIView()
    private var topLineHeightConstraint: NSLayoutConstraint!
    private var bottomLineHeightConstraint: NSLayoutConstraint!
    private var stackViewHeightConstraint: NSLayoutConstraint!
    private var outerMargin: CGFloat = 8
    
    
    // MARK: - Initializers
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
}


// MARK: - Private functions

private extension AvatarHeader {
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        topLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topLine)
        topLine.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        topLine.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        topLine.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        topLineHeightConstraint = topLine.heightAnchor.constraintEqualToConstant(borderWidth)
        topLineHeightConstraint.active = true
        
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomLine)
        bottomLine.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        bottomLine.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        bottomLine.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        bottomLineHeightConstraint = bottomLine.heightAnchor.constraintEqualToConstant(borderWidth)
        bottomLineHeightConstraint.active = true

        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.leadingAnchor.constraintEqualToAnchor(readableContentGuide.leadingAnchor, constant: outerMargin).active = true
        stackView.topAnchor.constraintEqualToAnchor(layoutMarginsGuide.topAnchor, constant: outerMargin).active = true
        stackView.trailingAnchor.constraintEqualToAnchor(readableContentGuide.trailingAnchor, constant: -outerMargin).active = true
        stackView.bottomAnchor.constraintEqualToAnchor(layoutMarginsGuide.bottomAnchor, constant: -outerMargin).active = true
        stackViewHeightConstraint = stackView.heightAnchor.constraintEqualToConstant(innerHeight)
        stackViewHeightConstraint.active = true
        
        stackView.addArrangedSubview(avatar)
        avatar.heightAnchor.constraintEqualToAnchor(avatar.widthAnchor).active = true
        
        stackView.addArrangedSubview(name)
        
        updateColors()
        updateSizes()
        updateName()
    }
    
    private func updateColors() {
        topLine.backgroundColor = borderColor
        bottomLine.backgroundColor = borderColor
        name.textColor = textColor
    }
    
    private func updateSizes() {
        topLineHeightConstraint.constant = borderWidth
        bottomLineHeightConstraint.constant = borderWidth
        stackViewHeightConstraint.constant = innerHeight
        stackView.spacing = innerMargin
    }
    
    private func updateName() {
        avatar.fontName = avatarFontName
        let customFont: UIFont
        if let fontName = fontName, font = UIFont(name: fontName, size: fontSize) {
            customFont = font
        } else {
            customFont = UIFont.systemFontOfSize(fontSize, weight: UIFontWeightLight)
        }
        name.font = customFont
    }
    
}
