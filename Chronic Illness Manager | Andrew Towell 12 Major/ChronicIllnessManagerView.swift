//
//  ContentView.swift
//  Chronic Illness Manager | Andrew Towell 12 Major
//
//  Created by Andrew Towell on 4/3/2024.
//

import SwiftUI

struct ChronicIllnessManagerView: View {
    // observed object (view model)
    @ObservedObject var manager: IllnessManagerViewModel
    
    // MARK: -- CONSTANTS --
    struct Constants {
        struct Colours {
            let lightPurple = Color(red: 231/255, green: 205/255, blue: 253/255)
            let darkPurple = Color(red: 164/255, green: 139/255, blue: 211/255)
            let lightBG = Color(red: 248/255, green: 237/255, blue: 250/255)
            let buttonFill = Color(red: 0, green: 0, blue: 0)
            let lightOutline = Color(red: 119/255, green: 119/255, blue: 119/255)
        }
        struct Widget {
            let cornerRadius: CGFloat = 12
            let lineWidth: CGFloat = 2
            let shadowRadius: CGFloat = 15
        }
    }
    
    
    // MARK: -- BODY --
    var body: some View {
        mainMenu
    }
    
    
    // MARK: -- SCREENS --
    
    
    
    // MARK: Main Menu
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
                navButton(icon: "gearshape") {settings}
            }
            .padding(.horizontal)
            
            dayPlanner
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
                Text("12am --------------------------------------")
                Spacer()
                Text("06am --------------------------------------")
                Spacer()
                Text("Noon --------------------------------------")
                Spacer()
                Text("06pm --------------------------------------")
                Spacer()
                Text("12pm --------------------------------------")
            }.padding(.vertical)
        }.padding(.horizontal)
    }
    
    private var controlBar: some View {
        // Bottom Buttons
        HStack {
            Spacer()
            navButton(icon: "folder") {files}
            Spacer()
            navButton(icon: "calendar") {calendar}
            Spacer()
            navButton(icon: "plus.app") {addLog}
            Spacer()
            navButton(icon: "list.bullet") {logHistory}
            Spacer()
            navButton(icon: "pill") {medicationTimetable}
            Spacer()
        }
        .background(Constants.Colours().darkPurple)
        .shadow(radius: 20)
    }
    
    
    // MARK: Settings
    private var settings: some View {
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
            .navigationTitle("Settings")  // title for screen
            .background(Constants.Colours().lightPurple)
    }
    
    
    // MARK: Files
    private var files: some View {
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
            .navigationTitle("Illness Records")  // title for screen
            .background(Constants.Colours().lightPurple)
    }
    
    
    // MARK: Calendar
    private var calendar: some View {
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
            .navigationTitle("Calendar")  // title for screen
            .background(Constants.Colours().lightPurple)
    }
    
    
    // MARK: Add Log
    private var addLog: some View {
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
            .navigationTitle("New Log")  // title for screen
            .background(Constants.Colours().lightPurple)
    }
    
    
    // MARK: Log History
    private var logHistory: some View {
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
            .navigationTitle("Log History")  // title for screen
            .background(Constants.Colours().lightPurple)
    }
    
    
    // MARK: Medication Timetable
    private var medicationTimetable: some View {
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
                Button(action: {manager.saveMedTable()}, label: {
                    Text("Save Test")
                })
                
                // create timetable UI
                LazyVGrid(columns: [GridItem(spacing: 0), GridItem(spacing: 0)], spacing: 0) {
                    ForEach (manager.medTimetable.days.indices, id: \.self) {day in
                        let dayAlerts = manager.medTimetable.days[day]
                        // Day box
                        widgetBox {VStack{
                            // title and delete button
                            HStack {
                                Text("Day \(String(day + 1))")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {Image(systemName: "clear")})
                                    .foregroundColor(Constants.Colours().buttonFill)
                            }
                            
                            // med alerts list and add alert button
                            VStack {
                                alertList(dayAlerts)
                                
                                // TODO: temporary destination
                                navButton(icon: "plus.square.dashed") {addAlert}
                                    .imageScale(.small)
                            }
                            
                        }}
                        
                    }
                        .padding(5)
                }
            }
        }
            .navigationTitle("Med Timetable")  // title for screen
            .background(Constants.Colours().lightPurple)
    }
    
    private func alertList(_ alerts: Array<ManagerModel.MedicationAlert>) -> some View {
        return ForEach(alerts.indices, id: \.self) { alert in
            Rectangle()
        }
    }
    
    private var addAlert: some View {
        VStack{
            // Fill Up Header Bar
            HStack {
                Spacer()
            }
            .padding(4)
            .background(Constants.Colours().darkPurple)
            .shadow(radius: 20)
            
            Text("YIPPEEEEEEE")
            Spacer()
        }
        .navigationTitle("Add Med Alert")  // title for screen
        .background(Constants.Colours().lightPurple)
    }
    
    
    // MARK: -- STRUCTS --
    
    // creates a navigation link with a given icon and destination view
    private struct navButton<Destination: View>: View {
        var icon: String  // icon for button
        @ViewBuilder var destination: Destination  // provide a destination view to open
        // create button as navlink
        var body: some View {
            NavigationLink(
                destination: destination,
                label: {Label(icon, systemImage: icon)
                        .font(.largeTitle)
                        .foregroundColor(Constants.Colours().buttonFill)
                        .labelStyle(.iconOnly)
                })
        }
    }
    
    private struct widgetBox<Content: View>: View {
        @ViewBuilder let content: Content
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: Constants.Widget().cornerRadius)
                    .foregroundColor(Constants.Colours().lightBG)
                
                RoundedRectangle(cornerRadius: Constants.Widget().cornerRadius)
                    .strokeBorder(lineWidth: Constants.Widget().lineWidth)
                    .foregroundColor(Constants.Colours().lightOutline)
                    .shadow(radius: Constants.Widget().shadowRadius)
                
                // Box Content
                content
                    .padding()
            }
        }
    }
    
    
    
}






#Preview {
    // make in place since just preview. Would never do otherwise
    ChronicIllnessManagerView(manager: IllnessManagerViewModel())
}
