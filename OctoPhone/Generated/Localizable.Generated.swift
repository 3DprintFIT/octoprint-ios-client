// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum L10n {
  /// Ooops, an error occured
  case anErrorOccured
  /// Axis
  case axis
  /// Black
  case black
  /// Blue
  case blue
  /// Can not create requested command.
  case canNotCreateRequestedCommand
  /// Can not load stored commands.
  case canNotLoadStoredCommands
  /// Can not open selected log.
  case canNotOpenSelectedLog
  /// Cancel
  case cancel
  /// Center
  case centerOrigin
  /// Circular
  case circularFormFactor
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
  /// Could not save printer profiles.
  case couldNotSavePrinterProfiles
  /// Database error
  case databaseError
  /// Default
  case `default`
  /// Delete
  case delete
  /// Delete log
  case deleteLog
  /// Do you really want to delete log from printer? This action is permanent and cannot be undone.
  case doYouReallyWantToDeleteLogFromPrinter
  /// Do you really want to delete slicing profile from printer? This operation is permanent and can not be undone.
  case doYouReallyWantToDeleteSlicingProfile
  /// Downloaded file can not be opened.
  case downloadedFileCanNotBeOpened
  /// Downloaded list of slicing profiles could not be saved.
  case downloadedListOfSlicingProfilesCouldNotBeSaved
  /// Downloading log file...
  case downloadingLogFile
  /// E
  case eAxis
  /// Files
  case files
  /// Files list could not be loaded.
  case filesListCouldNotBeLoaded
  /// Form factor
  case formFactor
  /// Green
  case green
  /// Heated bed
  case heatedBed
  /// The credentials you entered are incorrect.
  case incorrectCredentials
  /// Inverted control
  case invertedControl
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
  /// Lower left
  case lowerLeftOrigin
  /// mm/min
  case milimetersPerMinute
  /// mm
  case milimetersSign
  /// Nozzle diameter
  case nozzleDiameter
  /// Number of extruders
  case numberOfExtruders
  /// Ok
  case ok
  /// Orange
  case orange
  /// Origin
  case origin
  /// Color
  case printProfileColor
  /// Identifier
  case printProfileIdentifier
  /// Model
  case printProfileModel
  /// Name
  case printProfileName
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
  /// Printer profiles could not be loaded.
  case printerProfilesCouldNotBeLoaded
  /// Printer profiles list could not be downloaded.
  case printerProfilesListCouldNotBeDownloaded
  /// Printer URL
  case printerURL
  /// Rectangular
  case rectangularFormFactor
  /// Red
  case red
  /// Requested command could not be executed.
  case requestedCommandCouldNotBeExecuted
  /// Requested log file could not be downloaded.
  case requestedLogFileCouldNotBeDownloaded
  /// SD card management
  case sdCardManagement
  /// Selected profile could not be opened.
  case selectedProfileCouldNotBeOpened
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
  /// Slicing profile could not be deleted.
  case slicingProfileCouldNotBeDeleted
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
  /// Unknown printer profile
  case unknownPrinterProfile
  /// Unknown slicer
  case unknownSlicer
  /// Unknown slicing profile
  case unknownSlicingProfile
  /// Volume
  case volume
  /// X
  case xAxis
  /// Y
  case yAxis
  /// Yellow
  case yellow
  /// Z
  case zAxis
}
// swiftlint:enable type_body_length

extension L10n: CustomStringConvertible {
  var description: String { return self.string }

  var string: String {
    switch self {
      case .anErrorOccured:
        return L10n.tr(key: "An error occured")
      case .axis:
        return L10n.tr(key: "Axis")
      case .black:
        return L10n.tr(key: "Black")
      case .blue:
        return L10n.tr(key: "Blue")
      case .canNotCreateRequestedCommand:
        return L10n.tr(key: "Can not create requested command")
      case .canNotLoadStoredCommands:
        return L10n.tr(key: "Can not load stored commands")
      case .canNotOpenSelectedLog:
        return L10n.tr(key: "Can not open selected log")
      case .cancel:
        return L10n.tr(key: "Cancel")
      case .centerOrigin:
        return L10n.tr(key: "Center origin")
      case .circularFormFactor:
        return L10n.tr(key: "Circular form factor")
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
      case .couldNotSavePrinterProfiles:
        return L10n.tr(key: "Could not save printer profiles")
      case .databaseError:
        return L10n.tr(key: "Database error")
      case .`default`:
        return L10n.tr(key: "Default")
      case .delete:
        return L10n.tr(key: "Delete")
      case .deleteLog:
        return L10n.tr(key: "Delete log")
      case .doYouReallyWantToDeleteLogFromPrinter:
        return L10n.tr(key: "Do you really want to delete log from printer")
      case .doYouReallyWantToDeleteSlicingProfile:
        return L10n.tr(key: "Do you really want to delete slicing profile")
      case .downloadedFileCanNotBeOpened:
        return L10n.tr(key: "Downloaded file can not be opened")
      case .downloadedListOfSlicingProfilesCouldNotBeSaved:
        return L10n.tr(key: "Downloaded list of slicing profiles could not be saved")
      case .downloadingLogFile:
        return L10n.tr(key: "Downloading log file")
      case .eAxis:
        return L10n.tr(key: "E axis")
      case .files:
        return L10n.tr(key: "Files")
      case .filesListCouldNotBeLoaded:
        return L10n.tr(key: "Files list could not be loaded")
      case .formFactor:
        return L10n.tr(key: "Form factor")
      case .green:
        return L10n.tr(key: "Green")
      case .heatedBed:
        return L10n.tr(key: "Heated bed")
      case .incorrectCredentials:
        return L10n.tr(key: "Incorrect Credentials")
      case .invertedControl:
        return L10n.tr(key: "Inverted control")
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
      case .lowerLeftOrigin:
        return L10n.tr(key: "Lower left origin")
      case .milimetersPerMinute:
        return L10n.tr(key: "Milimeters per minute")
      case .milimetersSign:
        return L10n.tr(key: "Milimeters sign")
      case .nozzleDiameter:
        return L10n.tr(key: "Nozzle diameter")
      case .numberOfExtruders:
        return L10n.tr(key: "Number of extruders")
      case .ok:
        return L10n.tr(key: "Ok")
      case .orange:
        return L10n.tr(key: "Orange")
      case .origin:
        return L10n.tr(key: "Origin")
      case .printProfileColor:
        return L10n.tr(key: "Print profile color")
      case .printProfileIdentifier:
        return L10n.tr(key: "Print profile Identifier")
      case .printProfileModel:
        return L10n.tr(key: "Print profile model")
      case .printProfileName:
        return L10n.tr(key: "Print profile name")
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
      case .printerProfilesCouldNotBeLoaded:
        return L10n.tr(key: "Printer profiles could not be loaded")
      case .printerProfilesListCouldNotBeDownloaded:
        return L10n.tr(key: "Printer profiles list could not be downloaded")
      case .printerURL:
        return L10n.tr(key: "Printer URL")
      case .rectangularFormFactor:
        return L10n.tr(key: "Rectangular form factor")
      case .red:
        return L10n.tr(key: "Red")
      case .requestedCommandCouldNotBeExecuted:
        return L10n.tr(key: "Requested command could not be executed")
      case .requestedLogFileCouldNotBeDownloaded:
        return L10n.tr(key: "Requested log file could not be downloaded")
      case .sdCardManagement:
        return L10n.tr(key: "SD card management")
      case .selectedProfileCouldNotBeOpened:
        return L10n.tr(key: "Selected profile could not be opened")
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
      case .slicingProfileCouldNotBeDeleted:
        return L10n.tr(key: "Slicing profile could not be deleted")
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
      case .unknownPrinterProfile:
        return L10n.tr(key: "Unknown printer profile")
      case .unknownSlicer:
        return L10n.tr(key: "Unknown slicer")
      case .unknownSlicingProfile:
        return L10n.tr(key: "Unknown slicing profile")
      case .volume:
        return L10n.tr(key: "Volume")
      case .xAxis:
        return L10n.tr(key: "X axis")
      case .yAxis:
        return L10n.tr(key: "Y axis")
      case .yellow:
        return L10n.tr(key: "Yellow")
      case .zAxis:
        return L10n.tr(key: "Z axis")
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
