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
  /// Can not load stored commands.
  case canNotLoadStoredCommands
  /// Can not open selected log.
  case canNotOpenSelectedLog
  /// Cancel
  case cancel
  /// Command
  case command
  /// Yay, command execution failed.
  case commandExecutingFailed
  /// Connection Error
  case connectionError
  /// Can not connect to the printer.
  case couldNotConnectToPrinter
  /// Could not load list of slicers.
  case couldNotLoadListOfSlicers
  /// Could not save downloaded list of logs.
  case couldNotSaveDownloadedListOfLogs
  /// Database error
  case databaseError
  /// Delete
  case delete
  /// Delete log
  case deleteLog
  /// Do you really want to delete log from printer? This action is permanent and cannot be undone.
  case doYouReallyWantToDeleteLogFromPrinter
  /// Downloaded file can not be opened.
  case downloadedFileCanNotBeOpened
  /// Downloaded list of slicing profiles could not be saved.
  case downloadedListOfSlicingProfilesCouldNotBeSaved
  /// Downloading log file...
  case downloadingLogFile
  /// bbb
  case dsdsdsdsdssdsd
  /// Files
  case files
  /// Files list could not be loaded.
  case filesListCouldNotBeLoaded
  /// The credentials you entered are incorrect.
  case incorrectCredentials
  /// Log could not be removed.
  case logCouldNotBeRemoved
  /// Log detail
  case logDetail
  /// Log file could not be deleted from printer.
  case logFileCouldNotBeDeletedFromPrinter
  /// Login
  case login
  /// Login Error
  case loginError
  /// Logs
  case logs
  /// Logs could not be downloaded from printer.
  case logsCouldNotBeDownloadedFromPrinter
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
  /// Requested command could not be executed.
  case requestedCommandCouldNotBeExecuted
  /// Requested log file could not be downloaded.
  case requestedLogFileCouldNotBeDownloaded
  /// SD card management
  case sdCardManagement
  /// Send
  case send
  /// $
  case sendCommandIndicator
  /// Settings
  case settings
  /// %@ bytes
  case sizeInBytes(String)
  /// Slicer profiles could not be loaded.
  case slicerProfilesCouldNotBeLoaded
  /// Slicing
  case slicing
  /// Stored logs could not be loaded.
  case storedLogsCouldNotBeLoaded
  /// Stored printers could not be loaded.
  case storedPrintersCouldNotBeLoaded
  /// Terminal
  case terminal
  /// Uknown file
  case unknownFile
  /// Unknwon file size
  case unknownFileSize
  /// Uknown modofication date
  case unknownModificationDate
  /// Unknown slicer
  case unknownSlicer
  /// Unknown slicing profile
  case unknownSlicingProfile
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
      case .canNotOpenSelectedLog:
        return L10n.tr(key: "Can not open selected log")
      case .cancel:
        return L10n.tr(key: "Cancel")
      case .command:
        return L10n.tr(key: "Command")
      case .commandExecutingFailed:
        return L10n.tr(key: "Command executing failed")
      case .connectionError:
        return L10n.tr(key: "Connection Error")
      case .couldNotConnectToPrinter:
        return L10n.tr(key: "Could not connect to printer")
      case .couldNotLoadListOfSlicers:
        return L10n.tr(key: "Could not load list of slicers")
      case .couldNotSaveDownloadedListOfLogs:
        return L10n.tr(key: "Could not save downloaded list of logs")
      case .databaseError:
        return L10n.tr(key: "Database error")
      case .delete:
        return L10n.tr(key: "Delete")
      case .deleteLog:
        return L10n.tr(key: "Delete log")
      case .doYouReallyWantToDeleteLogFromPrinter:
        return L10n.tr(key: "Do you really want to delete log from printer")
      case .downloadedFileCanNotBeOpened:
        return L10n.tr(key: "Downloaded file can not be opened")
      case .downloadedListOfSlicingProfilesCouldNotBeSaved:
        return L10n.tr(key: "Downloaded list of slicing profiles could not be saved")
      case .downloadingLogFile:
        return L10n.tr(key: "Downloading log file")
      case .dsdsdsdsdssdsd:
        return L10n.tr(key: "dsdsdsdsdssdsd")
      case .files:
        return L10n.tr(key: "Files")
      case .filesListCouldNotBeLoaded:
        return L10n.tr(key: "Files list could not be loaded")
      case .incorrectCredentials:
        return L10n.tr(key: "Incorrect Credentials")
      case .logCouldNotBeRemoved:
        return L10n.tr(key: "Log could not be removed")
      case .logDetail:
        return L10n.tr(key: "Log detail")
      case .logFileCouldNotBeDeletedFromPrinter:
        return L10n.tr(key: "Log file could not be deleted from printer")
      case .login:
        return L10n.tr(key: "Login")
      case .loginError:
        return L10n.tr(key: "Login Error")
      case .logs:
        return L10n.tr(key: "Logs")
      case .logsCouldNotBeDownloadedFromPrinter:
        return L10n.tr(key: "Logs could not be downloaded from printer")
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
      case .requestedCommandCouldNotBeExecuted:
        return L10n.tr(key: "Requested command could not be executed")
      case .requestedLogFileCouldNotBeDownloaded:
        return L10n.tr(key: "Requested log file could not be downloaded")
      case .sdCardManagement:
        return L10n.tr(key: "SD card management")
      case .send:
        return L10n.tr(key: "Send")
      case .sendCommandIndicator:
        return L10n.tr(key: "Send Command Indicator")
      case .settings:
        return L10n.tr(key: "Settings")
      case .sizeInBytes(let p1):
        return L10n.tr(key: "Size in bytes", p1)
      case .slicerProfilesCouldNotBeLoaded:
        return L10n.tr(key: "Slicer profiles could not be loaded")
      case .slicing:
        return L10n.tr(key: "Slicing")
      case .storedLogsCouldNotBeLoaded:
        return L10n.tr(key: "Stored logs could not be loaded")
      case .storedPrintersCouldNotBeLoaded:
        return L10n.tr(key: "Stored printers could not be loaded")
      case .terminal:
        return L10n.tr(key: "Terminal")
      case .unknownFile:
        return L10n.tr(key: "Unknown file")
      case .unknownFileSize:
        return L10n.tr(key: "Unknown file size")
      case .unknownModificationDate:
        return L10n.tr(key: "Unknown modification date")
      case .unknownSlicer:
        return L10n.tr(key: "Unknown slicer")
      case .unknownSlicingProfile:
        return L10n.tr(key: "Unknown slicing profile")
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
