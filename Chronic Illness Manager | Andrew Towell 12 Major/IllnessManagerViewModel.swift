//
//  IllnessManagerViewModel.swift
//  Chronic Illness Manager | Andrew Towell 12 Major
//
//  Created by Andrew Towell on 8/3/2024.
//

import SwiftUI

// VIEW MODEL
class IllnessManagerViewModel: ObservableObject {
    // Model which publishes changes via ViewModel to View
    @Published private var manager = ManagerModel(medJson: nil, logJson: nil)  // create default manager
    // Links to access local persistent data
    private let medTimetableURL: URL = URL.documentsDirectory.appendingPathComponent("medTimetable.JSON")
    private let logHistoryURL: URL = URL.documentsDirectory.appendingPathComponent("logHistory.JSON")
    
    init() {
        // load manager data from memory if able otherwise stick with default (Could be no data or error with data)
        let logHistoryData = try? Data(contentsOf: logHistoryURL)
        let medTimetableData = try? Data(contentsOf: medTimetableURL)
        
        // pass JSON to manager
        manager = ManagerModel(medJson: medTimetableData, logJson: logHistoryData)
        
        // check for notification permissions on init then cue notifications for the day
        manager.checkNotifPerms()
    }
    
    // Data structs in data input have to conform to protocol Codable as well!!!!!!!!!
    // dont care called saveData that must conform to codable
    private func save<saveData: Codable>(_ data: saveData, to url: URL) {
        do {
            let data = try JSONEncoder().encode(data)
            try data.write(to: url)
            print("Saved")
        } catch {
            print("Error while saving")
        }
    }
    
    
    
    // MARK: -- SYMPTOM LOGGER --
    
    // computed var
    var logHistory: ManagerModel.LogHistory {
        manager.logHistory
    }
    
    func createLog(title: String, date: Date, sliderVals: [Double], notes: String) {
        manager.createLog(title: title, date: date, fieldVals: sliderVals, notes: notes)
        save(manager.logHistory, to: logHistoryURL)  // save to file
    }
    
    func updateLog(id: Int, title: String, date: Date, symptomFields: [ManagerModel.SymptomField], notes: String) {
        manager.updateLog(id: id, title: title, date: date, symptomFields: symptomFields, notes: notes)
        save(manager.logHistory, to: logHistoryURL)  // save to file
    }
    
    func delLog(_ id: Int) {
        manager.delLog(id)
        save(manager.logHistory, to: logHistoryURL)  // save to file
    }
    
    func addSymptomField(_ name: String) {
        manager.addSymptomField(name)
        save(manager.logHistory, to: logHistoryURL) // save to file
    }
    
    func updateFields(_ fieldNames: [String]) {
        manager.updateFields(fieldNames)
        save(manager.logHistory, to: logHistoryURL) // save to file
    }
    
    func exportLogs(startRange: Date, endRange: Date) {
        manager.exportLogs(startRange: startRange, endRange: endRange)
        
    }
    
    
    
    // MARK: -- MEDICATION TIMETABLE --
    
    // computed variable
    var medTimetable: ManagerModel.MedicationTimetable {
        manager.medTimetable
    }
    
    var cycleStart: Date {
        manager.medTimetable.cycleStart
    }
    
    // save medication timetable
    func saveMedTable() {
        save(manager.medTimetable, to: medTimetableURL)
    }
    
    // add day to med table
    func addDay() {
        manager.addDay()
        saveMedTable()
    }
    
    func delDay(_ index: Int) {
        // if within acceptable range, delete day
        if index <= medTimetable.days.count {
            manager.delDay(index)
            saveMedTable()  // save to persistent memory
        }
    }
    
    func createAlert(name: String, day: Int, time: Date, backupTime: Date, notes: String) {
        // data validation not required as erronous input is not possible with given input field parameters
        manager.createAlert(name: name, day: day, time: time, backupTime: backupTime, notes: notes)
        saveMedTable() // save to persistent memory
    }
    
    func updateAlert(id: Int, name: String, day: Int, time: Date, backupTime: Date, notes: String) {
        // data validation not required as erronous input is not possible with given input field parameters
        manager.updateAlert(id: id, name: name, day: day, time: time, backupTime: backupTime, notes: notes)
        saveMedTable()  // save to persistent memory
    }
    
    func delAlert(_ id: Int) {
        // data validation not required as erronous input is not possible
        manager.delAlert(id)
        saveMedTable()  // save to persistent memory
    }
    
    func setCycleStart(_ date: Date) {
        manager.setCycleStart(date)
        saveMedTable()
    }
    
    func setNotification(time: Date, alertName: String) {
        manager.setNotification(time: time, alertName: alertName)
    }
    
    func getDayInCycle() -> Int? {
        return manager.getDayInCycle()
    }
    
}
