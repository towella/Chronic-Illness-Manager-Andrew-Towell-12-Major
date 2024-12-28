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
            }.background(getColour(manager.constants.colours.darkColour))
        }
    }
    
    private var scrollBody: some View {
        // Scrollable section
        ScrollView {
            VStack{
                HStack {
                    Text("Today's Plan!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(getColour(manager.constants.colours.textColor))
                    Spacer()
                    // settings values must be passed into the Settings view as they can not be
                    // initialised to specific values within an init function without being overwritten by
                    // default values in the main constructor >:(
                    // MUST GET DATA FROM SETTINGS NOT CONSTANTS
                    navButton(manager: manager, icon: "gearshape")
                        {Settings(manager: manager,
                                  themeColor: getColour(manager.settings.theme),
                                  useNotifs: manager.settings.notifications,
                                  textColor: getColour(manager.settings.textColor),
                                  useWhiteIcons: manager.settings.whiteIcons)}
                    helpButton(manager: manager, screen: "main_menu")
                }
                
                dayPlanner
                
                // TODO: TEST ---------
                widgetBox(manager: manager,
                          borderColor: getColour(manager.constants.colours.lightOutline)) {
                    HStack {
                        Text("Notification example")
                        DatePicker("", selection: $time,
                                   displayedComponents: .hourAndMinute)
                    }
                }
                Button("Set notifcation") {
                    manager.setNotification(time: time, alertName: "Test")
                    print("notif set")
                }
                // --------------------
            }
            .padding(.horizontal)
        }
        .background(getColour(manager.constants.colours.mainColour))
        .foregroundColor(getColour(manager.constants.colours.textColor))
    }
    
    private var dayPlanner: some View {

        return ZStack {
            RoundedRectangle(cornerRadius: manager.constants.widget.cornerRadius)
                .foregroundColor(getColour(manager.constants.colours.lightColour))
            
            RoundedRectangle(cornerRadius: manager.constants.widget.cornerRadius)
                .strokeBorder(lineWidth: manager.constants.widget.lineWidth)
                .foregroundColor(getColour(manager.constants.colours.lightOutline))
                .shadow(radius: manager.constants.widget.shadowRadius)
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
            }.padding()
        }
    }
    
    private var controlBar: some View {
        // Bottom Buttons
        HStack {
            Spacer()
            navButton(manager: manager, icon: "folder") {MedicalRecords(manager)}
            Spacer()
            navButton(manager: manager, icon: "calendar") {Calendar(manager)}
            Spacer()
            navButton(manager: manager, icon: "plus.app") {AddLog(manager)}
            Spacer()
            navButton(manager: manager, icon: "list.bullet") {SymptomLogger(manager)}
            Spacer()
            navButton(manager: manager, icon: "pill") {MedicationTimetable(manager)}
            Spacer()
        }
        .background(getColour(manager.constants.colours.darkColour))
        .shadow(radius: 20)
    }
    
    
}

//Function to keep text length in limits
func limitText(upper: Int, str: String) -> String {
    var str = str
    if str.count > upper {
        str = String(str.prefix(upper))
    }
    return str
}

#Preview {
    // make in place since just preview. Would never do otherwise
    MainMenu(manager: IllnessManagerViewModel())
}
