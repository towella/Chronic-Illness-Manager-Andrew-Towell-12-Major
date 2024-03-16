//
//  MedicationTimetable.swift
//  Chronic Illness Manager | Andrew Towell 12 Major
//
//  Created by Andrew Towell on 16/3/2024.
//

import SwiftUI


// MARK: -- MED TIMETABLE --
struct MedicationTimetable: View {
    // observed object (view model)
    @ObservedObject var manager: IllnessManagerViewModel
    
    var body: some View {
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
                                navButton(icon: "plus.square.dashed") {AddAlert()}
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
    
    // MARK: alert list
    // return view of alerts
    private func alertList(_ alerts: Array<ManagerModel.MedicationAlert>) -> some View {
        return ForEach(alerts.indices, id: \.self) { alert in
            let alertData = alerts[alert]
            colouredTab {Text("\(alertData.name) - \(alertData.time)")}
        }
    }
    
}


// MARK: -- ADD ALERT --
// add alert screen
struct AddAlert: View {
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
    
    var body: some View {
        VStack {
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
}



#Preview {
    MedicationTimetable(manager: IllnessManagerViewModel())
}
