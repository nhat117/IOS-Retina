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
//Chip for display tags
import SwiftUI
struct Chips: View {
    let titleKey: String //text or localisation value
    
    var body: some View {
        HStack {
            Text(titleKey).font(.title3).lineLimit(1)
        }.padding(.all, 10)
            .foregroundColor(.white)
            .background(Color("Primary")) //different UI for selected and not selected view
            .cornerRadius(40)  //rounded Corner
    }
}

struct Chips_Previews: PreviewProvider {
    static var previews: some View {
        Chips(titleKey: "Microwave")
    }
}
