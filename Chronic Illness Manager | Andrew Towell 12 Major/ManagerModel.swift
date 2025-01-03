//
//  ManagerModel.swift
//  Chronic Illness Manager | Andrew Towell 12 Major
//
//  Created by Andrew Towell on 8/3/2024.
//

import Foundation
import UserNotifications
import PDFKit
import SwiftUI

struct ManagerModel {
    var constants:   Constants
    var settings:     UserSettings
    var medTimetable: MedicationTimetable  // declare variable type before initialisation
    var logHistory:   LogHistory
    
    // initialise model
    init(constantsJson: Data?, settingsJson: Data?, medJson: Data?, logJson: Data?) {
        constants    = Constants(json: constantsJson)
        settings     = UserSettings(json: settingsJson)
        medTimetable = MedicationTimetable(json: medJson)
        logHistory   = LogHistory(json: logJson)
    }
    
    // MARK: -- GENERAL --
    func getHelp(screen: String) -> String {
        // main menu help
        if screen == "main_menu" {
            return """
--- Help ---
Settings: Cog icon
Medical Records: Folder icon (under dev)
Calendar: Calendar icon (under dev)
New Log: Plus icon
Log History: List icon
Med Timetable: Pill icon

Notif eg for showcase purposes
"""
        
        // med timetable help
        } else if screen == "med_timetable" {
            return """
--- Help ---
Cycle Start Date: Date which medication cycle is in reference to
Delete day: X icon
New Med Alert: Plus icon (places on given day)
New Day: "+ Add Day" button
"""
        } else if screen == "add_alert" {
            return """
--- Help ---
Time: Primary notification time
Backup Time: Secondary notification time
Confirm Alert: "Create" button
Cancel/Back: "Cancel" and "Back" buttons

Day can not be changed
"""
        } else if screen == "update_alert" {
            return """
--- Help ---
Delete Alert: Trash can icon
Time: Primary notification time
Backup Time: Secondary notification time
Confirm Changes: "Save Changes" button
Cancel/Back: "Cancel" and "Back" buttons
"""
        
        // symptom logger help
        } else if screen == "symptom_logger" {
            return """
--- Help ---
Add Log: Plus icon
Open/Update Log: Click log widget
Export Log(s): Box and arrow icon
"""
        } else if screen == "add_log" {
            return """
--- Help ---
Edit Symptoms: Elipses icon
Add Symptom: Plus icon
Confirm Log: "Create" button
Cancel/Back: "Cancel" and "Back" buttons

Logs may only be created under current date
"""
        } else if screen == "update_log" {
            return """
--- Help ---
Delete Log: Trash can icon
Confirm Changes: "Save Changes" button
Cancel/Back: "Cancel" and "Back" buttons

Date can not be changed.
Symptoms can not be changed or removed.
"""
        } else if screen == "add_symptom_field" {
            return """
--- Help ---
Confirm Field: "Add" button
Cancel/Back: "Cancel" and "Back" buttons
"""
        } else if screen == "update_symptom_fields" {
            return """
--- Help ---
Delete Field: X icon
Confirm Changes: "Save Changes" button
Cancel/Back: "Cancel" and "Back" buttons
"""
        } else if screen == "export_logs" {
            return """
--- Help ---
Range start date: beginning of selection of logs
Range end date: end of selection of logs
Export: "Export" button
Cancel/Back: "Cancel" and "Back" buttons

Save PDF of logs to device storage or share with others
"""
            
        // return error text
        } else {
            return "No help available for this screen."
        }
    }
    
    
    // MARK: -- CONSTANTS --
    struct Constants: Codable {
        var general = General()
        var colours = Colours()
        var widget = Widget()
        
        init(json: Data?) {
            // attempt to load constants
            if json != nil {
                // force unwrap json (json!), checks can't be nil
                do {
                    self = try JSONDecoder().decode(Constants.self, from: json!)
                } catch {
                    print("Could not load from JSON. Default constants used")
                }
            }
        }
        
        // MARK: General
        struct General: Codable {
            var fontSize: CGFloat = 20
        }
        
        // MARK: Colours
        struct Colours: Codable {
            var textColor: [Double] = [0, 0, 0]
            
            var mainColour: [Double] = [231/255, 205/255, 253/255]  // 0, 0, 0
            var darkColour: [Double] = [164/255, 139/255, 211/255]  // -67, -66, -42
            var lightColour: [Double] = [248/255, 237/255, 250/255] // +17, +32, -3
            
            var buttonFill: [Double] = [0, 0, 0]
            var lightOutline: [Double] = [119/255, 119/255, 119/255]
            
            var colouredTabBG: [Double] = [176/255, 232/255, 178/255]  // -55, +27, -75
            var colouredTabBorder: [Double] = [213/255, 213/255, 213/255]
            
            var danger: [Double] = [254/255, 60/255, 48/255]
        }
        
        // MARK: Widget
        struct Widget: Codable {
            var cornerRadius: CGFloat = 12
            var lineWidth: CGFloat = 2
            var shadowRadius: CGFloat = 15
            
        }
    }
    
    
    // MARK: -- SETTINGS --
    
    // resets settings which tracks user settings and constants which should reflect settings
    mutating func resetSettings() {
        // reset user settings
        settings.theme         = UserSettings.Defaults().theme
        settings.notifications = UserSettings.Defaults().notifications
        settings.textColor     = UserSettings.Defaults().textColor
        settings.whiteIcons    = UserSettings.Defaults().whiteIcons
        
        // Reset constants
        constants.general = Constants.General()
        constants.colours = Constants.Colours()
        constants.widget  = Constants.Widget()
    }
    
    
    // modifies settings which tracks user setting and constants which should reflect changes to settings
    mutating func updateSettings(theme: [Double], notifications: Bool, textColor: [Double], whiteIcons: Bool) {
        // settings modifications
        settings.theme         = theme
        settings.notifications = notifications
        settings.textColor     = textColor
        settings.whiteIcons    = whiteIcons
        print(theme)
        print(notifications)
        print(textColor)
        print(whiteIcons)
        
        // -- constants modifications --
        // update icon colours (white or black)
        constants.colours.buttonFill = [0, 0, 0]
        if (whiteIcons) {
            constants.colours.buttonFill = [1, 1, 1]
        }
        print("whiteIcons:")
        print(whiteIcons)
        
        // update core colours
        constants.colours.textColor  = textColor
        constants.colours.mainColour = theme
        // correct theme colours with appropriate relationship with main colour
        // exceeding valid ratio range is handled automatically by swift
        constants.colours.darkColour    = [theme[0] - 67/255, theme[1] - 66/255, theme[2] - 42/255]
        constants.colours.lightColour   = [theme[0] + 17/255, theme[1] + 32/255, theme[2] - 3/255]
        
        // update other colours
        constants.colours.colouredTabBG = [theme[0] - 55/255, theme[1] + 27/255, theme[2] - 75/255]
    }
    
    // colours stored in format provided to SwiftUI Colour() (red/255, green/255, blue/255)
    struct UserSettings: Codable {
        struct Defaults {
            let theme: [Double] = [231/255, 205/255, 253/255]
            let notifications = true
            let textColor: [Double] = [0, 0, 0]
            let whiteIcons = false
        }
        
        var theme: [Double]  // represents rgb of colour
        var notifications: Bool
        var textColor: [Double]  // represents rgb of colour
        var whiteIcons: Bool
        
        // init with json data
        init(json: Data?) {
            // load default settings (will be modified if successful)
            theme         = Defaults().theme
            notifications = Defaults().notifications
            textColor     = Defaults().textColor
            whiteIcons    = Defaults().whiteIcons
            
            // attempt to load user settings
            if json != nil {
                // force unwrap json (json!), checks can't be nil
                do {
                    self = try JSONDecoder().decode(UserSettings.self, from: json!)
                } catch {
                    print("Could not load from JSON. Default settings used")
                }
            }
        }

    }
    
    
    // MARK: -- SYMPTOM LOGGER --
    
    mutating func createLog(title: String, date: Date, fieldVals: [Double], notes: String) {
        var symptomFields: [SymptomField] = []
        let id = logHistory.nextLogId
        logHistory.nextLogId += 1  // increment ID tracker
        // append fields
        for i in logHistory.fieldNames.indices {
            symptomFields.append(SymptomField(name: logHistory.fieldNames[i], value: fieldVals[i]))
        }
        
        // default title
        var newTitle = "Untitled"
        if (title != "") {
            newTitle = title
        }
        
        // create log
        let log = Log(id: id, date: date, title: newTitle, symptomFields: symptomFields, notes: notes)
        // reverse to add to beginning then revert back
        logHistory.logs.reverse()
        logHistory.logs.append(log)  // add log to history
        logHistory.logs.reverse()
    }
    
    mutating func updateLog(id: Int, title: String, date: Date, symptomFields: [ManagerModel.SymptomField], notes: String) {
        // find log then update it with new input data
        for log in logHistory.logs.indices {
            // if id matches, update record dircetly (variable can not be used)
            if logHistory.logs[log].id == id {
                logHistory.logs[log].title = title
                logHistory.logs[log].date = date
                logHistory.logs[log].symptomFields = symptomFields
                logHistory.logs[log].notes = notes
                break  // log has been updated
            }
        }
    }
    
    mutating func delLog(_ id: Int) {
        // loops through logs until correct id is found
        for log in logHistory.logs.indices {
            if logHistory.logs[log].id == id {
                logHistory.logs.remove(at: log)
                break
            }
        }
    }
    
    mutating func addSymptomField(_ name: String) {
        // default title if none provided
        var newName = "Untitled"
        if (name != "") {
            newName = name
        }
        logHistory.fieldNames.append(newName)
    }
    
    mutating func updateFields(_ fieldNames: [String]) {
        logHistory.fieldNames = fieldNames
    }
    
    func exportLogs(startRange: Date, endRange: Date) -> PDFDocument {
        var inRange: [Log] = []
        
        // get all logs within time range
        // will automatically be chronologically sorted (created in order and can not modify date)
        for log in logHistory.logs {
            let logDateStr = log.date.formatted(date: .abbreviated, time: .omitted)  // stringified date (omitts time)
            // if date in range or stringified start == stringified date == stringified end (range encloses a single day)
            // append log
            if (startRange <= log.date && log.date <= endRange) || (startRange.formatted(date: .abbreviated, time: .omitted) == logDateStr && logDateStr == endRange.formatted(date: .abbreviated, time: .omitted)) {
                inRange.append(log)
            }
        }
        
        let dateRangeStr = "(\(startRange.formatted(date: .abbreviated, time: .omitted)) - \(endRange.formatted(date: .abbreviated, time: .omitted)))"
        
        let url = URL.downloadsDirectory
        return createPDF(logs: inRange, path: url, dateRangeStr: dateRangeStr)
    }
    
    func createPDF(logs: [Log], path: URL, dateRangeStr: String) -> PDFDocument {
        // -- init PDF --
        // metadata
        let titleText = "Exported Logs \(dateRangeStr)"
        let pdfMetaData = [
        kCGPDFContextCreator: "Chronic Illness Manager",
        kCGPDFContextAuthor: "Andrew Towell",
        kCGPDFContextTitle: titleText
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        // page sizing (A4 at 72dpi)
        let pageWidth = 8.3 * 72.0
        let pageHeight = 11.7 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        // init pdf renderer with size and metadata
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        // -- render PDF --
        // create context which is used to draw on the pdf
        let data = renderer.pdfData { (context) in
            // begin pdf page (must be called before drawing. Can be called again to make multi page docs)
            context.beginPage()
            
            // page variables
            let leftMargin = 50
            let bottomMargin = 80
            var topMargin = 80
            let width = 500
            let lineHeight = 20
            let spacer = 20
            
            // text attributes
            let mainTitleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
            let headerAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
            let normTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
            
            // render title of document
            let textRect = CGRect(x: leftMargin, y: topMargin, width: width, height: lineHeight)
            titleText.draw(in: textRect, withAttributes: mainTitleAttributes)
            topMargin += spacer
            checkNewPage()
            
            // render logs to pdf
            for log in logs {
                topMargin += spacer  // create space from the last element
                checkNewPage()
                
                renderToPDF(text: log.title, attr: headerAttributes)
                
                // define all the pieces of text to be rendered for a log
                var textToRender: [String] = []
                textToRender.append("Date: \(log.date.formatted(date: .abbreviated, time: .omitted))")
                for symp in log.symptomFields {
                    textToRender.append("\(symp.name): \(Int(symp.value))")
                }
                textToRender.append("Additional Information:")
                // wrap lines for additional info
                var str = ""
                var i = 0
                for char in log.notes {
                    // wrap notes at 80 char line
                    if i % 80 == 0 && i > 0 {
                        textToRender.append(str)
                        str = String(char)  // begin new line
                    // new line if user has entered a newline
                    } else if char == "\n" {
                        textToRender.append(str)
                        str = ""
                    // otherwise continue to build line
                    } else {
                        str += String(char)
                    }
                    i += 1
                }
                // add on remainder of line (otherwise would be cut off)
                if str != "" {
                    textToRender.append(str)
                }
                
                // render data
                for text in textToRender {
                    renderToPDF(text: text, attr: normTextAttributes)
                }
                
            }
            
            // define drawable area and text to be written, then render text to pdf
            func renderToPDF(text: String, attr: [NSAttributedString.Key : UIFont]) {
                let textRect = CGRect(x: leftMargin, y: topMargin, width: width, height: lineHeight)
                text.draw(in: textRect, withAttributes: attr)
                topMargin += lineHeight // move margin down for next line
                checkNewPage()
            }
            
            // used to check if pdf needs a new page
            func checkNewPage() {
                // all must be type double as pageHeight is double
                if Double(topMargin) + Double(spacer) > pageHeight - Double(bottomMargin) {
                    context.beginPage()
                    topMargin = bottomMargin  // reset margin to default (top and bottom margins are the same)
                }
            }
            
        }
            
        
        // -- return Pdf --
        // store pdf in correct format, assign a title to metadata and return
        let pdf = PDFDocument(data: data)!
        pdf.documentAttributes![PDFDocumentAttribute.titleAttribute] = titleText
        return pdf  // return pdf data using PDFDocument data type/struct
    }
    
    
    struct LogHistory: Codable {
        var logs: [Log]
        var fieldNames: [String]
        var nextLogId: Int
        
        // load in log history from passed JSON otherwise default empty
        init(json: Data?) {
            // load default timetable (will be modified if load is successfull, otherwise default remains)
            logs = []
            fieldNames = ["Pain", "Fatigue"]
            nextLogId = 0
            
            // attemtp to load timetable
            if json != nil {
                // force unwrap json (json!), checks can't be nil
                do {
                    self = try JSONDecoder().decode(LogHistory.self, from: json!)
                } catch {
                    print("Could not load from JSON. Default log history created")
                }
            }
        }
    }
    
    struct SymptomField: Codable {
        var name: String
        var value: Double
    }
    
    struct Log: Codable {
        var id: Int
        var date: Date
        var title: String
        var symptomFields: [SymptomField]
        var notes: String
    }
    
    
    
    // MARK: -- MED TIMETABLE --
    
    mutating func addDay() {
        medTimetable.days.append([])
    }
    
    mutating func delDay(_ index: Int) {
        medTimetable.days.remove(at: index)
    }
    
    mutating func createAlert(name: String, day: Int, time: Date, backupTime: Date, notes: String) {
        // get a unique alert id
        let id = medTimetable.nextAlertId
        medTimetable.nextAlertId += 1  // increment counter
        
        var timetable = medTimetable.days  // prevents access conflicts
        
        // default name if empty
        var newName = "Untitled"
        if (name != "") {
            newName = name
        }
        
        // add alert
        let alert = MedicationAlert(id: id, name: newName, day: day, time: time, backupTime: backupTime, notes: notes)
        timetable[day - 1].append(alert)
        // sort based on time
        timetable[day - 1].sort {a1, a2 in sortAlerts(a1, a2)}
        
        medTimetable.days = timetable // reassign modified timetable
    }
    
    mutating func updateAlert(id: Int, name: String, day: Int, time: Date, backupTime: Date, notes: String) {
        var timetable = medTimetable.days  // prevents access conflicts
        
        for dayIndex in timetable.indices {
            for alertIndex in timetable[dayIndex].indices {
                // if id matches, update record dircetly (can't use variable)
                if timetable[dayIndex][alertIndex].id == id {
                    timetable[dayIndex][alertIndex].name = name
                    timetable[dayIndex][alertIndex].day = day
                    timetable[dayIndex][alertIndex].time = time
                    timetable[dayIndex][alertIndex].backupTime = backupTime
                    timetable[dayIndex][alertIndex].notes = notes
                    timetable[dayIndex].sort {a1, a2 in sortAlerts(a1, a2)}
                    medTimetable.days = timetable  // reassign timetable
                    break  // alert has been updated
                }
            }
        }
    }
    
    mutating func delAlert(_ id: Int) {
        // loops through alerts until correct id is found
        for dayIndex in medTimetable.days.indices {
            for alertIndex in medTimetable.days[dayIndex].indices {
                if medTimetable.days[dayIndex][alertIndex].id == id {
                    medTimetable.days[dayIndex].remove(at: alertIndex)
                    break
                }
            }
        }
    }
    
    // sort alerts based on time attribute
    private func sortAlerts(_ a1: MedicationAlert, _ a2: MedicationAlert) -> Bool {
        return a1.time < a2.time
    }
    
    mutating func setCycleStart(_ date: Date) {
        medTimetable.cycleStart = date
    }
    
    // Returns where in the cycle today is
    func getDayInCycle() -> Int? {
        if medTimetable.days.count == 0 {
            return nil
            // special case, timeInterval does not register if both dates are the same
            // must compare date components and ignore time
        } else if medTimetable.cycleStart.formatted(date: .abbreviated, time: .omitted) == Date().formatted(date: .abbreviated, time: .omitted) {
            return 1
        } else {
            let daySeconds: Double = 86400  // number of seconds in a day (must be double to compare with date)
            var today = Date()  // time right now
            
            // extract components of todays date object as ints
            // https://stackoverflow.com/questions/24070450/how-to-get-the-current-time-as-datetime
            let calendar = NSCalendar.current
            let hour = calendar.component(.hour, from: today)
            let minutes = calendar.component(.minute, from: today)
            let seconds = calendar.component(.second, from: today)
            
            // get raw todays date
            today += 10*60*60 // convert date to Australian timezone (+10 hours in seconds)
            today = today - Double(hour * 60 * 60) - Double(minutes * 60) - Double(seconds)  // subtract current time to get date excluding time
            
            // time interval from start of the day cycle starts on IN SECONDS divided to be in whole days!!!
            // +2 to account for inclusive of start date and today
            // TODO: Int rounding does not work properly because not measuring from start of today.
            var interval = Int(abs(medTimetable.cycleStart.distance(to: today) / daySeconds)) + 2
            
            interval %= medTimetable.days.count  // get remainder after division by cycle length
            // if interval = cycle length then division will result in 0 when interval should be equal to cycle length
            if interval == 0 {
                interval = medTimetable.days.count
            }
            
            return interval
        }
    }
    
    // checking for notification permissions
    func checkNotifPerms() {
        // checking for notifcation permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Permission approved!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // request a notification and set it to particular time (works on 24hr time)
    func setNotification(time: Date, alertName: String) {
        // create notification object
        let content = UNMutableNotificationContent()
        content.title = "Time to take your " + alertName + "!"
        content.sound = UNNotificationSound.default

        // convert to 24 hour time
        let time = time.formatted(date: .omitted, time: .shortened)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.date(from: time)
        dateFormatter.dateFormat = "HH:mm"
        
        // extract time
        let date24 = dateFormatter.string(from: date!).components(separatedBy: ":")  // split into hour and minute
        let hour = Int(date24[0])
        let minute = Int(date24[1])
        
        // set time for notification
        var datComp = DateComponents()
        datComp.hour = hour
        datComp.minute = minute
        
        // show notification at given time (does not repeat every day)
        let trigger = UNCalendarNotificationTrigger(dateMatching: datComp, repeats: false)
        
        // choose random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // add notification request
        UNUserNotificationCenter.current().add(request)
    }

    
    struct MedicationTimetable: Codable {
        // declare variable types before init
        var days: [[MedicationAlert]] // list of lists of med Alerts [day, [medAlert, ...], ...]
        var nextAlertId: Int  // keeps track of what ids have been used
        var cycleStart: Date  // reference date for where in the cycle we are
        
        // load in timetable from passed JSON otherwise default to empty 7 days
        init(json: Data?) {
            // load default timetable (will be modified if load is successfull, otherwise default remains)
            days = []
            for _ in 0..<7 {days.append([])}
            nextAlertId = 0
            cycleStart = Date()
            
            // attemtp to load timetable
            if json != nil {
                // force unwrap json (json!), checks can't be nil
                do {
                    self = try JSONDecoder().decode(MedicationTimetable.self, from: json!)
                } catch {
                    print("Could not load from JSON. Default timetable created")
                }
            }
        }
    }
    
    struct MedicationAlert: Codable {
        var id: Int  // unique identifier for alert
        var name: String
        var day: Int
        var time: Date
        var backupTime: Date
        var notes: String
    }
    
}
