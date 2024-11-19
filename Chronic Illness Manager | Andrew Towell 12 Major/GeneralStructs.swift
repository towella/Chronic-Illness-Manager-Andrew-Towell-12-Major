//
//  GeneralStructs.swift
//  Chronic Illness Manager | Andrew Towell 12 Major
//
//  Created by Andrew Towell on 16/3/2024.
//

import SwiftUI
import PDFKit

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
    var borderColor = Constants.Colours().lightOutline  // var instead of let makes setting property optional when instantiating (defaults to set value if not passed)
    @ViewBuilder let content: Content
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.Widget().cornerRadius)
                .foregroundColor(Constants.Colours().lightBG)
            
            RoundedRectangle(cornerRadius: Constants.Widget().cornerRadius)
                .strokeBorder(lineWidth: Constants.Widget().lineWidth)
                .foregroundColor(borderColor)
                .shadow(radius: Constants.Widget().shadowRadius)
            
            // Box Content
            content
                .padding()
        }
    }
}


// MARK: -- HELP BUTTON --
struct helpButton: View {
    @State var showHelp: Bool = false
    let manager: IllnessManagerViewModel
    let screen: String
    var body: some View {
        Button(action: {showHelp = true}, label: {Image(systemName: "questionmark.circle")})
            .tint(.black)
            .alert(manager.getHelp(screen), isPresented: $showHelp) {Button("Ok", role: .cancel) {}}
    }
}


// MARK: -- CHECKBOX --
// https://www.kodeco.com/books/swiftui-cookbook/v1.0/chapters/2-create-a-checkbox-in-swiftui
struct CheckboxToggleStyle: ToggleStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    HStack {
      configuration.label
      Spacer()
      Image(systemName: configuration.isOn ? "checkmark.square" : "square")
        .resizable()
        .frame(width: 24, height: 24)
        .onTapGesture { configuration.isOn.toggle() }
    }
  }
}


// MARK: -- PDF --
extension PDFDocument: Transferable {
    // access title property easier than using metadata
    // https://www.simanerush.com/posts/sharing-files
    public var title: String? {
    guard let attributes = self.documentAttributes,
          let titleAttribute = attributes[PDFDocumentAttribute.titleAttribute]
    else { return nil }

    return titleAttribute as? String
    }
    
    // make compatible with ShareLink
    // https://stackoverflow.com/questions/77136993/swiftui-how-to-properly-use-sharelink-to-share-a-multipage-pdf-that-was-genera
    public static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(exportedContentType: .pdf) { pdf in
                return pdf.dataRepresentation() ?? Data()
            }
        }
}
