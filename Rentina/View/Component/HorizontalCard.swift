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

struct HorizontalCard: View {
    let itemName: String
    let itemImage: String
    let itemDescription: String
    let itemPrice: Double
    let size: CGFloat
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(itemName)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    //TODO: Implement Logic for the card view
                    HStack(spacing: 0) {
                        ForEach(0 ..< 5) { item in
                            Image("star")
                        }
                    }
                    
                    Text("$\(itemPrice,specifier: "%.2f")")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                HStack {
                    Text(itemDescription)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                
                
            }
            Divider()
            KFImage(URL(string: itemImage))
                .resizable()
                .centerCropped()
//                .scaledToFit()
                .frame(width: size/1.2, height: size/1.2)
                .cornerRadius(CGFloat(ColorElement.ColorModifier.smallRadius))
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: size)
        .foregroundColor(.black)
        .background(Color.white)
        .mask(RoundedRectangle(cornerRadius: CGFloat(ColorElement.ColorModifier.mediumRadius), style: .continuous))
    }
}

struct HorizontalCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.red)
            HorizontalCard(itemName: "Chair", itemImage: "chair_1", itemDescription: "Loren ipsum ", itemPrice: 219, size: 100)
        }
        
    }
}
