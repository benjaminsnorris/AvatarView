/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import UIKit

public typealias AvatarHeaderPresentable = NamePresentable & AvatarPresentable

@IBDesignable open class AvatarHeader: UIView {
    
    // MARK: - Inspectable properties
    
    @IBInspectable open var borderColor: UIColor = UIColor(red: 29 / 255.0, green: 30 / 255.0, blue: 29 / 255.0, alpha: 1.0) {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable open var textColor: UIColor = UIColor(red: 29 / 255.0, green: 30 / 255.0, blue: 29 / 255.0, alpha: 1.0) {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = 0.5 {
        didSet {
            updateSizes()
        }
    }
    
    @IBInspectable open var innerMargin: CGFloat = 16 {
        didSet {
            updateSizes()
        }
    }
    
    @IBInspectable open var innerHeight: CGFloat = 40 {
        didSet {
            updateSizes()
        }
    }
    
    @IBInspectable open var avatarFontName: String? = nil {
        didSet {
            updateName()
        }
    }
    
    @IBInspectable open var fontName: String? = nil {
        didSet {
            updateName()
        }
    }
    
    @IBInspectable open var fontSize: CGFloat = 17.0 {
        didSet {
            updateName()
        }
    }
    
    @IBInspectable open var followReadableWidth: Bool = true {
        didSet {
            readableContentConstraints.forEach { $0.isActive = followReadableWidth }
            fullWidthConstraints.forEach { $0.isActive = !followReadableWidth }
        }
    }
    
    
    // MARK: - Public properties
    
    open var person: AvatarHeaderPresentable? {
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
    open let avatar = AvatarView(frame: .zero)
    
    
    // MARK: - Private properties
    
    fileprivate let name = UILabel()
    fileprivate let stackView = UIStackView()
    fileprivate let topLine = UIView()
    fileprivate let bottomLine = UIView()
    fileprivate var topLineHeightConstraint: NSLayoutConstraint!
    fileprivate var bottomLineHeightConstraint: NSLayoutConstraint!
    fileprivate var stackViewHeightConstraint: NSLayoutConstraint!
    fileprivate var outerMargin: CGFloat = 8
    fileprivate var readableContentConstraints = [NSLayoutConstraint]()
    fileprivate var fullWidthConstraints = [NSLayoutConstraint]()
    
    
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
    
    func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        topLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topLine)
        topLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topLine.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        topLineHeightConstraint = topLine.heightAnchor.constraint(equalToConstant: borderWidth)
        topLineHeightConstraint.isActive = true
        
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomLine)
        bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomLineHeightConstraint = bottomLine.heightAnchor.constraint(equalToConstant: borderWidth)
        bottomLineHeightConstraint.isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        readableContentConstraints.append(stackView.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: outerMargin))
        fullWidthConstraints.append(stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: outerMargin))
        stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: outerMargin).isActive = true
        readableContentConstraints.append(stackView.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: -outerMargin))
        fullWidthConstraints.append(stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -outerMargin))
        stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -outerMargin).isActive = true
        stackViewHeightConstraint = stackView.heightAnchor.constraint(equalToConstant: innerHeight)
        stackViewHeightConstraint.isActive = true
        
        stackView.addArrangedSubview(avatar)
        avatar.heightAnchor.constraint(equalTo: avatar.widthAnchor).isActive = true
        
        stackView.addArrangedSubview(name)
        
        followReadableWidth = true
        updateColors()
        updateSizes()
        updateName()
    }
    
    func updateColors() {
        topLine.backgroundColor = borderColor
        bottomLine.backgroundColor = borderColor
        name.textColor = textColor
    }
    
    func updateSizes() {
        topLineHeightConstraint.constant = borderWidth
        bottomLineHeightConstraint.constant = borderWidth
        stackViewHeightConstraint.constant = innerHeight
        stackView.spacing = innerMargin
    }
    
    func updateName() {
        avatar.fontName = avatarFontName
        let customFont: UIFont
        if let fontName = fontName, let font = UIFont(name: fontName, size: fontSize) {
            customFont = font
        } else {
            customFont = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightLight)
        }
        name.font = customFont
    }
    
}
