//
//  MedicalRecords.swift
//  Chronic Illness Manager | Andrew Towell 12 Major
//
//  Created by Andrew Towell on 16/3/2024.
//

import SwiftUI

// MARK: -- MEDICAL RECORDS --
struct MedicalRecords: View {
    // observed object (view model)
    @ObservedObject var manager: IllnessManagerViewModel
    
    init(_ m: IllnessManagerViewModel) {
        manager = m
    }
    
    var body: some View {
        VStack {
            
            // Fill Up Header Bar
            HStack {
                Spacer()
            }
            .padding(4)
            .background(getColour(manager.constants.colours.darkColour))
            .shadow(radius: 20)
            
            // Scroll section
            ScrollView {
                /// * main content here *
            }
            
            Spacer() // take up all space
        }
            .navigationTitle("Medical Records")  // title for screen
            .background(getColour(manager.constants.colours.mainColour))
            .foregroundColor(getColour(manager.constants.colours.textColor))
    }
}


#Preview {
    MedicalRecords(IllnessManagerViewModel())
}
