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

struct SplashView: View {
    @Binding var isActive : Bool
    @State private var opacity = 0.5
    
    var body: some View {
        ZStack{
            Color("PrimaryColor").ignoresSafeArea()
            ZStack {
                Image("Splash Screen")
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                    .padding(.horizontal,UIScreen.screenWidth*0.1)
            }.opacity( opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 0.4)){
                        self.opacity = 1.0
                    }
                }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                withAnimation(.easeInOut(duration: 1)){
                    self.isActive = true
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(isActive: .constant(true))
    }
}
