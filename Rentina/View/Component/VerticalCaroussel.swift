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

struct VerticalCaroussel: View {
    let categoryName: String
    let items: [Item]
    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryName)
                .font(.custom("PlayfairDisplay-Bold", size: 24))
                .padding(.horizontal)
            
            ScrollView (showsIndicators: false) {
                VStack (spacing: 10) {
                    ForEach(items) { item in
                        NavigationLink(destination: ItemDetailView(item: item)) {
                            HorizontalCard(itemName: item.name, itemImage: item.itemImage[0], itemDescription: item.category, itemPrice: item.pricePerDay, size: 100)
                        }
                        
                    }
                    .padding([.leading,.trailing])
                }
            }
            .padding(.bottom)
        }
    }
}
