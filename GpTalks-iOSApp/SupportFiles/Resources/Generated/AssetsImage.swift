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
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum AssetsImage {
  internal enum Banner {
    internal static let maskGroup = ImageAsset(name: "Mask Group")
    internal static let bannerClose = ImageAsset(name: "bannerClose")
  }
  internal enum ChatIcons {
    internal static let arrow = ImageAsset(name: "arrow")
    internal static let chatIcon = ImageAsset(name: "chatIcon")
    internal static let gptCorner = ImageAsset(name: "gptCorner")
    internal static let userCorner = ImageAsset(name: "userCorner")
  }
  internal enum HeaderIcons {
    internal static let pro = ImageAsset(name: "pro")
    internal static let proIcon = ImageAsset(name: "proIcon")
  }
  internal enum Icons {
    internal static let backIcon = ImageAsset(name: "backIcon")
    internal static let baseCheck = ImageAsset(name: "baseCheck")
    internal static let category = ImageAsset(name: "category")
    internal static let chat = ImageAsset(name: "chat")
    internal static let chevronLeft = ImageAsset(name: "chevron.left")
    internal static let chevronRight = ImageAsset(name: "chevron.right")
    internal static let close = ImageAsset(name: "close")
    internal static let copy = ImageAsset(name: "copy")
    internal static let delete = ImageAsset(name: "delete")
    internal static let education = ImageAsset(name: "education")
    internal static let email = ImageAsset(name: "email")
    internal static let file = ImageAsset(name: "file")
    internal static let heartFill = ImageAsset(name: "heart.fill")
    internal static let heart = ImageAsset(name: "heart")
    internal static let heart24 = ImageAsset(name: "heart24")
    internal static let history = ImageAsset(name: "history")
    internal static let like = ImageAsset(name: "like")
    internal static let microphone = ImageAsset(name: "microphone")
    internal static let plus = ImageAsset(name: "plus")
    internal static let profile = ImageAsset(name: "profile")
    internal static let robot = ImageAsset(name: "robot")
    internal static let scan = ImageAsset(name: "scan")
    internal static let search = ImageAsset(name: "search")
    internal static let send = ImageAsset(name: "send")
    internal static let sendMessage = ImageAsset(name: "sendMessage")
    internal static let settings = ImageAsset(name: "settings")
    internal static let share = ImageAsset(name: "share")
    internal static let stars = ImageAsset(name: "stars")
  }
  internal enum OnboardingImages {
    internal static let assistantMessage = ImageAsset(name: "assistantMessage")
    internal static let assistantTyping = ImageAsset(name: "assistantTyping")
    internal static let bag = ImageAsset(name: "bag")
    internal static let chatBotIcon = ImageAsset(name: "chatBotIcon")
    internal static let confetti = ImageAsset(name: "confetti")
    internal static let date = ImageAsset(name: "date")
    internal static let fifthBackgroundOnboarding = ImageAsset(name: "fifthBackgroundOnboarding")
    internal static let fire = ImageAsset(name: "fire")
    internal static let firstBackgroundOnboarding = ImageAsset(name: "firstBackgroundOnboarding")
    internal static let fourthBackgroundOnboarding = ImageAsset(name: "fourthBackgroundOnboarding")
    internal static let imageForFirstOnboarding = ImageAsset(name: "imageForFirstOnboarding")
    internal static let imageForSecondOnboarding = ImageAsset(name: "imageForSecondOnboarding")
    internal static let imageForThirdOnboarding = ImageAsset(name: "imageForThirdOnboarding")
    internal static let onboardingHeart = ImageAsset(name: "onboardingHeart")
    internal static let payWallBack = ImageAsset(name: "payWallBack")
    internal static let pizza = ImageAsset(name: "pizza")
    internal static let proImage = ImageAsset(name: "proImage")
    internal static let secondBackgroundOnboarding = ImageAsset(name: "secondBackgroundOnboarding")
    internal static let subscriptionTitle = ImageAsset(name: "subscriptionTitle")
    internal static let thirdBackgroundOnboarding = ImageAsset(name: "thirdBackgroundOnboarding")
    internal static let usersAnswer = ImageAsset(name: "usersAnswer")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
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
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
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

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
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
