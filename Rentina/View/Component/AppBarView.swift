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
 */


import SwiftUI

//MARK: Main navigation bar component
struct AppBarView: View {
    let isVendor: Bool
    let imageName: String
    let name: String
    let email: String
    
    @ObservedObject var dataManager: DataManager = DataManager.commonDataManager
    @Binding var whiteBtnTap: Bool
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            Spacer()
            Spacer()
            HStack (alignment: .center){
                Spacer()
                ProfileImage(imageName: imageName)
                Spacer()
            }.padding()
            HStack (alignment: .center){
                Spacer()
                Text(name)
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .fontWeight(.light)
                    .padding(.bottom, 15)
                Spacer()
            }
            
            if(isVendor) {
                NavigationLink {
                    ChatView(vendor: email)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                } label: {
                    PrimaryButton(title: "Message", fore: Color(.white), back: Color(.black)).padding(.horizontal, 40)
                }
                
            } else {
                PrimaryButton(title: "Add Product", fore: Color(.black), back: Color(.white)).padding(.horizontal, 40).padding(.bottom, 10).onTapGesture {
                    whiteBtnTap.toggle()
                }
            }
            
            Spacer()
        }
    }
}
