// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Colors {
  internal enum AccessibleColors {
    internal static let accessibleBlue = ColorAsset(name: "accessibleBlue")
    internal static let accessibleGray01 = ColorAsset(name: "accessibleGray01")
    internal static let accessibleGray02 = ColorAsset(name: "accessibleGray02")
    internal static let accessibleGray03 = ColorAsset(name: "accessibleGray03")
    internal static let accessibleGray04 = ColorAsset(name: "accessibleGray04")
    internal static let accessibleGray05 = ColorAsset(name: "accessibleGray05")
    internal static let accessibleGray06 = ColorAsset(name: "accessibleGray06")
    internal static let accessibleGreen = ColorAsset(name: "accessibleGreen")
    internal static let accessibleIndigo = ColorAsset(name: "accessibleIndigo")
    internal static let accessibleOrange = ColorAsset(name: "accessibleOrange")
    internal static let accessiblePink = ColorAsset(name: "accessiblePink")
    internal static let accessiblePurple = ColorAsset(name: "accessiblePurple")
    internal static let accessibleRed = ColorAsset(name: "accessibleRed")
    internal static let accessibleTeal = ColorAsset(name: "accessibleTeal")
    internal static let accessibleYellow = ColorAsset(name: "accessibleYellow")
  }
  internal enum DefaultColors {
    internal static let blue = ColorAsset(name: "blue")
    internal static let gray01 = ColorAsset(name: "gray01")
    internal static let gray02 = ColorAsset(name: "gray02")
    internal static let gray03 = ColorAsset(name: "gray03")
    internal static let gray04 = ColorAsset(name: "gray04")
    internal static let gray05 = ColorAsset(name: "gray05")
    internal static let gray06 = ColorAsset(name: "gray06")
    internal static let green = ColorAsset(name: "green")
    internal static let indigo = ColorAsset(name: "indigo")
    internal static let orange = ColorAsset(name: "orange")
    internal static let pink = ColorAsset(name: "pink")
    internal static let purple = ColorAsset(name: "purple")
    internal static let red = ColorAsset(name: "red")
    internal static let teal = ColorAsset(name: "teal")
    internal static let yellow = ColorAsset(name: "yellow")
  }
  internal enum FillColor {
    internal static let fill01 = ColorAsset(name: "fill01")
    internal static let fill02 = ColorAsset(name: "fill02")
    internal static let fill03 = ColorAsset(name: "fill03")
    internal static let fill04 = ColorAsset(name: "fill04")
    internal static let fill05 = ColorAsset(name: "fill05")
  }
  internal enum LabelColor {
    internal static let label01 = ColorAsset(name: "label01")
    internal static let label02 = ColorAsset(name: "label02")
    internal static let label03 = ColorAsset(name: "label03")
    internal static let label04 = ColorAsset(name: "label04")
  }
  internal enum LinearGradient {
    internal static let colorGradient1 = ColorAsset(name: "colorGradient1")
    internal static let colorGradient2 = ColorAsset(name: "colorGradient2")
    internal static let colorGradient3 = ColorAsset(name: "colorGradient3")
  }
  internal enum SeparatorColor {
    internal static let separator01 = ColorAsset(name: "separator01")
    internal static let separator02 = ColorAsset(name: "separator02")
  }
  internal enum SystemBackgrounds {
    internal static let background01 = ColorAsset(name: "background01")
    internal static let background02 = ColorAsset(name: "background02")
    internal static let background03 = ColorAsset(name: "background03")
  }
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
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
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

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

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
