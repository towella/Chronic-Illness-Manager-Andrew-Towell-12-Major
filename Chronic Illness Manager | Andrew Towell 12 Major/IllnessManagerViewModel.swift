//
//  IllnessManagerViewModel.swift
//  Chronic Illness Manager | Andrew Towell 12 Major
//
//  Created by Andrew Towell on 8/3/2024.
//

import SwiftUI

// VIEW MODEL
class IllnessManagerViewModel: ObservableObject {
    
    @Published private var manager = ManagerModel()
    
    private let medTimetableURL: URL = URL.documentsDirectory.appendingPathComponent("medTimetable.JSON")
    private let data = 1
    
    // Data structs in data input have to conform to protocol Codable as well!!!!!!!!!
    // dont care called saveData that must conform to codable
    private func save<saveData: Codable>(_ data: saveData, to url: URL) {
        do {
            let data = try JSONEncoder().encode(data)
            try data.write(to: url)
            print("Saved")
        } catch let error {
            print("Error while saving")
        }
    }
    
    
}
