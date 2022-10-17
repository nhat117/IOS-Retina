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

struct CreditView: View {
    let viewName = "setting"
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ZStack (alignment: .top){
            ColorElement.ColorModifier.background()
            VStack(spacing: 20) {
                VStack{
                    Image("onboard")
                        .resizable()
                        .scaledToFit()
                }
                .padding([.horizontal],50)
                .padding(.vertical)
                
                VStack(spacing: 5){
                    
                    HStack {
                        VStack(alignment: .leading ){
                            Text("Ownership")
                                .bold()
                        }
                        Spacer()
                        VStack(alignment: .leading ){
                            
                            Text("RMIT Vietnam")
                        }
                    }
                    HStack {
                        VStack(alignment: .leading ){
                            
                            Text("Course")
                                .bold()
                        }
                        Spacer()
                        VStack(alignment: .leading ){
                            
                            Text("COSC2659 - IOS Development")
                        }
                    }
                    HStack {
                        VStack(alignment: .leading ){
                            
                            Text("Project")
                                .bold()
                        }
                        Spacer()
                        VStack(alignment: .leading ){
                            
                            Text("Rentina")
                        }
                    }
                    
                    HStack {
                        VStack(alignment: .leading ){
                            
                            Text("Course Coordinator")
                                .bold()
                        }
                        Spacer()
                        VStack(alignment: .leading ){
                            
                            Text("Tom Huynh")
                        }
                    }
                }
                .padding(.horizontal)
                VStack(spacing: 5){
                    Text("Team Members").bold()
                    HStack {
                        VStack(alignment: .leading, spacing: 3 ){
                            
                            Text("Project Manager")
                            Text("Technical Leader")
                            Text("Member")
                            Text("Member")
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 3){
                            
                            Text("Nguyễn Đình Đăng Nguyên")
                            Text("Bùi Minh Nhật")
                            Text("Nguyễn Thành Luân")
                            Text("Nguyễn Phước Như Phúc")
                        }
                    }.font(.callout).padding(.horizontal,30)
                }
                VStack(spacing: 5){
                    Text("Disclaimer").bold()
                    Text("Copyright © 2022 Apple Inc. All rights reserved.\n\nApple, the Apple logo, Apple TV, iPad, iPhone, iPod touch, iTunes, and Mac are trademarks of Apple Inc., registered in the U.S. and other countries and regions.\nApple\nOne Apple Park Way\nCupertino, CA 95014").font(.caption.bold())
                }.padding(.horizontal,30)
            }
        }
        .makeNavigationPrettier(viewName: "", mode: mode)
    }
}

struct CreditView_Previews: PreviewProvider {
    static var previews: some View {
        CreditView()
    }
}
