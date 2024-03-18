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
        var timetable = medTimetable.days  // prevents access conflicts
        var id: Int = 0
        for day in timetable {
            for _ in day.indices {
                id += 1
            }
        }
        id += 1
        
        // add alert
        let alert = MedicationAlert(id: id, name: name, day: day, time: time, backupTime: backupTime, notes: notes)
        timetable[day - 1].append(alert)
        // sort based on time
        timetable[day - 1].sort {a1, a2 in sortAlerts(a1, a2)}
        
        medTimetable.days = timetable // reassign timetable
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
    
    // sort alerts based on time attribute
    private func sortAlerts(_ a1: MedicationAlert, _ a2: MedicationAlert) -> Bool {
        return a1.time < a2.time
        // convert times to strings
//        let t1 = a1.time.formatted(date: .omitted, time: .shortened)
//        let t2 = a2.time.formatted(date: .omitted, time: .shortened)
//        // determine if am or pm time (case insensitive for different devices)
//        let ampm1 = t1.uppercased().contains("AM") ? "AM" : "PM"
//        let ampm2 = t2.uppercased().contains("AM") ? "AM" : "PM"
//        // compare based on am/pm then on time if am/pm is the same
//        if ampm1 == "AM" && ampm2 == "PM" {
//            return true
//        }
//        else {if ampm1 == "PM" && ampm2 == "AM" {
//                return false
//        }
//        // compare based on time. First the hour then the minutes as INTEGERS not string!!!
//            else {if Int(t1[t1.index(t1.startIndex, offsetBy: 1)]) < Int(t2[t2.index(t2.startIndex, offsetBy: 1)]) {
//            return true
//        }
//        else { if Int(t1[3]+t1[4]) < Int(t2[3]+t2[3]) {
//            return true
//        }}}}
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
        var time: Date
        var backupTime: Date
        var notes: String
    }
    
    
    
    
    
}
