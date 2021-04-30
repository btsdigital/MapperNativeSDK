// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let contactButton = ImageAsset(name: "contact_button")
  internal static let crossButton = ImageAsset(name: "cross_button")
  internal static let featherShare = ImageAsset(name: "feather_share")
  internal static let plusButton = ImageAsset(name: "plus_button")
  internal static let qrCode = ImageAsset(name: "qr_code")
  internal static let qrScan = ImageAsset(name: "qr_scan")
  internal static let refresh = ImageAsset(name: "refresh")
  internal static let dev = DataAsset(name: "dev")
  internal static let prod = DataAsset(name: "prod")
  internal static let elevation = ColorAsset(name: "elevation")
  internal static let error = ColorAsset(name: "error")
  internal static let highEmphasis = ColorAsset(name: "highEmphasis")
  internal static let highEmphasisHighlighted = ColorAsset(name: "highEmphasisHighlighted")
  internal static let light = ColorAsset(name: "light")
  internal static let lowEmphasis = ColorAsset(name: "lowEmphasis")
  internal static let mediumEmphasis = ColorAsset(name: "mediumEmphasis")
  internal static let primary = ColorAsset(name: "primary")
  internal static let primaryHighlighted = ColorAsset(name: "primaryHighlighted")
  internal static let primaryTransparent = ColorAsset(name: "primaryTransparent")
  internal static let ripple = ColorAsset(name: "ripple")
  internal static let secondary = ColorAsset(name: "secondary")
  internal static let secondaryDark = ColorAsset(name: "secondaryDark")
  internal static let _3Dots = ImageAsset(name: "3_dots")
  internal static let arrowDown = ImageAsset(name: "arrow_down")
  internal static let arrowRight = ImageAsset(name: "arrow_right")
  internal static let avaProfile = ImageAsset(name: "ava_profile")
  internal static let bank = ImageAsset(name: "bank")
  internal static let bankPlaceholder = ImageAsset(name: "bank_placeholder")
  internal static let buttonLoader = ImageAsset(name: "button_loader")
  internal static let checkMark = ImageAsset(name: "checkMark")
  internal static let checkboxSquare = ImageAsset(name: "checkboxSquare")
  internal static let checkboxSquareEmpty = ImageAsset(name: "checkboxSquareEmpty")
  internal static let chevronDown = ImageAsset(name: "chevronDown")
  internal static let chevronRight = ImageAsset(name: "chevronRight")
  internal static let circleCheckmark = ImageAsset(name: "circleCheckmark")
  internal static let clearIcon = ImageAsset(name: "clear_icon")
  internal static let close = ImageAsset(name: "close")
  internal static let closeIcon = ImageAsset(name: "close_icon")
  internal static let contactIcon = ImageAsset(name: "contact_icon")
  internal static let contacts = ImageAsset(name: "contacts")
  internal static let defaultBankIcon = ImageAsset(name: "defaultBankIcon")
  internal static let eurasianBankLogo = ImageAsset(name: "eurasian_bank_logo")
  internal static let featherAlertTriangle = ImageAsset(name: "feather_alert-triangle")
  internal static let featherArrowRight = ImageAsset(name: "feather_arrow_right")
  internal static let featherBriefcase = ImageAsset(name: "feather_briefcase")
  internal static let featherCheckCircle = ImageAsset(name: "feather_check-circle")
  internal static let featherCheck = ImageAsset(name: "feather_check")
  internal static let featherClock = ImageAsset(name: "feather_clock")
  internal static let featherCopy = ImageAsset(name: "feather_copy")
  internal static let featherLogout = ImageAsset(name: "feather_logout")
  internal static let featherPlus = ImageAsset(name: "feather_plus")
  internal static let featherUser = ImageAsset(name: "feather_user")
  internal static let featherUser2 = ImageAsset(name: "feather_user2")
  internal static let featherUsers = ImageAsset(name: "feather_users")
  internal static let individualIcon = ImageAsset(name: "individual_icon")
  internal static let jysanBankLogo = ImageAsset(name: "jysan_bank_logo")
  internal static let legalIcon = ImageAsset(name: "legal_icon")
  internal static let loadingCircle = ImageAsset(name: "loading_circle")
  internal static let loupeIcon = ImageAsset(name: "loupe_icon")
  internal static let qrIcon = ImageAsset(name: "qr_icon")
  internal static let settingGlobe = ImageAsset(name: "setting_globe")
  internal static let settingLock = ImageAsset(name: "setting_lock")
  internal static let settingRules = ImageAsset(name: "setting_rules")
  internal static let settingSupport = ImageAsset(name: "setting_support")
  internal static let settingUser = ImageAsset(name: "setting_user")
  internal static let somberIcon = ImageAsset(name: "somber_icon")
  internal static let starEmpty = ImageAsset(name: "star_empty")
  internal static let starFilled = ImageAsset(name: "star_filled")
  internal static let triangle = ImageAsset(name: "triangle")
  internal static let umbrellaIcon = ImageAsset(name: "umbrella_icon")
  internal static let upsLogo = ImageAsset(name: "upsLogo")
  internal static let warningIcon = ImageAsset(name: "warning_icon")
  internal static let leftShapeItem = ImageAsset(name: "left-shape-item")
  internal static let settingsIcon = ImageAsset(name: "settings_icon")
  internal static let payShadowCell = ImageAsset(name: "pay-shadow-cell")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = Color(asset: self)

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct DataAsset {
  internal fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(macOS)
  @available(iOS 9.0, macOS 10.11, *)
  internal var data: NSDataAsset {
    return NSDataAsset(asset: self)
  }
  #endif
}

#if os(iOS) || os(tvOS) || os(macOS)
@available(iOS 9.0, macOS 10.11, *)
internal extension NSDataAsset {
  convenience init!(asset: DataAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(macOS)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
