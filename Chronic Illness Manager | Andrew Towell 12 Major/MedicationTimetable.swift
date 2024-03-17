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
                    ForEach (manager.medTimetable.days.indices, id: \.self) {dayIndex in
                        let day = dayIndex + 1
                        let dayAlerts = manager.medTimetable.days[dayIndex]
                        
                        // Day box
                        widgetBox {VStack{
                            // title and delete button
                            HStack {
                                Text("Day \(String(day))")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                                Button(action: {manager.delDay(dayIndex)}, label: {Image(systemName: "clear")})
                                    .foregroundColor(Constants.Colours().buttonFill)
                            }
                            
                            // med alerts list and add alert button
                            VStack {
                                alertList(dayAlerts)
                                
                                // TODO: temporary destination
                                navButton(icon: "plus.square.dashed") {AddAlert(manager: manager, day: day)}
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
    // observed object (view model)
    @ObservedObject var manager: IllnessManagerViewModel
    
    enum FocusedField {
        case name, notes
    }
    // state variables
    @State var name: String = ""
    @State var day: Int
    @State var time = Date()
    @State var backupTime = Date()
    @State var notes: String = ""
    @FocusState var focusedField: FocusedField?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            // Fill Up Header Bar
            HStack {
                Spacer()
            }
            .padding(4)
            .background(Constants.Colours().darkPurple)
            .shadow(radius: 20)
            
            // screen body
            ScrollView {
                // Title
                HStack {
                    Text("New Alert")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding([.top, .leading, .trailing])
                    Spacer()
                }
                
                // widgets
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
                widgetBox {
                    VStack {
                        HStack {
                            Text("Notes")
                            Spacer()
                        }
                        TextField("Notes...", text: $notes, axis: .vertical)
                            .focused($focusedField, equals: .notes)
                            .lineLimit(8, reservesSpace: true)
                    }
                }
                
                // form buttons
                HStack {
                    Button(action: {dismiss()}, label: {Text("Cancel")})
                    Spacer()
                    widgetBox {Button(action: {createAlert()}, label: {Text("Create")})}
                        .frame(width: 130, height: 30)
                }
                .padding(.vertical)
                .foregroundStyle(Constants.Colours().buttonFill)
                
            }
            .padding()
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
    
    // MARK: create alert
    private func createAlert() {
        // provide alert data to manager
        manager.createAlert(name: name, day: day, time: time, backupTime: backupTime, notes: notes)
        // return to timetable screen
        dismiss()
    }
}



#Preview {
    //MedicationTimetable(manager: IllnessManagerViewModel())
    AddAlert(manager: IllnessManagerViewModel(), day: 3)
}
