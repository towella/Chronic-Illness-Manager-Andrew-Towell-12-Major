//
//  MedicalRecords.swift
//  Chronic Illness Manager | Andrew Towell 12 Major
//
//  Created by Andrew Towell on 16/3/2024.
//

import SwiftUI

// MARK: -- MEDICAL RECORDS --
struct MedicalRecords: View {
    var body: some View {
        VStack {
            
            // Fill Up Header Bar
            HStack {
                Spacer()
            }
            .padding(4)
            .background(Constants.Colours().darkPurple)
            .shadow(radius: 20)
            
            // Scroll section
            ScrollView {
                /// * main content here *
            }
            
            Spacer() // take up all space
        }
            .navigationTitle("Medical Records")  // title for screen
            .background(Constants.Colours().lightPurple)
    }
}


#Preview {
    MedicalRecords()
}
