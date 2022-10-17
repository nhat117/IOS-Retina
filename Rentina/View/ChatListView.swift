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
import Kingfisher

struct ChatListView: View {
    @ObservedObject var dataManager: DataManager = DataManager.commonDataManager
    @Binding var currentView: ScreenView
    let viewName = "chat"
    var body: some View {
        VStack(spacing: 0) {
            AppBar(title: "Conversations")
            Chats(chatList: dataManager.user.chat)
        }
    }
}

struct AppBar: View {
    var title: String
    var body: some View{
        VStack(spacing: 25){
            HStack{
                Text(title)
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(.white)
                Spacer(minLength: 0)
                Spacer(minLength: 0)
                
            }
        }
        .frame(minHeight: 50)
        .padding(.horizontal)
        .background(Color("PrimaryColor"))
    }
}

struct Chats: View {
    
    var chatList: [String]
    @ObservedObject var dataManager: DataManager = DataManager.commonDataManager
    @ObservedObject var avtFetcher: AvatarFetcher = AvatarFetcher.avtFetcher
    @State private var isTap: Bool = false
    var body: some View {
        if chatList.count > 0 {
            List{
                ForEach(chatList, id: \.self) { chat in
                    NavigationLink {
                        ChatView(vendor: chat)
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true).onAppear() {
                                dataManager.getVendorByEmail(email: chat)
                                DispatchQueue.global(qos: .userInitiated).async {
                                    avtFetcher.getUserByEmail(email: chat)
                                }
                                
                            }
                        
                    } label: {
                        CellView(name: chat, imgName: "Profile").onAppear{
                            dataManager.getVendorByEmail(email: chat)
                        }
                    }
                }
            }
        } else {
            Text("No conversations")
                .font(.title3)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

//MARK: Chat cell
struct CellView: View {
    var name: String
    var imgName: String
    var id : UUID = UUID()
    var body: some View {
        HStack{
            KFImage(URL(string: imgName))
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: 55, height: 55)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
            VStack(alignment: .center, spacing: 10){
                Text(name)
            }
        }
    }
}


