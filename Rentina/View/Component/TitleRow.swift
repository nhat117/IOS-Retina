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
import Kingfisher

struct TitleRow: View {
    @ObservedObject var avtFetcher = AvatarFetcher.avtFetcher
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Binding var vendorName: String
    @Binding var imageUrl : String
    
    
    var body: some View {
        HStack(spacing: 20) {
            Button {mode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.gray)
                    .padding(10)
                    .background(.white)
                    .cornerRadius(50)
                
            }
            
            VStack(alignment: .trailing) {
                Text(vendorName)
                    .font(.title).bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            KFImage(URL(string: imageUrl))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .cornerRadius(50)
            
            
        }
        .onAppear() {
            vendorName = avtFetcher.user.name
            imageUrl = avtFetcher.user.avatarImage
        }
        .padding()
    }
}
