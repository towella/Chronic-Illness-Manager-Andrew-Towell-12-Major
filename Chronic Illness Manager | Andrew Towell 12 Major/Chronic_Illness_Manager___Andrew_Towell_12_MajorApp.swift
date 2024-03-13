//___FILEHEADER___

import SwiftUI

@main
struct Chronic_Illness_Manager___Andrew_Towell_12_MajorApp: App {
    @StateObject var manager = IllnessManagerViewModel()
    
    var body: some Scene {
        WindowGroup {
            ChronicIllnessManagerView(manager: manager)
        }
    }
}
