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
    
    
}
