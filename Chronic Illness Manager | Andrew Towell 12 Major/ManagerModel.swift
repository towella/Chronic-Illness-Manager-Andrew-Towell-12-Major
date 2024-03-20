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
        
        // add alert
        let alert = MedicationAlert(id: id, name: name, day: day, time: time, backupTime: backupTime, notes: notes)
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
                    print(medTimetable.days[dayIndex][alertIndex].id, id)
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
    
    
    
    struct MedicationTimetable: Codable {
        // declare variable types before init
        var days: [[MedicationAlert]] // list of lists of med Alerts [day, [medAlert, ...], ...]
        var nextAlertId: Int  // keeps track of what ids have been used
        
        // load in timetable from passed JSON otherwise default to empty 7 days
        init(json: Data?) {
            // load default timetable (will be modified if load is successfull, otherwise default remains)
            days = []
            for _ in 0..<7 {days.append([])}
            nextAlertId = 0
            
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
