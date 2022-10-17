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

struct BasketItemCard: View {
    @ObservedObject var dataManager: DataManager = DataManager.commonDataManager
    @Binding var selectedItem: Item
    @Binding var selectedVendor: User
    @Binding var isReturnModalShown: Bool
    var item = Item(name: "Upholstered Lounge Chair Zuiver", vendor: "Lazy Sack", description: "Stay light-years ahead of the competition with our Aim Analog Watch. ", pricePerDay: 10.0, itemImage: ["http://eimages.valtim.com/acme-images/product/m/g/mg03-br-0.jpg"])
    let size: CGFloat
    
    var body: some View {
        HStack(spacing: 10) {
            KFImage( URL(string:item.itemImage[0]))
                .centerCropped()
                .frame(width: size/1.2, height: size/1.2)
                .cornerRadius(CGFloat(ColorElement.ColorModifier.smallRadius))
                .padding(.leading, 5)
                .padding()
            VStack(alignment: .leading, spacing: 7) {
                Text(item.name)
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, maxHeight: size/2.5, alignment: .leading)
                HStack (spacing: 10) {
                    //TODO: Implement Logic for the card view
                    Text(item.category)
                        .foregroundColor(.black.opacity(0.6))
                        .font(.caption)
                        .frame(alignment: .leading)
                    Text("$\(item.pricePerDay, specifier: "%.2f")")
                        .fontWeight(.bold)
                }
            }
            
            Button {
                // TODO: return
                isReturnModalShown.toggle()
                selectedItem = item
                dataManager.getVendorByEmail(email: item.vendor)
            } label: {
                Image(systemName: "arrow.uturn.left.circle.fill")
                    .resizable()
                    .frame(width: size / 3, height: size / 3)
                    .padding(.horizontal)
                    .foregroundColor(Color("PrimaryColor"))
            }
            //            PrimaryButton(title: "Return", fore: Color(.white), back: Color(.black)).padding(.horizontal, 10).padding(.bottom, 10)
            //                .frame(width: size / 3)
        }
        //.padding(30)
        //.frame(maxWidth: .infinity, maxHeight: size)
        .foregroundColor(.black)
        .background(Color.white)
        .mask(RoundedRectangle(cornerRadius: CGFloat(ColorElement.ColorModifier.mediumRadius), style: .continuous))
    }
}

//struct BasketItemCard_Previews: PreviewProvider {
//    static var previews: some View {
//        BasketItemCard(selectedItem: $selectedItem, size: 100)
//    }
//}
