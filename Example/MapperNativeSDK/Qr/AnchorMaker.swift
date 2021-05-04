import UIKit

typealias AnchorMakerCompletion = ((_ maker: AnchorMaker) -> Void)

final class AnchorMaker {
    // MARK: - Nested types

    /**
     Define connection type of constraint
     similarly equal, greaterThanOrEqualToConstant and lessThanOrEqualToConstant
     */
    enum ConstraintConnectionType {
        case equal, greater, less
    }

    /**
     Represents NSLayoutAnchor<AnchorType> in simple terms for using when make anchor dependences

     - centerX: centerXAnchor representation
     - leading: leadingAnchor representation
     - trailing: trailingAnchor representation
     - centerY: centerYAnchor representation
     - top: topAnchor representation
     - bottom: bottomAnchor representation
     - width: widthAnchor representation
     - height: heightAnchor representation
     */
    enum Anchors: String {
        // MARK: - NSLayoutXAxisAnchor assosiated

        case centerX
        case leading
        case trailing

        // MARK: - NSLayoutYAxisAnchor assosiated

        case centerY
        case top
        case bottom

        // MARK: - NSLayoutDimension assosiated

        case width
        case height

        // MARK: - Public functions

        func xAnchorKeyPath() -> KeyPath<UIView, NSLayoutXAxisAnchor>? {
            switch self {
                case .centerX:
                    return \UIView.centerXAnchor
                case .trailing:
                    return \UIView.trailingAnchor
                case .leading:
                    return \UIView.leadingAnchor
                default:
                    return nil
            }
        }

        func yAnchorKeyPath() -> KeyPath<UIView, NSLayoutYAxisAnchor>? {
            switch self {
                case .centerY:
                    return \UIView.centerYAnchor
                case .bottom:
                    return \UIView.bottomAnchor
                case .top:
                    return \UIView.topAnchor
                default:
                    return nil
            }
        }

        func dimensionKeyPath() -> KeyPath<UIView, NSLayoutDimension>? {
            switch self {
                case .width:
                    return \UIView.widthAnchor
                case .height:
                    return \UIView.heightAnchor
                default:
                    return nil
            }
        }
    }

    private final class AnchorDescription {
        var relatedAnchor: Anchors
        var relatedView: UIView?
        var offset: CGFloat
        var priority: UILayoutPriority?
        var connectionType: ConstraintConnectionType

        var identifier: String {
            return ("\(anchor.rawValue)_to_\(relatedAnchor.rawValue)")
        }

        private(set) var anchor: Anchors
        private(set) var applied: Bool = false

        init(_ anchor: Anchors,
             connectionType: ConstraintConnectionType = .equal,
             offset: CGFloat = 0,
             priority: UILayoutPriority? = nil) {
            self.anchor = anchor
            relatedAnchor = anchor
            self.offset = offset
            self.priority = priority
            self.connectionType = connectionType
        }

        func apply() {
            applied = true
        }
    }

    // MARK: - Properties

    /**
     Add edges anchors to the description for applying later common constraint setting
     - note: can be used with all X and Y Axis assosiated anchors
     */
    var edges: AnchorMaker {
        return insertAnchor(.top)
            .insertAnchor(.bottom)
            .insertAnchor(.trailing)
            .insertAnchor(.leading)
    }

    /**
     Add .center anchor to the description for applying later common constraint setting
     - note: can be used with all X and Y Axis assosiated anchors
     */
    var center: AnchorMaker {
        return insertAnchor(.centerX)
            .insertAnchor(.centerY)
    }

    /**
     Add .centerX anchor to the description for applying later common constraint setting
     - note: can be used with all X and Y Axis assosiated anchors
     */
    var centerX: AnchorMaker {
        return insertAnchor(.centerX)
    }

    /**
     Add .centerY anchor to the description for applying later common constraint setting
     - note: can be used with all X and Y Axis assosiated anchors
     */
    var centerY: AnchorMaker {
        return insertAnchor(.centerY)
    }

    /**
     Add .top anchor to the description for applying later common constraint setting
     - note: can be used with all X and Y Axis assosiated anchors
     */
    var top: AnchorMaker {
        return insertAnchor(.top)
    }

    /**
     Add .bottom anchor to the description for applying later common constraint setting
     - note: can be used with all X and Y Axis assosiated anchors
     */
    var bottom: AnchorMaker {
        return insertAnchor(.bottom)
    }

    /**
     Add .leading anchor to the description for applying later common constraint setting
     - note: can be used with all X and Y Axis assosiated anchors
     */
    var leading: AnchorMaker {
        return insertAnchor(.leading)
    }

    /**
     Add .trailing anchor to the description for applying later common constraint setting
     - note: can be used with all X and Y Axis assosiated anchors
     */
    var trailing: AnchorMaker {
        return insertAnchor(.trailing)
    }

    /**
     Add .width anchor to the description for applying later common constraint setting
     - note: can be used with .height anchor
     */
    var width: AnchorMaker {
        return insertAnchor(.width)
    }

    /**
     Add .height anchor to the description for applying later common constraint setting
     - note: can be used with .width anchor
     */
    var height: AnchorMaker {
        return insertAnchor(.height)
    }

    // MARK: - Private properties

    private var view: UIView
    private var descriptions = [AnchorDescription]()

    // MARK: - Init

    init(view: UIView) {
        self.view = view
    }

    // MARK: - Static functions

    /// Make all constraints by the rules from description
    static func prepareAnchors(view: UIView, completion: AnchorMakerCompletion) {
        guard let superview = view.superview else {
            return
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        let maker = AnchorMaker(view: view)
        completion(maker)
        for description in maker.descriptions {
            switch description.anchor {
                case .centerX, .trailing, .leading:
                    activateXAnchor(view: view, description, superview)
                case .centerY, .top, .bottom:
                    activateYAnchor(view: view, description, superview)
                case .width, .height:
                    activateDimensionAnchor(view: view, description)
            }
        }
    }

    /// Update view constraint constant
    static func updateAnchors(view: UIView, completion: AnchorMakerCompletion) {
        let maker = AnchorMaker(view: view)
        completion(maker)
        for description in maker.descriptions {
            if let constraint = view.constraints.first(where: { $0.identifier == description.identifier }) {
                constraint.constant = description.offset
                view.updateConstraintsIfNeeded()
            }
        }
    }

    // MARK: - Public functions

    /**
     Used for applying NSLayoutDimension constraint .width .height

     - note: $0.height.width.equalTo(60)

     - parameter offset: CGFloat value that will be assigned into NSLayoutDimension constraint

     - returns: AnchorMaker can be used for making additional constraints
     */
    @discardableResult
    func equalTo(_ offset: CGFloat, priority: UILayoutPriority? = nil) -> AnchorMaker {
        for description in descriptions where !description.applied {
            description.offset = offset
            description.priority = priority
            description.apply()
        }
        return self
    }

    /**
     Used for applying NSLayoutDimension constraint .width .height with greaterThanOrEqualToConstant relation

     - note: $0.height.width.greaterOrEqual(60)

     - parameter offset: CGFloat value that will be assigned into NSLayoutDimension constraint

     - returns: AnchorMaker can be used for making additional constraints
     */
    @discardableResult
    func greaterOrEqual(_ offset: CGFloat, priority: UILayoutPriority? = nil) -> AnchorMaker {
        for description in descriptions where !description.applied {
            description.offset = offset
            description.priority = priority
            description.connectionType = .greater
            description.apply()
        }
        return self
    }

    /**
     Used for applying NSLayoutDimension constraint .width .height with lessThanOrEqualToConstant relation

     - note: $0.height.width.lessOrEqual(60)

     - parameter offset: CGFloat value that will be assigned into NSLayoutDimension constraint

     - returns: AnchorMaker can be used for making additional constraints
     */
    @discardableResult
    func lessOrEqual(_ offset: CGFloat, priority: UILayoutPriority? = nil) -> AnchorMaker {
        for description in descriptions where !description.applied {
            description.offset = offset
            description.priority = priority
            description.connectionType = .less
            description.apply()
        }
        return self
    }

    /**
     Apply all constraint, declaratively listed earlier to the superview.
     Only for NSLayoutYAxisAnchor or NSLayoutXAxisAnchor (.top .bottom .centerX .centerY .trailing .leading)

     - note: $0.top.bottom.trailing.equalToSuperview(16) <- it set all edges equal to superview with offset 16

     - parameter offset: CGFloat value that will be assigned into NSLayoutYAxisAnchor or NSLayoutXAxisAnchor constraint

     - returns: AnchorMaker can be used for making additional constraints
     */
    @discardableResult
    func equalToSuperview(_ offset: CGFloat = 0, priority: UILayoutPriority? = nil) -> AnchorMaker {
        for description in descriptions where !description.applied {
            description.offset = offset
            description.priority = priority
            description.apply()
        }
        return self
    }

    /**
     Apply all constraint, declaratively listed earlier to the view anchor from parameter.
     Only for NSLayoutYAxisAnchor or NSLayoutXAxisAnchor (.top .bottom .centerX .centerY .trailing .leading)

     - note: $0.leading.equalTo(avatarImageView, anchor: .leading, 16)

     - Parameters:
        - view: CGFloat value that will be assigned into NSLayoutDimension constraint
        - anchor: What the original anchor is attached to
        - offset: CGFloat value that will be assigned into all constraint

     - returns: AnchorMaker can be used for making additional constraints
     */
    @discardableResult
    func equalTo(_ view: UIView,
                 anchor: Anchors? = nil,
                 _ offset: CGFloat = 0,
                 priority: UILayoutPriority? = nil) -> AnchorMaker {
        for description in descriptions where !description.applied {
            description.relatedView = view
            description.relatedAnchor = anchor ?? description.anchor
            description.offset = offset
            description.priority = priority
            description.apply()
        }
        return self
    }

    // MARK: - Private functions

    private func insertAnchor(_ anchor: Anchors) -> AnchorMaker {
        descriptions.append(AnchorDescription(anchor))
        return self
    }

    private static func activateXAnchor(view: UIView, _ description: AnchorDescription, _ superview: UIView) {
        if
            let selfAnchorPath = description.anchor.xAnchorKeyPath(),
            let relatedAnchorPath = description.relatedAnchor.xAnchorKeyPath() {
            view.anchor(selfAnchorPath,
                        to: description.relatedView ?? superview,
                        relatedAnchorPath,
                        constant: description.offset,
                        identifier: description.identifier,
                        priority: description.priority)
        }
    }

    private static func activateYAnchor(view: UIView, _ description: AnchorDescription, _ superview: UIView) {
        if
            let selfAnchorPath = description.anchor.yAnchorKeyPath(),
            let relatedAnchorPath = description.relatedAnchor.yAnchorKeyPath() {
            view.anchor(selfAnchorPath,
                        to: description.relatedView ?? superview,
                        relatedAnchorPath,
                        constant: description.offset,
                        identifier: description.identifier,
                        priority: description.priority)
        }
    }

    private static func activateDimensionAnchor(view: UIView, _ description: AnchorDescription) {
        if let selfAnchorPath = description.anchor.dimensionKeyPath() {
            let constraint: NSLayoutConstraint
            switch description.connectionType {
                case .equal:
                    constraint = view[keyPath: selfAnchorPath].constraint(equalToConstant: description.offset)
                case .greater:
                    constraint = view[keyPath: selfAnchorPath]
                        .constraint(greaterThanOrEqualToConstant: description.offset)
                case .less:
                    constraint = view[keyPath: selfAnchorPath].constraint(lessThanOrEqualToConstant: description.offset)
            }
            if let priority = description.priority {
                constraint.priority = priority
            }
            constraint.isActive = true
            constraint.identifier = description.identifier
        }
    }
}
