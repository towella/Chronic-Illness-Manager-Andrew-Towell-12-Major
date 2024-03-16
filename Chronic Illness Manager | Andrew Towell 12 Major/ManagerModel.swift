//
//  ManagerModel.swift
//  Chronic Illness Manager | Andrew Towell 12 Major
//
//  Created by Andrew Towell on 8/3/2024.
//

import Foundation

struct ManagerModel {
    var medTimetable: MedicationTimetable  // declare variable type before initialisation
    
    // initialise model
    init(json: Data?) {
        medTimetable = MedicationTimetable(json: json)
        print(medTimetable)
    }
    
    
    // MARK: -- MEDICATION TIMETABLE --
    
    mutating func addDay() {
        medTimetable.days.append([])
    }
    
    mutating func delDay(_ index: Int) {
        medTimetable.days.remove(at: index)
    }
    
    struct MedicationTimetable: Codable {
        // declare variable types before init
        var days: [[MedicationAlert]] // list of lists of med Alerts [day, [medAlert, ...], ...]
        
        // load in timetable from passed JSON otherwise default to empty 7 days
        init(json: Data?) {
            days = [] // declare days before modification
            var loadDefault = false
            
            // load timetable
            if json != nil {
                // force unwrap json (json!), checks can't be nil
                do {
                    self = try JSONDecoder().decode(MedicationTimetable.self, from: json!)
                } catch {
                    loadDefault = true
                    print("Could not load from JSON. Default timetable created")
                }
            } else {
                loadDefault = true
            }
            
            // create default timetable nothing else works
            if loadDefault {
                // LOAD DEFAULT TIMETABLE HERE
                days = []
                for _ in 0..<7 {days.append([MedicationAlert(id: 1, name: "Waaaaaaaa", day: 2, time: "12:00", backupTime: "12:30", notes: "Weewooo")])}
                print("Loaded default")
            }
        }
        
        
    }
    
    struct MedicationAlert: Codable {
        var id: Int
        var name: String
        var day: Int
        var time: String
        var backupTime: String
        var notes: String
    }
    
    
    
    
    
}
