//
//  GeneralStructs.swift
//  Chronic Illness Manager | Andrew Towell 12 Major
//
//  Created by Andrew Towell on 16/3/2024.
//

import SwiftUI

// MARK: -- NAV BUTTON --
// creates a navigation link with a given icon and destination view
struct navButton<Destination: View>: View {
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

// MARK: -- WIDGET BOX --
struct widgetBox<Content: View>: View {
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


//#Preview {
//    GeneralStructs()
//}
