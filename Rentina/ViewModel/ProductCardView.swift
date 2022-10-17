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
 */

import SwiftUI
import Kingfisher

struct ProductCardViewVertical: View {
    let image: String
    let name: String
    let price: Double
    let category: String
    let size: CGFloat
    
    var body: some View {
        VStack {
            KFImage(URL(string: image))
                .centerCropped()
                .frame(width: size, height: 200 * (size/210))
                .cornerRadius(20.0)
            Text(name)
            // .font(.title3).fontWeight(.bold).frame(maxWidth: .infinity, alignment: .leading)
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                HStack (spacing: 2) {
                    //TODO: Wire for star
                    ForEach(0 ..< 5) { item in
                        Image("star")
                    }
                    Spacer()
                    Text("$\(String(price))")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                
                HStack {
                    Text(category)
                        .font(.caption)
                        .foregroundColor(.black.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: size, height: size*1.5)
        .padding()
        .background(Color.white)
        .cornerRadius(20.0)
        
    }
}

