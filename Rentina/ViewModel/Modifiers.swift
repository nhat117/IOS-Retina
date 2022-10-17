/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 3
 Nguyen Dinh Dang Nguyen (s3759957) – Project Manager
 Bui Minh Nhat (s3878174) – Technology Leader
 Nguyen Thanh Luan (s3757937) – Member
 Nguyen Phuoc Nhu Phuc (s3819660) – Member
 Created  date: 03/09/2022
 Last modified: 17/09/2022
 Acknowledgement: Acknowledge the resources that you use here.
 Tom's Huynh Lecture
 https://github.com/onevcat/Kingfisher
 https://developer.apple.com/documentation/coreml
 https://arxiv.org/abs/1801.04381
 https://firebase.google.com/docs/ios/setup
 */

import SwiftUI
//Element Styling can be found here
struct PrimaryTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .font(.title3)
            .padding()
            .background(Color.white)
            .cornerRadius(3)
            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
            .border(Color.black, width: 2)
    }
}

struct TextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .padding()
            .background(.white)
            .cornerRadius(3)
            .shadow(color: .black.opacity(0.08), radius: 60, x: 0.0, y: 16)
            .border(.black, width: 2)
    }
}

class ColorElement {
    static let ColorModifier = ColorElement()
    private init(){}
    func background() -> some View {
        return Color(#colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1))
            .ignoresSafeArea()
    }
    let smallRadius = 5
    let mediumRadius = 20
}
