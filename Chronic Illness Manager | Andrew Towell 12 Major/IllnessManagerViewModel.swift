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
    @Published private var manager = ManagerModel(json: nil)  // create default manager
    
    private let medTimetableURL: URL = URL.documentsDirectory.appendingPathComponent("medTimetable.JSON")
    
    init() {
        // load manager data from memory if able otherwise stick with default (Could be no data or error with data)
        if let data = try? Data(contentsOf: medTimetableURL){
            manager = ManagerModel(json: data)
        }
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
    
    
    // MARK: -- MEDICATION TIMETABLE --
    
    // computed variable
    var medTimetable: ManagerModel.MedicationTimetable {
        manager.medTimetable
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
    
    
}
