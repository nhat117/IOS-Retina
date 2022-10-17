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
 https://adnan-tech.com/pick-image-from-gallery-and-upload-to-server-swiftui-and-php/
 https://developer.apple.com/documentation/corelocation
 https://designcode.io/swiftui-advanced-handbook-imagepicker
 */

import SwiftUI

enum LoginScreenSwitcher: String, CaseIterable {
    case login
    case signUp
    case navBar
}
//Application Entry point
struct ContentView: View {
    @State private var currView: LoginScreenSwitcher = .login
    @State var isActive = false
    @ObservedObject var dataManager = DataManager.commonDataManager
    
    var body: some View {
        if !isActive {
            SplashView(isActive: $isActive) 
            
        } else{
            
            switch (currView) {
            case .login:
                
                LoginView(loginScreenSwitcher: $currView).onAppear() {
//                    dataManager.loadDummyData()
                }
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)) )
                
            case .signUp:
                SignUpView(loginScreenViewSwitcher: $currView)
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)) )
                
            default:
                NavigationBarView(loginScreenViewSwitcher: $currView).transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)) )
            }
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
