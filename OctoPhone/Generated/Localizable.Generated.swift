// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum L10n {
  /// Ooops, an error occured
  case anErrorOccured
  /// Can not create requested command.
  case canNotCreateRequestedCommand
  /// Can not load stored commands
  case canNotLoadStoredCommands
  /// Command
  case command
  /// Connection Error
  case connectionError
  /// Can not connect to the printer.
  case couldNotConnectToPrinter
  /// Files
  case files
  /// Files list could not be loaded.
  case filesListCouldNotBeLoaded
  /// The credentials you entered are incorrect.
  case incorrectCredentials
  /// Login
  case login
  /// Login Error
  case loginError
  /// Logs
  case logs
  /// Ok
  case ok
  /// Print profiles
  case printProfiles
  /// Printer
  case printer
  /// Access token
  case printerAccessToken
  /// Printer detail
  case printerDetail
  /// Printer list
  case printerList
  /// Printer name
  case printerName
  /// Printer URL
  case printerURL
  /// SD card management
  case sdCardManagement
  /// Send
  case send
  /// $
  case sendCommandIndicator
  /// Settings
  case settings
  /// Slicing
  case slicing
  /// Terminal
  case terminal
}
// swiftlint:enable type_body_length

extension L10n: CustomStringConvertible {
  var description: String { return self.string }

  var string: String {
    switch self {
      case .anErrorOccured:
        return L10n.tr(key: "An error occured")
      case .canNotCreateRequestedCommand:
        return L10n.tr(key: "Can not create requested command")
      case .canNotLoadStoredCommands:
        return L10n.tr(key: "Can not load stored commands")
      case .command:
        return L10n.tr(key: "Command")
      case .connectionError:
        return L10n.tr(key: "Connection Error")
      case .couldNotConnectToPrinter:
        return L10n.tr(key: "Could not connect to printer")
      case .files:
        return L10n.tr(key: "Files")
      case .filesListCouldNotBeLoaded:
        return L10n.tr(key: "Files list could not be loaded")
      case .incorrectCredentials:
        return L10n.tr(key: "Incorrect Credentials")
      case .login:
        return L10n.tr(key: "Login")
      case .loginError:
        return L10n.tr(key: "Login Error")
      case .logs:
        return L10n.tr(key: "Logs")
      case .ok:
        return L10n.tr(key: "Ok")
      case .printProfiles:
        return L10n.tr(key: "Print profiles")
      case .printer:
        return L10n.tr(key: "Printer")
      case .printerAccessToken:
        return L10n.tr(key: "Printer Access Token")
      case .printerDetail:
        return L10n.tr(key: "Printer detail")
      case .printerList:
        return L10n.tr(key: "Printer list")
      case .printerName:
        return L10n.tr(key: "Printer Name")
      case .printerURL:
        return L10n.tr(key: "Printer URL")
      case .sdCardManagement:
        return L10n.tr(key: "SD card management")
      case .send:
        return L10n.tr(key: "Send")
      case .sendCommandIndicator:
        return L10n.tr(key: "Send Command Indicator")
      case .settings:
        return L10n.tr(key: "Settings")
      case .slicing:
        return L10n.tr(key: "Slicing")
      case .terminal:
        return L10n.tr(key: "Terminal")
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
