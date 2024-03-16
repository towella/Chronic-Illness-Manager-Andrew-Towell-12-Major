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
            let colouredTab = Color(red: 176/255, green: 232/255, blue: 178/255)
            let colouredTabBorder = Color(red: 213/255, green: 213/255, blue: 213/255)
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
    
    
    // MARK: - Medication Timetable -
    private var medicationTimetable: some View {
        VStack {
            
            // Fill Up Header Bar
            HStack {
                Spacer()
            }
            .padding(4)
            .background(Constants.Colours().darkPurple)
            .shadow(radius: 20)
            
            // Scroll section (screen body)
            ScrollView {
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
                                Button(action: {manager.delDay(day)}, label: {Image(systemName: "clear")})
                                    .foregroundColor(Constants.Colours().buttonFill)
                            }
                            
                            // med alerts list and add alert button
                            VStack {
                                alertList(dayAlerts)
                                
                                // TODO: temporary destination
                                navButton(icon: "plus.square.dashed") {addAlert}
                                    .imageScale(.small)
                                    .padding(.top, 1)
                                
                                Spacer() // take up vertical space in row
                            }
                        }}
                    }
                        .padding(5)
                    
                    // add day button
                    widgetBox {
                        Button(
                            action: {manager.addDay()},
                            label: {
                                Text("+ Add Day").foregroundColor(Constants.Colours().buttonFill)
                    })}
                        .frame(width: 120, height: 50)
                        .padding()
                }
            }
        }
            .navigationTitle("Med Timetable")  // title for screen
            .background(Constants.Colours().lightPurple)
    }
    
    // return view of alerts
    private func alertList(_ alerts: Array<ManagerModel.MedicationAlert>) -> some View {
        return ForEach(alerts.indices, id: \.self) { alert in
            let alertData = alerts[alert]
            colouredTab {Text("\(alertData.name) - \(alertData.time)")}
        }
    }
    
    // MARK: Add Alert
    // add alert screen
    private var addAlert: some View {
        enum FocusedField {
            case name, notes
        }
        // state variables
        @State var name: String = ""
        @State var day: Int = 0  // TODO: Set starting day
        @State var time = Date()
        @State var backupTime = Date()
        @State var notes: String = ""
        @FocusState var focusedField: FocusedField?
        
        return VStack {
            // Fill Up Header Bar
            HStack {
                Spacer()
            }
            .padding(4)
            .background(Constants.Colours().darkPurple)
            .shadow(radius: 20)
            
            HStack {
                Text("New Alert")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding([.top, .leading, .trailing])
                Spacer()
            }
            
            // screen body
            Form {
                // widgets
                Section(header: Text("General Info")) {
                    widgetBox {
                        HStack {Text("Medication Name")
                            TextField("Alert title...", text: $name)
                                .focused($focusedField, equals: .name)
                        }}
                        .padding(.top)
                    widgetBox {
                        HStack {Text("Day:  \(day)")
                            Spacer()
                        }}
                    widgetBox {
                        HStack {Text("Time")
                            DatePicker("", selection: $time,
                                       displayedComponents: .hourAndMinute)
                        }}
                    widgetBox {
                        HStack {
                            Text("Backup Time")
                            DatePicker("", selection: $backupTime, displayedComponents: .hourAndMinute)
                        }}
                        .padding(.bottom)
                }
                
                // notes
                Section(header: Text("Notes")) {
                    TextField("Notes...", text: $notes)
                        .focused($focusedField, equals: .notes)
                }
                
                // nav buttons
                HStack {
                    Button(action: {}, label: {Text("Cancel")})
                    Spacer()
                    Button(action: {}, label: {Text("Create")})
                }
                .foregroundStyle(Constants.Colours().buttonFill)
            }
            .scrollContentBackground(.hidden)  // hide grey form background colour
            .textFieldStyle(.roundedBorder)
            .toolbar {
                // push to right
                ToolbarItem(placement: .keyboard) {
                    Spacer()
                }
                // close keyboard button
                ToolbarItem(placement: .keyboard) {
                    Button {focusedField = nil}
                    label: {Image(systemName: "keyboard.chevron.compact.down")}
                }
            }
        }
        .navigationTitle("New Med Alert")  // title for screen
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
    
    private struct colouredTab<Content: View>: View {
        @ViewBuilder let content: Content
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: Constants.Widget().cornerRadius)
                    .foregroundColor(Constants.Colours().colouredTab)
                
                RoundedRectangle(cornerRadius: Constants.Widget().cornerRadius)
                    .strokeBorder(lineWidth: Constants.Widget().lineWidth)
                    .foregroundColor(Constants.Colours().colouredTabBorder)
                    .shadow(radius: Constants.Widget().shadowRadius)
                
                content
                    .padding(3)
            }
        }
    }
    
    
    
}






#Preview {
    // make in place since just preview. Would never do otherwise
    ChronicIllnessManagerView(manager: IllnessManagerViewModel())
}
