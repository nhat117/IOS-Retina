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

struct MessageBubble: View {
    var message: Message
    @ObservedObject var dataManager: DataManager = DataManager.commonDataManager
    @State private var showTime = false
    
    var body: some View {
        VStack(alignment: message.toId == dataManager.user.email ? .leading : .trailing) {
            HStack {
                Text(message.text)
                    .padding()
                    .background(message.toId == dataManager.user.email ? Color("Gray") : Color("Peach"))
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment: message.toId == dataManager.user.email ? .leading : .trailing)
            .onTapGesture {
                showTime.toggle()
            }
            
            if showTime {
                Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(message.toId == dataManager.user.email ? .leading : .trailing, 25)
            }
        }
        .frame(maxWidth: .infinity, alignment: message.toId == dataManager.user.email ? .leading : .trailing)
        .padding(message.toId == dataManager.user.email ? .leading : .trailing)
        .padding(.horizontal, 10)
    }
}

//struct MessageBubble_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageBubble(message: Message(id: "12345", text: "I've been coding applications from scratch in SwiftUI and it's so much fun!", received: true, timestamp: Date()))
//    }
//}
