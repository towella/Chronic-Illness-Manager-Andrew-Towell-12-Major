//
//  Settings.swift
//  Chronic Illness Manager | Andrew Towell 12 Major
//
//  Created by Andrew Towell on 16/3/2024.
//

import SwiftUI

// MARK: -- SETTINGS --
struct Settings: View {
    // observed object (view model)
    @ObservedObject var manager: IllnessManagerViewModel
    // State variables (values are passed in as they can not be dynamically set in an init function
    // without being overridden by the default values set here???)
    @State var themeColor: Color
    @State var useNotifs: Bool
    @State var textColor: Color
    @State var useWhiteIcons: Bool
    @State private var showReset = false  // show confirmation alert for resetting settings
    @Environment(\.self) var environment  // required for getting rgb of colours within user's lighting environment
    @Environment(\.dismiss) var dismiss  // pop screen from stack of screens (go back a page)
    
    
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
                
                // MARK: General
                HStack {
                    Text("General")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.top)
                    Spacer()
                }
                
                HStack {
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        ColorPicker("Theme", selection: $themeColor)
                    }
                    .frame(width:170)
                    Spacer()
                }
                HStack {
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        Toggle(isOn: $useNotifs) {
                            Text("Notifications: ")
                        }
                        .toggleStyle(CheckboxToggleStyle(manager: manager))
                    }
                    .frame(width:170)
                    Spacer()
                }
                
                
                // MARK: Accessibility
                HStack {
                    Text("Accessibility")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.top)
                    Spacer()
                }
                
                HStack {
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        ColorPicker("Text Color", selection: $textColor)
                    }
                    .frame(width:170)
                    Spacer()
                }
                HStack {
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        HStack {
                            Toggle(isOn: $useWhiteIcons) {
                                Text("White Icons: ")
                            }
                            .toggleStyle(CheckboxToggleStyle(manager: manager))
                        }
                    }
                    .frame(width:170)
                    Spacer()
                }
                
                // MARK: Danger Zone
                HStack {
                    Text("Danger Zone")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.top)
                        .foregroundStyle(.red)
                    Spacer()
                }
                VStack {
                    HStack {
                        widgetBox(manager: manager,
                                  borderColor: getColour(manager.constants.colours.danger)) {
                            Button(action: {showReset = true},
                                   label: {Text("Reset to defaults")})
                            .alert("Reset to default", isPresented: $showReset) {
                                Button("Cancel", role: .cancel) {}
                                Button("Confirm", role: .destructive) {resetSettings()}
                            }
                        }
                        .foregroundColor(.red)
                        .frame(width: 170, height: 30)
                        .padding([.leading], 8)
                        .padding([.top, .bottom], 22)
                        Spacer()
                    }
                }
                .border(.red)
                
                // MARK: Bottom Buttons
                HStack {
                    Button(action: {dismiss()}, label: {Text("Cancel")})
                    Spacer()
                    widgetBox(manager: manager,
                              borderColor: getColour(manager.constants.colours.lightOutline)) {
                        Button(action: {saveSettings()},
                               label: {Text("Save Settings")})
                    }
                    .frame(width: 150, height: 30)
                }
                .padding(.vertical)
                .foregroundStyle(getColour(manager.constants.colours.buttonFill))
            }
            .padding(.horizontal)
            
            
            Spacer() // take up all space
        }
        .navigationTitle("Settings")  // title for screen
        .background(getColour(manager.constants.colours.mainColour))
        .foregroundColor(getColour(manager.constants.colours.textColor))
    }
    
    private func saveSettings() {
        print("Save settings")
        // resolve gets rgb values for each colour (can't store in private state variable as it would need to be initialized by caller which is messy and doesn't
        // make sense). Better to just find rgb of colours inline on save although not ideal)
        manager.saveSettings(theme: [Double(themeColor.resolve(in: environment).red),
                                     Double(themeColor.resolve(in: environment).green),
                                     Double(themeColor.resolve(in: environment).blue)],
                             notifications: useNotifs,
                             textColor: [Double(textColor.resolve(in: environment).red), 
                                         Double(textColor.resolve(in: environment).green),
                                         Double(textColor.resolve(in: environment).blue)],
                             whiteIcons: useWhiteIcons)
        dismiss()  // send back to home screen
    }
    
    private func resetSettings() {
        manager.resetSettings()
        let defaults = manager.getDefaultSettings()
        var color = defaults.theme
        print(color)
        themeColor = Color(red:   color[0],
                           green: color[1],
                           blue:  color[2])
        useNotifs = defaults.notifications
        color = defaults.textColor
        textColor = Color(red:   color[0],
                          green: color[1],
                          blue:  color[2])
        useWhiteIcons = defaults.whiteIcons
    }
    
}


//#Preview {
//    Settings(IllnessManagerViewModel())
//}
