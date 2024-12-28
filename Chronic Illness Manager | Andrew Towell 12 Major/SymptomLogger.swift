//
//  LogHistory.swift
//  Chronic Illness Manager | Andrew Towell 12 Major
//
//  Created by Andrew Towell on 16/3/2024.
//

import SwiftUI
import PDFKit

// MARK: ----- SCREENS -----



// MARK: -- Log History --
struct SymptomLogger: View {
    // observed object (view model)
    @ObservedObject var manager: IllnessManagerViewModel
    // State variables (set default values)
    
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
                VStack {
                    HStack {
                        Text("Your Logs")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        navButton(manager: manager, icon: "square.and.arrow.up") {ExportLogs(manager)}
                    }
                    navButton(manager: manager, icon: "plus.app") {AddLog(manager)}
                    
                    // display each log as a clickable link to edit screen
                    ForEach(manager.logHistory.logs.indices, id: \.self) {log in
                        let logData = manager.logHistory.logs[log]
                        NavigationLink(
                            destination: UpdateLog(manager: manager,
                                                   id: logData.id,
                                                   date: logData.date,
                                                   title: logData.title,
                                                   symptomFields: logData.symptomFields,
                                                   notes: logData.notes),
                            label: {
                                widgetBox(manager: manager,
                                          borderColor: getColour(manager.constants.colours.lightOutline)) {
                                    VStack {
                                        HStack {
                                            Text("\(logData.title)")
                                                .multilineTextAlignment(.leading)
                                                .bold()
                                            Spacer()
                                        }
                                        HStack {
                                            Text("\(logData.date.formatted(date: .abbreviated, time: .omitted))")
                                                .multilineTextAlignment(.leading)
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    helpButton(manager: manager, screen: "symptom_logger")
                }
            }
            
            Spacer() // take up all space
        }
            .navigationTitle("Log History")  // title for screen
            .background(getColour(manager.constants.colours.mainColour))
            .foregroundColor(getColour(manager.constants.colours.textColor))
    }
}


// MARK: -- Add Log --
struct AddLog: View {
    // observed object (view model)
    @ObservedObject var manager: IllnessManagerViewModel
    
    enum FocusedField {
        case title, notes
    }
    @State var title: String = ""
    @State var date = Date()
    @State var notes: String = ""
    // one index for each slider field (max 20 slider fields)
    @State var sliderVals: [Double] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    @FocusState var focusedField: FocusedField?  // what input is focused
    @Environment(\.dismiss) var dismiss  // pop screen from stack of screens (go back a page)
    
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
            
            // screen body
            ScrollView {
                VStack {
                    // Title
                    HStack {
                        Text("New Log")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.top)
                        Spacer()
                    }
                    
                    // widgets
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        HStack {Text("Title")
                            TextField("Log title...", text: $title)
                                .focused($focusedField, equals: .title)
                                .onChange(of: title) {
                                    title = limitText(upper: 20, str: title)
                                }
                        }}
                    HStack {
                        widgetBox(manager: manager,
                                  borderColor: getColour(manager.constants.colours.lightOutline)) {
                            HStack {Text("Date: ")
                                Spacer()
                                Text(Date.now, format: .dateTime.day().month().year())
                            }
                        }
                    }
                    
                    // title and edit fields button
                    HStack {
                        Text("Symptoms")
                            .bold()
                        Spacer()
                        navButton(manager: manager, icon: "ellipsis") {UpdateSymptomFields(manager: manager,
                                                fieldNames: manager.logHistory.fieldNames)}
                        .imageScale(.small)
                    }
                    .padding(.top)
                    
                    // produces symptom field sliders for each name
                    ForEach(manager.logHistory.fieldNames.indices, id: \.self) {name in
                        widgetBox(manager: manager,
                                  borderColor: getColour(manager.constants.colours.lightOutline)) {
                            HStack {
                                Text(manager.logHistory.fieldNames[name])
                                Slider(
                                    value: $sliderVals[name],
                                    in: 0...10,
                                    step: 1)
                                .padding(.horizontal)
                                Text("\(Int(sliderVals[name]))")
                            }
                        }
                    }
                    navButton(manager: manager, icon: "plus.square.dashed") {AddSymptomField(manager: manager)}
                        .imageScale(.small)
                        .padding(.top, 1)
                    
                    Spacer()
                    
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        VStack {
                            HStack{
                                Text("Additional Information")
                                    .bold()
                                    .padding(.bottom)
                                Spacer()
                            }
                            HStack {
                            }
                            TextField("Additional info...", text: $notes, axis: .vertical)
                                .focused($focusedField, equals: .notes)
                                .lineLimit(8, reservesSpace: true)
                                .onChange(of: notes) {
                                    notes = limitText(upper: 400, str: notes)
                                }
                        }
                    }
                    .padding(.top)
                    
                    // form buttons
                    HStack {
                        Button(action: {dismiss()}, label: {Text("Cancel")})
                        Spacer()
                        widgetBox(manager: manager,
                                  borderColor: getColour(manager.constants.colours.lightOutline)) {Button(action: {createLog()}, label: {Text("Create")})}
                            .frame(width: 100, height: 30)
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
                
                // HEADER BAR ITEMS
                ToolbarItem(placement: .navigationBarTrailing) {
                    helpButton(manager: manager, screen: "add_log")
                }
            }
        }
        .navigationTitle("New Log")  // title for screen
        .background(getColour(manager.constants.colours.mainColour))
        .foregroundColor(getColour(manager.constants.colours.textColor))
    }
    
    // MARK: create log
    private func createLog() {
        // provide alert data to manager
        manager.createLog(title: title, date: date, sliderVals: sliderVals, notes: notes)
        // return to timetable screen
        dismiss()
    }
}


// MARK: -- Update Log --
struct UpdateLog: View {
    // observed object (view model)
    @ObservedObject var manager: IllnessManagerViewModel
    
    enum FocusedField {
        case title, notes
    }
    // state alert data variables
    var id: Int
    var date: Date
    @State var title: String
    @State var symptomFields: [ManagerModel.SymptomField]
    @State var notes: String
    @FocusState var focusedField: FocusedField?  // what input is focused
    @Environment(\.dismiss) private var dismiss  // pop screen from stack of screens (go back a page)
    @State private var showDelLog = false  // show confirmation alert for deletion
    
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
                        Text("View/Edit Log")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.top)
                        Spacer()
                        Button(action: {showDelLog = true}, label: {Image(systemName: "trash")})
                            .alert("Delete log", isPresented: $showDelLog) {
                                Button("Cancel", role: .cancel) {}
                                Button("Delete", role: .destructive) {delLog(id)}
                            }
                            .foregroundColor(getColour(manager.constants.colours.buttonFill))
                            .imageScale(.large)
                    }
                    
                    // widgets
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        HStack {Text("Title")
                            TextField("Log title...", text: $title)
                                .focused($focusedField, equals: .title)
                                .onChange(of: title) {
                                    title = limitText(upper: 20, str: title)
                                }
                        }
                        
                    }
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        HStack {Text("Date: ")
                            Spacer()
                            Text(date, format: .dateTime.day().month().year())
                        }
                    }
                    
                    HStack {
                        Text("Symptoms")
                            .bold()
                            .padding(.top)
                        Spacer()
                    }
                    // create slider fields based on log fields (not user's custom fields
                    // as they may have changed since log was made
                    ForEach(symptomFields.indices, id: \.self) {field in
                        widgetBox(manager: manager,
                                  borderColor: getColour(manager.constants.colours.lightOutline)) {
                            HStack {
                                Text(symptomFields[field].name)
                                Slider(
                                    value: $symptomFields[field].value,
                                    in: 0...10,
                                    step: 1)
                                .padding(.horizontal)
                                Text("\(Int(symptomFields[field].value))")
                            }
                        }
                    }
                    
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        VStack {
                            HStack {
                                Text("Additional Information")
                                    .bold()
                                    .padding(.bottom)
                                Spacer()
                            }
                            TextField("Additional info...", text: $notes, axis: .vertical)
                                .focused($focusedField, equals: .notes)
                                .lineLimit(8, reservesSpace: true)
                                .onChange(of: notes) {
                                    notes = limitText(upper: 400, str: notes)
                                }
                        }
                    }
                    .padding(.top)
                    
                    // buttons
                    HStack {
                        Button(action: {dismiss()}, label: {Text("Cancel")})
                        Spacer()
                        widgetBox(manager: manager,
                                  borderColor: getColour(manager.constants.colours.lightOutline)) {Button(action: {updateLog()}, label: {Text("Save Changes")})}
                            .frame(width: 150, height: 30)
                    }
                    .padding(.vertical)
                    .foregroundStyle(getColour(manager.constants.colours.buttonFill))
                }
                .padding(.horizontal)
            }
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
                
                // HEADER BAR ITEMS
                ToolbarItem(placement: .navigationBarTrailing) {
                    helpButton(manager: manager, screen: "update_log")
                }
            }
        }
        .navigationTitle("Medication Alert")  // title for screen
        .background(getColour(manager.constants.colours.mainColour))
        .foregroundColor(getColour(manager.constants.colours.textColor))
    }
    
    // MARK: update log
    private func updateLog() {
        // provide updated alert data to manager
        manager.updateLog(id: id, title: title, date: date, symptomFields: symptomFields, notes: notes)
        // return to timetable screen
        dismiss()
    }
    
    // MARK: del alert
    private func delLog(_ id: Int) {
        // provide id to be deleted to manager
        manager.delLog(id)
        // return to timetable screen
        dismiss()
    }
}


// MARK: -- Add Symptom Field --
struct AddSymptomField: View {
    @ObservedObject var manager: IllnessManagerViewModel
    
    enum FocusedField {
        case name
    }
    @State var name: String = ""
    @FocusState var focusedField: FocusedField?  // what input is focused
    @Environment(\.dismiss) private var dismiss  // pop screen from stack of screens (go back a page)
    
    var body: some View {
        VStack {
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
                        Text("Add Field")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.top)
                        Spacer()
                    }
                    
                    // input
                    HStack {
                        widgetBox(manager: manager,
                                  borderColor: getColour(manager.constants.colours.lightOutline)) {
                            Text("Field name: ")
                            TextField("Field name...", text: $name)
                                .focused($focusedField, equals: .name)
                                .onChange(of: name) {
                                    name = limitText(upper: 20, str: name)
                                }
                        }
                    }
                    
                    // cancel and confirm buttons
                    HStack {
                        Button(action: {dismiss()}, label: {Text("Cancel")})
                        Spacer()
                        widgetBox(manager: manager,
                                  borderColor: getColour(manager.constants.colours.lightOutline)) {Button(action: {addSymptomField()}, label: {Text("Add")})}
                            .frame(width: 100, height: 30)
                    }
                    .padding(.vertical)
                    .foregroundStyle(getColour(manager.constants.colours.buttonFill))
                }
                .padding(.horizontal)
            }
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
                
                // HEADER BAR ITEMS
                ToolbarItem(placement: .navigationBarTrailing) {
                    helpButton(manager: manager, screen: "add_symptom_field")
                }
            }
        }
        .navigationTitle("Add Field")  // title for screen
        .background(getColour(manager.constants.colours.mainColour))
        .foregroundColor(getColour(manager.constants.colours.textColor))
    }
    
    private func addSymptomField() {
        manager.addSymptomField(name)
        dismiss()
    }
}


// MARK: -- Update Symptom Field --
struct UpdateSymptomFields: View {
    // observed object (view model)
    @ObservedObject var manager: IllnessManagerViewModel
    
    enum FocusedField {
        case name
    }
    // state data variables
    @State var fieldNames: [String] = []
    @State private var showDelAlert = false  // show confirmation alert for deletion
    @State private var fieldToDel = 0
    @FocusState var focusedField: FocusedField?  // whether input is focused
    @Environment(\.dismiss) private var dismiss  // pop screen from stack of screens (go back a page)
    
    var body: some View {
        VStack {
            // Fill Up Header Bar
            HStack {
                Spacer()
            }
            .padding(4)
            .background(getColour(manager.constants.colours.darkColour))
            .shadow(radius: 20)
            
            ScrollView {
                VStack {
                    HStack {
                        Text("Your Symptom Fields")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.top)
                        Spacer()
                    }
                    
                    ForEach (fieldNames.indices, id: \.self) { name in
                        widgetBox(manager: manager,
                                  borderColor: getColour(manager.constants.colours.lightOutline)) {
                            HStack {
                                TextField("Field name...", text: $fieldNames[name])
                                    .focused($focusedField, equals: .name)
                                    .onChange(of: fieldNames[name]) {
                                        fieldNames[name] = limitText(upper: 20, str: fieldNames[name])
                                    }
                                
                                // delete a field
                                Button(action: {fieldToDel = name; showDelAlert = true},
                                       label: {Image(systemName: "clear")})
                                .alert("Delete field: " + fieldNames[fieldToDel],
                                       isPresented: $showDelAlert) {
                                    Button("Cancel", role: .cancel) {}
                                    Button("Delete", role: .destructive) {
                                        delField()}
                                }
                                       .foregroundColor(getColour(manager.constants.colours.buttonFill))
                            }
                        }
                    }
                    
                    // buttons
                    HStack {
                        Button(action: {dismiss()}, label: {Text("Cancel")})
                        Spacer()
                        widgetBox(manager: manager,
                                  borderColor: getColour(manager.constants.colours.lightOutline)) {Button(action: {updateFields()}, label: {Text("Save Changes")})}
                            .frame(width: 150, height: 30)
                    }
                    .padding(.vertical)
                    .foregroundStyle(getColour(manager.constants.colours.buttonFill))
                }
                .padding(.horizontal)
            }
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
                
                // HEADER BAR ITEMS
                ToolbarItem(placement: .navigationBarTrailing) {
                    helpButton(manager: manager, screen: "update_symptom_fields")
                }
            }
        }
        .navigationTitle("Symtpom Fields")  // title for screen
        .background(getColour(manager.constants.colours.mainColour))
        .foregroundColor(getColour(manager.constants.colours.textColor))
    }
    
    // save temporary state variable to actual manager
    private func updateFields() {
        manager.updateFields(fieldNames)
        dismiss()
    }
    
    // remove field name from temporary state variable
    private func delField() {
        fieldNames.remove(at: fieldToDel)
        fieldToDel = 0  // must be reset otherwise will error when final field deleted
    }
}


// MARK: -- Export Logs --
struct ExportLogs: View {
    // observed object (view model)
    @ObservedObject var manager: IllnessManagerViewModel
    
    // range defaults to just today
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @Environment(\.dismiss) private var dismiss  // pop screen from stack of screens (go back a page)
    
    init (_ m: IllnessManagerViewModel) {
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
            
            ScrollView {
                VStack {
                    // title
                    HStack {
                        Text("Export Logs")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.top)
                        Spacer()
                    }
                    
                    // date selecters
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        HStack {
                            Text("Range start date ")
                            DatePicker("", selection: $startDate,
                                       in: ...endDate,
                                       displayedComponents: .date)
                        }
                    }
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        HStack {
                            Text("Range end date ")
                            DatePicker("", selection: $endDate,
                                       in: ...Date(),
                                       displayedComponents: .date)
                        }
                    }
                    
                    // confirm/cancel buttons
                    HStack {
                        Button(action: {dismiss()}, label: {Text("Cancel")})
                        Spacer()
                        widgetBox(manager: manager,
                                  borderColor: getColour(manager.constants.colours.lightOutline)) {
                            NavigationLink(destination: {DisplayExportPDF(manager: manager, data: exportLogs())},
                                           label: {Text("Export")})}
                            .frame(width: 100, height: 30)
                    }
                    .padding(.vertical)
                    .foregroundStyle(getColour(manager.constants.colours.buttonFill))
                }
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    helpButton(manager: manager, screen: "export_logs")
                }
            }
        }
        .navigationTitle("Export Logs")  // title for screen
        .background(getColour(manager.constants.colours.mainColour))
        .foregroundColor(getColour(manager.constants.colours.textColor))
    }
    
    // provides pdf document to view to be displayed
    private func exportLogs() -> PDFDocument {
        let pdfData = manager.exportLogs(startRange: startDate, endRange: endDate)
        return pdfData
    }
}


// MARK: -- Display Export PDF --
// struct for displaying a pdf document
struct PDFKitView: UIViewRepresentable {
    let data: PDFDocument
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = self.data
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        // Update the view if needed (If you change the pdf)
    }
}

// view for displaying a pdf document (using PDFKitView)
struct DisplayExportPDF: View {
    let manager: IllnessManagerViewModel
    let data: PDFDocument
    
    var body: some View {
        PDFKitView(data: data)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: data, preview: SharePreview(data.title!))
            }
        }
    }
}


#Preview {
    SymptomLogger(IllnessManagerViewModel())
}
