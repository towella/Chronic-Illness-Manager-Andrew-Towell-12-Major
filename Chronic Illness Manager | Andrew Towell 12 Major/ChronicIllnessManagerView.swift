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
    }
    
    
    // MARK: -- MAIN MENU --
    var body: some View {
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
                navButton(icon: "gearshape", destination: AnyView(settings))
            }
            .padding(.horizontal)
            
            dayPlanner
        }
        .background(Constants.Colours().lightPurple)
    }
    
    private var dayPlanner: some View {
        let cornerRadius: CGFloat = 12
        let lineWidth: CGFloat = 2
        let shadowRadius: CGFloat = 15
        
        return ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(Constants.Colours().lightBG)
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(lineWidth: lineWidth)
                .foregroundColor(Constants.Colours().lightOutline)
                .shadow(radius: shadowRadius)
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
            navButton(icon: "folder", destination: AnyView(files))
            Spacer()
            navButton(icon: "calendar", destination: AnyView(calendar))
            Spacer()
            navButton(icon: "plus.app", destination: AnyView(addLog))
            Spacer()
            navButton(icon: "list.bullet", destination: AnyView(logHistory))
            Spacer()
            navButton(icon: "pill", destination: AnyView(medicationTimetable))
            Spacer()
        }
        .background(Constants.Colours().darkPurple)
        .shadow(radius: 20)
    }
    
    
    // MARK: -- OTHER SCREENS --
    
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
            }
            
            Spacer() // take up all space
        }
            .navigationTitle("Medication Timetable")  // title for screen
            .background(Constants.Colours().lightPurple)
    }
    
    
    // MARK: -- STRUCTS --
    
    // creates a navigation link with a given icon and destination view
    private struct navButton: View {
        var icon: String  // icon for button
        var destination: AnyView  // provide a destination view to open
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
    
}






#Preview {
    // make in place since just preview. Would never do otherwise
    ChronicIllnessManagerView(manager: IllnessManagerViewModel())
}
