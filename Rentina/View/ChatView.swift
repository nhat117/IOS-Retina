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

struct ChatView: View {
    //    @Binding var currentView: ScreenView
    @ObservedObject var avtFetcher = AvatarFetcher.avtFetcher
    @StateObject var messagesManager = MessagesManager()
    @ObservedObject var dataManager: DataManager = DataManager.commonDataManager
    @State var vendor: String
    @State var profileImageURL: String = ""
    @State var vendorName: String = ""
    
    var body: some View {
        VStack {
            VStack {
                TitleRow(vendorName: $vendorName, imageUrl: $profileImageURL).onAppear(perform: {
                    if !dataManager.user.chat.contains(vendor) && vendor != ""{
                        dataManager.user.chat.append(vendor)
                        dataManager.updateUser(user: dataManager.user)
                        if !dataManager.currentVendor.chat.contains(dataManager.user.email) {
                            dataManager.currentVendor.chat.append(dataManager.user.email)
                            dataManager.updateUser(user: dataManager.currentVendor)
                            avtFetcher.getUserByEmail(email: vendor)
                            vendorName = avtFetcher.user.name
                            profileImageURL = avtFetcher.user.avatarImage
                            
                        }
                    }
                    if let unwrapped = dataManager.user.id {
                        messagesManager.getMessagesFrom(fromId: unwrapped, toId: vendor)
                        messagesManager.getMessagesTo(fromId: vendor, toId: unwrapped)
                    } else {
                        print("Missing name.")
                    }
                    
                })
                
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(messagesManager.messages, id: \.id) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding(.top, 10)
                    .background(.white)
                    .cornerRadius(30, corners: [.topLeft, .topRight]) // Custom cornerRadius modifier added in Extensions file
                    .onChange(of: messagesManager.lastMessageId) { id in
                        // When the lastMessageId changes, scroll to the bottom of the conversation
                        withAnimation {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                }
            }
            .onAppear{
                DispatchQueue.global(qos: .userInitiated).async {
                    avtFetcher.getUserByEmail(email: vendor)
                }
                
                
            }
            .background(Color("PrimaryColor"))
            
            MessageField()
                .environmentObject(messagesManager)
        }
    }
}

