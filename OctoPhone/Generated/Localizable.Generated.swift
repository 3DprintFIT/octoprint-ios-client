// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum L10n {
  /// Files
  case files
  /// Login
  case login
  /// Printer
  case printer
  /// Access token
  case printerAccessToken
  /// Printer name
  case printerName
  /// Printer URL
  case printerURL
  /// Settings
  case settings
}
// swiftlint:enable type_body_length

extension L10n: CustomStringConvertible {
  var description: String { return self.string }

  var string: String {
    switch self {
      case .files:
        return L10n.tr(key: "Files")
      case .login:
        return L10n.tr(key: "Login")
      case .printer:
        return L10n.tr(key: "Printer")
      case .printerAccessToken:
        return L10n.tr(key: "Printer Access Token")
      case .printerName:
        return L10n.tr(key: "Printer Name")
      case .printerURL:
        return L10n.tr(key: "Printer URL")
      case .settings:
        return L10n.tr(key: "Settings")
    }
  }

  private static func tr(key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

func tr(_ key: L10n) -> String {
  return key.string
}
