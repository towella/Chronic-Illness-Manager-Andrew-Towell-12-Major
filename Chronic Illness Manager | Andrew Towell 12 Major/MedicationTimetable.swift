//
//  MedicationTimetable.swift
//  Chronic Illness Manager | Andrew Towell 12 Major
//
//  Created by Andrew Towell on 16/3/2024.
//

import SwiftUI

// MARK: ------ SCREENS -------

// MARK: -- MED TIMETABLE --
struct MedicationTimetable: View {
    // observed object (view model)
    @ObservedObject var manager: IllnessManagerViewModel
    // State variables (set default values)
    @State var cycleStart: Date = Date()
    @State var showDelAlert = false
    @State var dayInCycle: Int? = nil
    @State var dayToDel = 0
    
    init(_ m: IllnessManagerViewModel) {
        manager = m
        cycleStart = m.cycleStart
        dayInCycle = m.getDayInCycle()
    }
    
    private var cycleHeader: some View {
        return VStack {
            Text("Note: notifications do not function (no access to a server to schedule and send)").font(.custom("Small", size: 10))
            widgetBox(manager: manager,
                      borderColor: getColour(manager.constants.colours.lightOutline)) {
                HStack {Text("Cycle Start Date")
                    // can only pick dates before or including today
                    DatePicker("", selection: $cycleStart,
                               in: ...Date(),
                               displayedComponents: .date)
                    Button("Set") {
                        updateCycle()
                    }
                    Spacer()
                }
            }
                      .padding([.horizontal, .top], 5)
        }
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

            // Scroll section (screen body)
            ScrollView {
                cycleHeader
                
                // create timetable UI
                LazyVGrid(columns: [GridItem(spacing: 0), GridItem(spacing: 0)], spacing: 0) {
                    ForEach (manager.medTimetable.days.indices, id: \.self) {dayIndex in
                        let day = dayIndex + 1
                        let dayAlerts = manager.medTimetable.days[dayIndex]
                        
                        // Day box
                        widgetBox(manager: manager,
                                  borderColor: getColour(manager.constants.colours.lightOutline)) { VStack {
                            // title and delete button
                            HStack {
                                ZStack {
                                    // highlights which day of cycle we are on
                                    if dayInCycle == day {
                                        RoundedRectangle(cornerRadius: 25)
                                            .foregroundColor(.red)
                                        Text("Day \(String(day))")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    // default
                                    } else {
                                        Text("Day \(String(day))")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                    }
                                }
                                Spacer()
                                // must record what day to delete as popup does not show immediately, allowing dayIndex to be changed to the wrong day before deletion occurs.
                                Button(action: {dayToDel = dayIndex; showDelAlert = true},
                                       label: {Image(systemName: "clear")})
                                    .alert("Delete day "+String(dayToDel + 1), isPresented: $showDelAlert) {
                                                Button("Cancel", role: .cancel) {}
                                                Button("Delete", role: .destructive) {
                                                    delDay(dayToDel)}
                                            }
                                    .foregroundColor(getColour(manager.constants.colours.buttonFill))
                            }

                            // med alerts list and add alert button
                            VStack {
                                // list of alerts
                                alertList(dayAlerts)
                                // add alert button
                                navButton(manager: manager, icon: "plus.square.dashed") {AddAlert(manager: manager, day: day)}
                                    .imageScale(.small)
                                    .padding(.top, 1)
                                Spacer() // push everything up
                            }
                        }}
                    }
                        .padding(5)
                    
                    // add day button
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        Button(
                            action: {addDay()},
                            label: {
                                Text("+ Add Day").foregroundColor(getColour(manager.constants.colours.buttonFill))
                    })}
                        .frame(width: 120, height: 50)
                        .padding()
                }
            }
        }
            .navigationTitle("Med Timetable")  // title for screen
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    helpButton(manager: manager, screen: "med_timetable")
                }
            }
            .background(getColour(manager.constants.colours.mainColour))
            .foregroundColor(getColour(manager.constants.colours.textColor))
            .onAppear {
                cycleStart = manager.cycleStart
                dayInCycle = manager.getDayInCycle()
            }
    }
    
    // MARK: alert list
    // return view of alerts
    private func alertList(_ alerts: Array<ManagerModel.MedicationAlert>) -> some View {
        ForEach(alerts.indices, id: \.self) { alert in
            let alertData = alerts[alert]
            AlertTab(
                manager: manager,
                content: {Text("\(alertData.name) - \(alertData.time.formatted(date: .omitted, time: .shortened))")},
                destination: UpdateAlert(
                    manager: manager,
                    id: alertData.id,
                    name: alertData.name,
                    day: alertData.day,
                    time: alertData.time,
                    backupTime: alertData.backupTime,
                    notes: alertData.notes))
        }
    }
    
    private func updateCycle() {
        manager.setCycleStart(cycleStart)
        dayInCycle = manager.getDayInCycle()
    }
    
    private func addDay() {
        manager.addDay()
        dayInCycle = manager.getDayInCycle()
    }
    
    private func delDay(_ dayIndex: Int) {
        manager.delDay(dayIndex)
        dayInCycle = manager.getDayInCycle()
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
            .background(getColour(manager.constants.colours.darkColour))
            .shadow(radius: 20)
            
            // screen body
            ScrollView {
                VStack {
                    // Title
                    HStack {
                        Text("New Alert")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.top)
                        Spacer()
                    }
                    
                    // widgets
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        HStack {Text("Medication Name")
                            TextField("Alert title...", text: $name)
                                .focused($focusedField, equals: .name)
                                .onChange(of: name) {
                                    name = limitText(upper: 20, str: name)
                                }
                        }}
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        HStack {Text("Day:  \(day)")
                            Spacer()
                        }}
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        HStack {Text("Time")
                            DatePicker("", selection: $time,
                                       displayedComponents: .hourAndMinute)
                        }}
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        HStack {
                            Text("Backup Time")
                            DatePicker("", selection: $backupTime, displayedComponents: .hourAndMinute)
                        }}
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        VStack {
                            HStack {
                                Text("Notes")
                                Spacer()
                            }
                            TextField("Notes...", text: $notes, axis: .vertical)
                                .focused($focusedField, equals: .notes)
                                .lineLimit(8, reservesSpace: true)
                                .onChange(of: notes) {
                                    notes = limitText(upper: 400, str: notes)
                                }
                        }
                    }
                    
                    // form buttons
                    HStack {
                        Button(action: {dismiss()}, label: {Text("Cancel")})
                        Spacer()
                        widgetBox(manager: manager,
                                  borderColor: getColour(manager.constants.colours.lightOutline)) {Button(action: {createAlert()}, label: {Text("Create")})}
                            .frame(width: 130, height: 30)
                    }
                    .padding(.vertical)
                    .foregroundStyle(getColour(manager.constants.colours.buttonFill))
                }
                .padding(.horizontal)
            }
            .scrollContentBackground(.hidden)  // hide grey form background colour
            .textFieldStyle(.roundedBorder)
            .toolbar {
                // KEYBOARD ITEMS
                // push to right
                ToolbarItem(placement: .keyboard) {
                    Spacer()
                }
                // close keyboard button
                ToolbarItem(placement: .keyboard) {
                    Button {focusedField = nil}
                label: {Image(systemName: "keyboard.chevron.compact.down")}
                }
                
                // SCREEN HEADER ITEMS
                ToolbarItem(placement: .navigationBarTrailing) {
                    helpButton(manager: manager, screen: "add_alert")
                }
            }
        }
        .navigationTitle("New Med Alert")  // title for screen
        .background(getColour(manager.constants.colours.mainColour))
        .foregroundColor(getColour(manager.constants.colours.textColor))
    }
    
    // MARK: create alert
    private func createAlert() {
        // provide alert data to manager
        manager.createAlert(name: name, day: day, time: time, backupTime: backupTime, notes: notes)
        // return to timetable screen
        dismiss()
    }
    
}


// MARK: -- UPDATE ALERT --
struct UpdateAlert: View {
    // observed object (view model)
    @ObservedObject var manager: IllnessManagerViewModel
    
    enum FocusedField {
        case name, notes
    }
    let id: Int
    // state alert data variables
    @State var name: String
    @State var day: Int
    @State var time: Date
    @State var backupTime: Date
    @State var notes: String
    @FocusState var focusedField: FocusedField?  // what input is focused
    @Environment(\.dismiss) private var dismiss  // pop screen from stack of screens (go back a page)
    @State private var showDelAlert = false  // show confirmation alert for deletion
    
    var body: some View {
        VStack {
            // Fill Up Header Bar
            HStack {
                Spacer()
            }
            .padding(4)
            .background(getColour(manager.constants.colours.darkColour))
            .shadow(radius: 20)
            
            // screen body
            ScrollView {
                VStack {
                    // Title
                    HStack {
                        Text("View/Edit Alert")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.top)
                        Spacer()
                        Button(action: {showDelAlert = true}, label: {Image(systemName: "trash")})
                            .alert("Delete alert", isPresented: $showDelAlert) {
                                Button("Cancel", role: .cancel) {}
                                Button("Delete", role: .destructive) {delAlert(id)}
                            }
                            .foregroundColor(getColour(manager.constants.colours.buttonFill))
                            .imageScale(.large)
                    }
                    
                    // widgets
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        HStack {Text("Medication Name")
                            TextField("Alert title...", text: $name)
                                .focused($focusedField, equals: .name)
                                .onChange(of: name) {
                                    name = limitText(upper: 20, str: name)
                                }
                        }}
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        HStack {Text("Day:  \(day)")
                            Spacer()
                        }}
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        HStack {Text("Time")
                            DatePicker("", selection: $time,
                                       displayedComponents: .hourAndMinute)
                        }}
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        HStack {
                            Text("Backup Time")
                            DatePicker("", selection: $backupTime, displayedComponents: .hourAndMinute)
                        }}
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        VStack {
                            HStack {
                                Text("Notes")
                                Spacer()
                            }
                            TextField("Notes...", text: $notes, axis: .vertical)
                                .focused($focusedField, equals: .notes)
                                .lineLimit(8, reservesSpace: true)
                                .onChange(of: notes) {
                                    notes = limitText(upper: 400, str: notes)
                                }
                        }
                    }
                    
                    // form buttons
                    HStack {
                        Button(action: {dismiss()}, label: {Text("Cancel")})
                        Spacer()
                        widgetBox(manager: manager,
                                  borderColor: getColour(manager.constants.colours.lightOutline)) {Button(action: {updateAlert()}, label: {Text("Save Changes")})}
                            .frame(width: 150, height: 30)
                    }
                    .padding(.vertical)
                    .foregroundStyle(getColour(manager.constants.colours.buttonFill))
                }
                .padding(.horizontal)
            }
            .scrollContentBackground(.hidden)  // hide grey form background colour
            .textFieldStyle(.roundedBorder)
            .toolbar {
                // KEYBOARD ITEMS
                // push to right
                ToolbarItem(placement: .keyboard) {
                    Spacer()
                }
                // close keyboard button
                ToolbarItem(placement: .keyboard) {
                    Button {focusedField = nil}
                label: {Image(systemName: "keyboard.chevron.compact.down")}
                }
                
                // SCREEN HEADER ITEMS
                ToolbarItem(placement: .navigationBarTrailing) {
                    helpButton(manager: manager, screen: "update_alert")
                }
            }
        }
        .navigationTitle("Medication Alert")  // title for screen
        .background(getColour(manager.constants.colours.lightColour))
        .foregroundColor(getColour(manager.constants.colours.textColor))
    }
        
    // MARK: update alert
    private func updateAlert() {
        // provide updated alert data to manager
        manager.updateAlert(id: id, name: name, day: day, time: time, backupTime: backupTime, notes: notes)
        // return to timetable screen
        dismiss()
    }
    
    // MARK: del alert
    private func delAlert(_ id: Int) {
        // provide id to be deleted to manager
        manager.delAlert(id)
        // return to timetable screen
        dismiss()
    }
}


// MARK: ------ STRUCTS ------



// MARK: -- ALERT TAB --
struct AlertTab<Content: View, Destination: View>: View {
    let manager: IllnessManagerViewModel
    @ViewBuilder let content: Content
    
    let destination: Destination
    var body: some View {
        NavigationLink(
            destination: destination,
            label: {
                ZStack {
                    RoundedRectangle(cornerRadius: manager.constants.widget.cornerRadius)
                        .foregroundColor(getColour(manager.constants.colours.colouredTabBG))
                    
                    RoundedRectangle(cornerRadius: manager.constants.widget.cornerRadius)
                        .strokeBorder(lineWidth: manager.constants.widget.lineWidth)
                        .foregroundColor(getColour(manager.constants.colours.colouredTabBorder))
                        .shadow(radius: manager.constants.widget.shadowRadius)
                    
                    content
                        .padding(3)
                        .foregroundColor(getColour(manager.constants.colours.textColor))
                }
        })
    }
}

#Preview {
    MedicationTimetable(IllnessManagerViewModel())
}
