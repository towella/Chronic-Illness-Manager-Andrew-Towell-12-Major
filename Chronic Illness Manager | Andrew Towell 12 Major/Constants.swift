//
//  Constants.swift
//  Chronic Illness Manager | Andrew Towell 12 Major
//
//  Created by Andrew Towell on 16/3/2024.
//

import SwiftUI

// MARK: -- CONSTANTS --
struct Constants {
    
    // MARK: Colours
    struct Colours {
        let lightPurple = Color(red: 231/255, green: 205/255, blue: 253/255)
        let darkPurple = Color(red: 164/255, green: 139/255, blue: 211/255)
        let lightBG = Color(red: 248/255, green: 237/255, blue: 250/255)
        let buttonFill = Color(red: 0, green: 0, blue: 0)
        let lightOutline = Color(red: 119/255, green: 119/255, blue: 119/255)
        let colouredTab = Color(red: 176/255, green: 232/255, blue: 178/255)
        let colouredTabBorder = Color(red: 213/255, green: 213/255, blue: 213/255)
    }
    
    // MARK: Widget
    struct Widget {
        let cornerRadius: CGFloat = 12
        let lineWidth: CGFloat = 2
        let shadowRadius: CGFloat = 15
    }
}
