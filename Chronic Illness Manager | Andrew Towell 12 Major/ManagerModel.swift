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
    
    mutating func createAlert(name: String, day: Int, time: Date, backupTime: Date, notes: String) {
        // get a unique alert id
        var id: Int = 0
        for day in medTimetable.days {
            for _ in day.indices {
                id += 1
            }
        }
        id += 1
        
        // convert times into strings
        let time = time.formatted(date: .omitted, time: .shortened)
        let backupTime = backupTime.formatted(date: .omitted, time: .shortened)
        
        // add alert
        let alert = MedicationAlert(id: id, name: name, day: day, time: time, backupTime: backupTime, notes: notes)
        medTimetable.days[day - 1].append(alert)
        // sort based on time
        medTimetable.days[day - 1].sort {a1, a2 in
            // determine if am or pm time (case insensitive for different devices)
            let ampm1 = a1.time.uppercased().contains("AM") ? "AM" : "PM"
            let ampm2 = a2.time.uppercased().contains("AM") ? "AM" : "PM"
            // compare based on am/pm then on time if am/pm is the same
            if ampm1 == "AM" && ampm2 == "PM" {
                return true
            } 
            else {if ampm1 == "PM" && ampm2 == "AM" {
                    return false
            }
            // compare based on time
            else {
                return a1.time < a2.time
            }}
        }
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
                for _ in 0..<7 {days.append([])}
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
