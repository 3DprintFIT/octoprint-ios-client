// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum L10n {
  /// Ooops, an error occured
  case anErrorOccured
  /// Can not connect to the printer.
  case couldNotConnectToPrinter
  /// Files
  case files
  /// The credentials you entered are incorrect.
  case incorrectCredentials
  /// Login
  case login
  /// Login Error
  case loginError
  /// Ok
  case ok
  /// Printer
  case printer
  /// Access token
  case printerAccessToken
  /// Printer detail
  case printerDetail
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
      case .anErrorOccured:
        return L10n.tr(key: "An error occured")
      case .couldNotConnectToPrinter:
        return L10n.tr(key: "Could not connect to printer")
      case .files:
        return L10n.tr(key: "Files")
      case .incorrectCredentials:
        return L10n.tr(key: "Incorrect Credentials")
      case .login:
        return L10n.tr(key: "Login")
      case .loginError:
        return L10n.tr(key: "Login Error")
      case .ok:
        return L10n.tr(key: "Ok")
      case .printer:
        return L10n.tr(key: "Printer")
      case .printerAccessToken:
        return L10n.tr(key: "Printer Access Token")
      case .printerDetail:
        return L10n.tr(key: "Printer detail")
      case .printerName:
        return L10n.tr(key: "Printer Name")
      case .printerURL:
        return L10n.tr(key: "Printer URL")
      case .settings:
        return L10n.tr(key: "Settings")
    }
  }

  private static func tr(key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

func tr(_ key: L10n) -> String {
  return key.string
}

private final class BundleToken {}
