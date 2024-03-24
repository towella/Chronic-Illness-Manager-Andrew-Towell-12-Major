//
//  ContentView.swift
//  Chronic Illness Manager | Andrew Towell 12 Major
//
//  Created by Andrew Towell on 4/3/2024.
//

import SwiftUI

// MARK: -- MAIN MENU --
struct MainMenu: View {
    // observed object (view model)
    @ObservedObject var manager: IllnessManagerViewModel
    @State var time = Date()
    
    var body: some View {
        mainMenu
    }
    
    // MARK: View subsections
    private var mainMenu: some View {
        NavigationStack {
            VStack {
                scrollBody
                controlBar
            }.background(Constants.Colours().darkPurple)
        }
    }
    
    private var scrollBody: some View {
        // Scrollable section
        ScrollView {
            HStack {
                Text("Today's Plan!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                navButton(icon: "gearshape") {Settings()}
            }
            .padding(.horizontal)
            
            dayPlanner
            
            // TODO: TEST ---------
            widgetBox {
                HStack {Text("Notif test")
                    DatePicker("", selection: $time,
                               displayedComponents: .hourAndMinute)
                }}.padding(.horizontal, 5)
            Button("Set time") {
                manager.setNotification(time: time, alertName: "Test")
                print("notif set")
            }
            // --------------------
        }
        .background(Constants.Colours().lightPurple)
    }
    
    private var dayPlanner: some View {

        return ZStack {
            RoundedRectangle(cornerRadius: Constants.Widget().cornerRadius)
                .foregroundColor(Constants.Colours().lightBG)
            
            RoundedRectangle(cornerRadius: Constants.Widget().cornerRadius)
                .strokeBorder(lineWidth: Constants.Widget().lineWidth)
                .foregroundColor(Constants.Colours().lightOutline)
                .shadow(radius: Constants.Widget().shadowRadius)
            VStack {
                Text("12am                                                                 ")
                Spacer()
                Text("06am                                                                 ")
                Spacer()
                Text("Noon                                                                 ")
                Spacer()
                Text("06pm                                                                 ")
                Spacer()
                Text("12pm                                                                 ")
            }.padding(.vertical)
        }.padding(.horizontal)
    }
    
    private var controlBar: some View {
        // Bottom Buttons
        HStack {
            Spacer()
            navButton(icon: "folder") {MedicalRecords()}
            Spacer()
            navButton(icon: "calendar") {Calendar()}
            Spacer()
            navButton(icon: "plus.app") {AddLog()}
            Spacer()
            navButton(icon: "list.bullet") {LogHistory()}
            Spacer()
            navButton(icon: "pill") {MedicationTimetable(manager)}
            Spacer()
        }
        .background(Constants.Colours().darkPurple)
        .shadow(radius: 20)
    }
    
    
}


#Preview {
    // make in place since just preview. Would never do otherwise
    MainMenu(manager: IllnessManagerViewModel())
}
