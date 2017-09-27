/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import UIKit

@IBDesignable open class AvatarLineView: UIView {
    
    // MARK: - Inspectable properties
    
    @IBInspectable open var borderColor: UIColor = UIColor(red: 29 / 255.0, green: 30 / 255.0, blue: 29 / 255.0, alpha: 1.0) {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable open var innerColor: UIColor = UIColor(red: 232 / 255.0, green: 236 / 255.0, blue: 237 / 255.0, alpha: 1.0) {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable open var textColor: UIColor = UIColor(red: 29 / 255.0, green: 30 / 255.0, blue: 29 / 255.0, alpha: 1.0) {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable open var avatarBorderWidth: CGFloat = 0.0 {
        didSet {
            updateBorders()
        }
    }
    
    @IBInspectable open var fontName: String? = nil {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable open var fontSize: CGFloat = 17.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable open var overlap: CGFloat = 10 {
        didSet {
            updateAllConstraints()
        }
    }
    
    @IBInspectable open var maxCircles: Int = 3 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    /// If `true` avatars with initials instead of images will be filtered out if possible
    @IBInspectable open var preferImageAvatars = false {
        didSet {
            layoutIfNeeded()
        }
    }
    
    
    fileprivate var avatars = [AvatarPresentable]()
    fileprivate var avatarViews = [AvatarView]()
    fileprivate var borderViews = [UIView]()
    fileprivate var plusAvatar = AvatarView()
    fileprivate let stackView = UIStackView()
    

    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }

    
    // MARK: - Lifecycle overrides
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        borderViews.forEach { borderView in
            borderView.layer.cornerRadius = stackView.frame.size.height / 2
        }
    }
    
}



//MARK: - Public

extension AvatarLineView {
    
    open func update(with avatars: [AvatarPresentable]) {
        self.avatars = avatars
        setUpViews()
    }
    
}


private extension AvatarLineView {
    
    func setUpViews() {
        backgroundColor = .clear
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = -overlap
        addSubview(stackView)
        updateAllConstraints()
        
        self.avatarViews.removeAll()
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0) }
        stackView.subviews.forEach { $0.removeFromSuperview() }
        
        if avatars.isEmpty {
            addAvatar(for: nil)
        } else {
            for (index, avatar) in avatars.enumerated() {
                if avatars.count > maxCircles && index >= maxCircles - 1 {
                    let remaining = avatars.count - index
                    addAvatar(for: nil, text: "+\(remaining)")
                    break
                } else {
                    addAvatar(for: avatar)
                }
            }
        }
    }
    
    func addAvatar(for person: AvatarPresentable?, text: String? = nil) {
        let avatarView = AvatarView()
        setUpAvatarView(avatarView)
        if let person = person {
            avatarView.update(with: person)
        } else {
            avatarView.reset()
            avatarView.initials = text
        }
        
        let borderView = UIView()
        self.borderViews.append(borderView)
        setUpBorderView(borderView)
        addAvatarView(avatarView, to: borderView)
        stackView.addArrangedSubview(borderView)
        self.avatarViews.append(avatarView)
    }
    
    func updateAllConstraints() {
        addConstraint(leadingAnchor.constraint(equalTo: stackView.leadingAnchor))
        addConstraint(topAnchor.constraint(equalTo: stackView.topAnchor))
        addConstraint(bottomAnchor.constraint(equalTo: stackView.bottomAnchor))
        addConstraint(trailingAnchor.constraint(equalTo: stackView.trailingAnchor))
    }
    
    func setUpBorderView(_ borderView: UIView) {
        borderView.clipsToBounds = true
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = borderColor
        borderView.addConstraint(borderView.widthAnchor.constraint(equalTo: borderView.heightAnchor))
    }
    
    func setUpAvatarView(_ avatarView: AvatarView) {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.addConstraint(avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor))
        avatarView.borderColor = borderColor
        avatarView.innerColor = innerColor
        avatarView.textColor = textColor
        avatarView.borderWidth = avatarBorderWidth
        avatarView.fontName = fontName
        avatarView.fontSize = fontSize
    }
    
    func addAvatarView(_ avatarView: AvatarView, to borderView: UIView) {
        borderView.addSubview(avatarView)
        borderView.addConstraint(avatarView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor))
        borderView.addConstraint(avatarView.topAnchor.constraint(equalTo: borderView.topAnchor))
        borderView.addConstraint(borderView.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor))
        borderView.addConstraint(borderView.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor))
    }
    
    func updateBorders() {
        avatarViews.forEach { $0.layer.borderWidth = avatarBorderWidth }
    }
    
    func updateColors() {
        avatarViews.forEach { avatarView in
            avatarView.borderColor = borderColor
            avatarView.textColor = textColor
        }
        borderViews.forEach { borderView in
            borderView.backgroundColor = borderColor
        }
    }
    
}
