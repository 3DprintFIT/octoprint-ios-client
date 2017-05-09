// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum L10n {
  /// Add new slicing profile
  case addNewSlicingProfile
  /// All
  case allFiles
  /// Ooops, an error occured
  case anErrorOccured
  /// An error occured when requested file was queued for print.
  case anErrorOccuredWhileTryingToPrintFile
  /// Axis
  case axis
  /// Bed settings
  case bedSettings
  /// Bed temperature
  case bedTemperature
  /// Bed temperature offset
  case bedTemperatureOffset
  /// Bed temperature target
  case bedTemperatureTarget
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
  /// Cancel print job
  case cancelPrintJob
  /// Cannot load list of connections.
  case cannotLoadListOfConnections
  /// Center
  case centerOrigin
  /// Circular
  case circularFormFactor
  /// Close printer
  case closePrinter
  /// Command
  case command
  /// Yay, command execution failed.
  case commandExecutingFailed
  /// Connect.
  case connectPrinter
  /// Connect printer
  case connectPrinterTitle
  /// Connection Error
  case connectionError
  /// Can not connect to the printer.
  case couldNotConnectToPrinter
  /// Could not delete print profile from printer.
  case couldNotDeletePrintProfileFromPrinter
  /// Could not load list of slicers.
  case couldNotLoadListOfSlicers
  /// Could not load printer settings
  case couldNotLoadPrinter
  /// Could not load printer stream.
  case couldNotLoadPrinterStream
  /// Could not save downloaded list of logs.
  case couldNotSaveDownloadedListOfLogs
  /// Could not save printer profiles.
  case couldNotSavePrinterProfiles
  /// Could not set bed temperature
  case couldNotSetBedTemperature
  /// Created profile could not be saved localy, but is created on printer.
  case createdProfileCouldNotBeSavedLocaly
  /// Database error
  case databaseError
  /// Default
  case defaultColor
  /// Delete
  case delete
  /// Delete log
  case deleteLog
  /// Do you really want to delete this file from printer? This action is permanent and cannot be undone.
  case doYouReallyWantToDeleteFileFromPrinter
  /// Do you really want to delete log from printer? This action is permanent and cannot be undone.
  case doYouReallyWantToDeleteLogFromPrinter
  /// Do you really want to delete print profile? This action is permanent and cannot be undone.
  case doYouReallyWantToDeletePrintProfile
  /// Do you really want to delete slicing profile from printer? This operation is permanent and can not be undone.
  case doYouReallyWantToDeleteSlicingProfile
  /// Do you really want to cancel current job? This action cannot be undone.
  case doYouWantToCancelPrintJob
  /// Downloaded file can not be opened.
  case downloadedFileCanNotBeOpened
  /// Downloaded list of slicing profiles could not be saved.
  case downloadedListOfSlicingProfilesCouldNotBeSaved
  /// Downloading log file...
  case downloadingLogFile
  /// E
  case eAxis
  /// Extrude
  case extrudeFilament
  /// GCode analysis
  case fileAnalysis
  /// Attributes
  case fileAttributes
  /// File could not be deleted, because is currently printed
  case fileCouldNotBeDeletedBecauseIsPrinted
  /// File could not be delete because it was not found on the printer.
  case fileCouldNotBeDeletedBecauseWasNotFound
  /// File could not be deleted, becuase an error occured
  case fileCouldNotBeDeletedBecauseAnErrorOccured
  /// File could not be printed
  case fileCouldNotBePrinted
  /// Failure prints
  case fileFailurePrints
  /// Filament length
  case fileFilamentLength
  /// Filament volume
  case fileFilamentVolume
  /// Last modification
  case fileLastModification
  /// File name
  case fileName
  /// Size
  case fileSize
  /// Print statistics
  case fileStats
  /// Success prints
  case fileSuccessPrints
  /// Type
  case fileType
  /// Files
  case files
  /// Files list could not be loaded.
  case filesListCouldNotBeLoaded
  /// SD Card
  case filesOnCard
  /// Printer
  case filesOnPrinter
  /// Form factor
  case formFactor
  /// GCode file
  case gcodeFile
  /// Green
  case green
  /// Heated bed
  case heatedBed
  /// The credentials you entered are incorrect.
  case incorrectCredentials
  /// Init
  case initSDCard
  /// Inverted control
  case invertedControl
  /// File
  case jobFile
  /// Print time
  case jobPrintTime
  /// Print time left
  case jobPrintTimeLeft
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
  /// No connection is selected.
  case noConnectionSelected
  /// No, I do not
  case noIDoNot
  /// No connection available.
  case notConnectionAvailable
  /// Nozzle diameter
  case nozzleDiameter
  /// Number of extruders
  case numberOfExtruders
  /// Offset temperature
  case offsetTemperature
  /// Ok
  case ok
  /// Orange
  case orange
  /// Origin
  case origin
  /// Printer command could not be issued.
  case printHeadCommandCouldNotBeIssued
  /// Color
  case printProfileColor
  /// Print profile could not be deleted localy.
  case printProfileCouldNotBeDeletedFromLocaly
  /// Identifier
  case printProfileIdentifier
  /// Model
  case printProfileModel
  /// Name
  case printProfileName
  /// Print profile update was not successfull.
  case printProfileUpdateWasNotSuccessfull
  /// Print profiles
  case printProfiles
  /// Printer
  case printer
  /// Access token
  case printerAccessToken
  /// Controls
  case printerControls
  /// Printer detail
  case printerDetail
  /// Printer is currently not in operational state. If you want to connect printer, click the button below.
  case printerIsCurrentlyNotInOperationalState
  /// Requested file could not be printed because printer is not currently operational.
  case printerIsNotOperational
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
  /// Profile could not be created.
  case profileCouldNotBeCreated
  /// Rectangular
  case rectangularFormFactor
  /// Red
  case red
  /// Refresh
  case refreshSDCard
  /// Release
  case releaseSDCard
  /// Requested command could not be executed.
  case requestedCommandCouldNotBeExecuted
  /// Requested log file could not be downloaded.
  case requestedLogFileCouldNotBeDownloaded
  /// There was an issue while performing requested SD card command.
  case sdCardCommandFailed
  /// SD card management
  case sdCardManagement
  /// Not connected
  case sdCardNotConnected
  /// Ready
  case sdCardReady
  /// SD card state is not available.
  case sdCardStateIsNotAvailable
  /// Selected file could not be uploaded.
  case selectedFileCouldNotBeUploaded
  /// Selected port could not be connected.
  case selectedPortCouldNotBeConnected
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
  /// Slicer profile
  case slicerProfile
  /// Slicer profiles
  case slicerProfiles
  /// Slicer profiles could not be loaded.
  case slicerProfilesCouldNotBeLoaded
  /// Slicing
  case slicing
  /// Slicing profile could not be created.
  case slicingProfileCouldNotBeCreated
  /// Slicing profile could not be deleted.
  case slicingProfileCouldNotBeDeleted
  /// Description
  case slicingProfileDescription
  /// Profile name and description are required fields.
  case slicingProfileFieldsAreRequired
  /// Profile name
  case slicingProfileName
  /// File reference
  case slicingProfileReference
  /// STL model
  case stlModel
  /// Stored logs could not be loaded.
  case storedLogsCouldNotBeLoaded
  /// Stored printers could not be loaded.
  case storedPrintersCouldNotBeLoaded
  /// Stream URL (optional)
  case streamURL
  /// Target temeprature
  case targetTemperature
  /// Terminal
  case terminal
  /// Unknown
  case unknown
  /// Uknown file
  case unknownFile
  /// Unknown file name
  case unknownFileName
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
      case .addNewSlicingProfile:
        return L10n.tr(key: "Add new slicing profile")
      case .allFiles:
        return L10n.tr(key: "All files")
      case .anErrorOccured:
        return L10n.tr(key: "An error occured")
      case .anErrorOccuredWhileTryingToPrintFile:
        return L10n.tr(key: "An error occured while trying to print file")
      case .axis:
        return L10n.tr(key: "Axis")
      case .bedSettings:
        return L10n.tr(key: "Bed settings")
      case .bedTemperature:
        return L10n.tr(key: "Bed temperature")
      case .bedTemperatureOffset:
        return L10n.tr(key: "Bed temperature offset")
      case .bedTemperatureTarget:
        return L10n.tr(key: "Bed temperature target")
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
      case .cancelPrintJob:
        return L10n.tr(key: "Cancel print job")
      case .cannotLoadListOfConnections:
        return L10n.tr(key: "Cannot load list of connections")
      case .centerOrigin:
        return L10n.tr(key: "Center origin")
      case .circularFormFactor:
        return L10n.tr(key: "Circular form factor")
      case .closePrinter:
        return L10n.tr(key: "Close printer")
      case .command:
        return L10n.tr(key: "Command")
      case .commandExecutingFailed:
        return L10n.tr(key: "Command executing failed")
      case .connectPrinter:
        return L10n.tr(key: "Connect printer")
      case .connectPrinterTitle:
        return L10n.tr(key: "Connect printer title")
      case .connectionError:
        return L10n.tr(key: "Connection Error")
      case .couldNotConnectToPrinter:
        return L10n.tr(key: "Could not connect to printer")
      case .couldNotDeletePrintProfileFromPrinter:
        return L10n.tr(key: "Could not delete print profile from printer")
      case .couldNotLoadListOfSlicers:
        return L10n.tr(key: "Could not load list of slicers")
      case .couldNotLoadPrinter:
        return L10n.tr(key: "Could not load printer")
      case .couldNotLoadPrinterStream:
        return L10n.tr(key: "Could not load printer stream")
      case .couldNotSaveDownloadedListOfLogs:
        return L10n.tr(key: "Could not save downloaded list of logs")
      case .couldNotSavePrinterProfiles:
        return L10n.tr(key: "Could not save printer profiles")
      case .couldNotSetBedTemperature:
        return L10n.tr(key: "Could not set bed temperature")
      case .createdProfileCouldNotBeSavedLocaly:
        return L10n.tr(key: "Created profile could not be saved localy")
      case .databaseError:
        return L10n.tr(key: "Database error")
      case .defaultColor:
        return L10n.tr(key: "Default color")
      case .delete:
        return L10n.tr(key: "Delete")
      case .deleteLog:
        return L10n.tr(key: "Delete log")
      case .doYouReallyWantToDeleteFileFromPrinter:
        return L10n.tr(key: "Do you really want to delete file from printer")
      case .doYouReallyWantToDeleteLogFromPrinter:
        return L10n.tr(key: "Do you really want to delete log from printer")
      case .doYouReallyWantToDeletePrintProfile:
        return L10n.tr(key: "Do you really want to delete print profile")
      case .doYouReallyWantToDeleteSlicingProfile:
        return L10n.tr(key: "Do you really want to delete slicing profile")
      case .doYouWantToCancelPrintJob:
        return L10n.tr(key: "Do you want to cancel print job")
      case .downloadedFileCanNotBeOpened:
        return L10n.tr(key: "Downloaded file can not be opened")
      case .downloadedListOfSlicingProfilesCouldNotBeSaved:
        return L10n.tr(key: "Downloaded list of slicing profiles could not be saved")
      case .downloadingLogFile:
        return L10n.tr(key: "Downloading log file")
      case .eAxis:
        return L10n.tr(key: "E axis")
      case .extrudeFilament:
        return L10n.tr(key: "Extrude filament")
      case .fileAnalysis:
        return L10n.tr(key: "File analysis")
      case .fileAttributes:
        return L10n.tr(key: "File attributes")
      case .fileCouldNotBeDeletedBecauseIsPrinted:
        return L10n.tr(key: "File could not be deleted because is printed")
      case .fileCouldNotBeDeletedBecauseWasNotFound:
        return L10n.tr(key: "File could not be deleted because was not found")
      case .fileCouldNotBeDeletedBecauseAnErrorOccured:
        return L10n.tr(key: "File could not be deleted, because an error occured")
      case .fileCouldNotBePrinted:
        return L10n.tr(key: "File could not be printed")
      case .fileFailurePrints:
        return L10n.tr(key: "File failure prints")
      case .fileFilamentLength:
        return L10n.tr(key: "File filament length")
      case .fileFilamentVolume:
        return L10n.tr(key: "File filament volume")
      case .fileLastModification:
        return L10n.tr(key: "File last modification")
      case .fileName:
        return L10n.tr(key: "File name")
      case .fileSize:
        return L10n.tr(key: "File size")
      case .fileStats:
        return L10n.tr(key: "File stats")
      case .fileSuccessPrints:
        return L10n.tr(key: "File success prints")
      case .fileType:
        return L10n.tr(key: "File type")
      case .files:
        return L10n.tr(key: "Files")
      case .filesListCouldNotBeLoaded:
        return L10n.tr(key: "Files list could not be loaded")
      case .filesOnCard:
        return L10n.tr(key: "Files on card")
      case .filesOnPrinter:
        return L10n.tr(key: "Files on printer")
      case .formFactor:
        return L10n.tr(key: "Form factor")
      case .gcodeFile:
        return L10n.tr(key: "Gcode file")
      case .green:
        return L10n.tr(key: "Green")
      case .heatedBed:
        return L10n.tr(key: "Heated bed")
      case .incorrectCredentials:
        return L10n.tr(key: "Incorrect Credentials")
      case .initSDCard:
        return L10n.tr(key: "Init SD card")
      case .invertedControl:
        return L10n.tr(key: "Inverted control")
      case .jobFile:
        return L10n.tr(key: "Job file")
      case .jobPrintTime:
        return L10n.tr(key: "Job print time")
      case .jobPrintTimeLeft:
        return L10n.tr(key: "Job print time left")
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
      case .noConnectionSelected:
        return L10n.tr(key: "No connection selected")
      case .noIDoNot:
        return L10n.tr(key: "No I do not")
      case .notConnectionAvailable:
        return L10n.tr(key: "Not connection available")
      case .nozzleDiameter:
        return L10n.tr(key: "Nozzle diameter")
      case .numberOfExtruders:
        return L10n.tr(key: "Number of extruders")
      case .offsetTemperature:
        return L10n.tr(key: "Offset temperature")
      case .ok:
        return L10n.tr(key: "Ok")
      case .orange:
        return L10n.tr(key: "Orange")
      case .origin:
        return L10n.tr(key: "Origin")
      case .printHeadCommandCouldNotBeIssued:
        return L10n.tr(key: "Print head command could not be issued")
      case .printProfileColor:
        return L10n.tr(key: "Print profile color")
      case .printProfileCouldNotBeDeletedFromLocaly:
        return L10n.tr(key: "Print profile could not be deleted from localy")
      case .printProfileIdentifier:
        return L10n.tr(key: "Print profile Identifier")
      case .printProfileModel:
        return L10n.tr(key: "Print profile model")
      case .printProfileName:
        return L10n.tr(key: "Print profile name")
      case .printProfileUpdateWasNotSuccessfull:
        return L10n.tr(key: "Print profile update was not successfull")
      case .printProfiles:
        return L10n.tr(key: "Print profiles")
      case .printer:
        return L10n.tr(key: "Printer")
      case .printerAccessToken:
        return L10n.tr(key: "Printer Access Token")
      case .printerControls:
        return L10n.tr(key: "Printer controls")
      case .printerDetail:
        return L10n.tr(key: "Printer detail")
      case .printerIsCurrentlyNotInOperationalState:
        return L10n.tr(key: "Printer is currently not in operational state")
      case .printerIsNotOperational:
        return L10n.tr(key: "Printer is not operational")
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
      case .profileCouldNotBeCreated:
        return L10n.tr(key: "Profile could not be created")
      case .rectangularFormFactor:
        return L10n.tr(key: "Rectangular form factor")
      case .red:
        return L10n.tr(key: "Red")
      case .refreshSDCard:
        return L10n.tr(key: "Refresh SD card")
      case .releaseSDCard:
        return L10n.tr(key: "Release SD card")
      case .requestedCommandCouldNotBeExecuted:
        return L10n.tr(key: "Requested command could not be executed")
      case .requestedLogFileCouldNotBeDownloaded:
        return L10n.tr(key: "Requested log file could not be downloaded")
      case .sdCardCommandFailed:
        return L10n.tr(key: "SD card command failed")
      case .sdCardManagement:
        return L10n.tr(key: "SD card management")
      case .sdCardNotConnected:
        return L10n.tr(key: "SD card not connected")
      case .sdCardReady:
        return L10n.tr(key: "SD card ready")
      case .sdCardStateIsNotAvailable:
        return L10n.tr(key: "SD card state is not available")
      case .selectedFileCouldNotBeUploaded:
        return L10n.tr(key: "Selected file could not be uploaded")
      case .selectedPortCouldNotBeConnected:
        return L10n.tr(key: "Selected port could not be connected")
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
      case .slicerProfile:
        return L10n.tr(key: "Slicer profile")
      case .slicerProfiles:
        return L10n.tr(key: "Slicer profiles")
      case .slicerProfilesCouldNotBeLoaded:
        return L10n.tr(key: "Slicer profiles could not be loaded")
      case .slicing:
        return L10n.tr(key: "Slicing")
      case .slicingProfileCouldNotBeCreated:
        return L10n.tr(key: "Slicing profile could not be created")
      case .slicingProfileCouldNotBeDeleted:
        return L10n.tr(key: "Slicing profile could not be deleted")
      case .slicingProfileDescription:
        return L10n.tr(key: "Slicing profile description")
      case .slicingProfileFieldsAreRequired:
        return L10n.tr(key: "Slicing profile fields are required")
      case .slicingProfileName:
        return L10n.tr(key: "Slicing profile name")
      case .slicingProfileReference:
        return L10n.tr(key: "Slicing profile reference")
      case .stlModel:
        return L10n.tr(key: "Stl model")
      case .storedLogsCouldNotBeLoaded:
        return L10n.tr(key: "Stored logs could not be loaded")
      case .storedPrintersCouldNotBeLoaded:
        return L10n.tr(key: "Stored printers could not be loaded")
      case .streamURL:
        return L10n.tr(key: "Stream URL")
      case .targetTemperature:
        return L10n.tr(key: "Target temperature")
      case .terminal:
        return L10n.tr(key: "Terminal")
      case .unknown:
        return L10n.tr(key: "Unknown")
      case .unknownFile:
        return L10n.tr(key: "Unknown file")
      case .unknownFileName:
        return L10n.tr(key: "Unknown file name")
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
