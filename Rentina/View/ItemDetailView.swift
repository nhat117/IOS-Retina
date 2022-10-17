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

struct ItemDetailView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @ObservedObject var dataManager: DataManager = DataManager.commonDataManager
    @State var imageIndex = 0
    @State private var forwards = false
    @State private var isRentModalShown = false
    @State private var isReturnModalShown = false
    var item = Item(name: "Upholstered Lounge Chair Zuiver", vendor: "Lazy Sack", description: "Stay light-years ahead of the competition with our Aim Analog Watch. The flexible, rubberized strap is contoured to conform to the shape of your wrist for a comfortable all-day fit. The face features three illuminated hands, a digital read-out of the current time, and stopwatch functions.", pricePerDay: 10.0, itemImage: ["http://eimages.valtim.com/acme-images/product/m/g/mg03-br-0.jpg"])
    let viewName = "home"
    let len: Int = 4
    
    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        ZStack{
            ColorElement.ColorModifier.background()
            
            ScrollView {
                VStack {
                    // Image slide
                    GalleryView(images: item.itemImage, w: UIScreen.screenWidth, h: UIScreen.screenHeight, imageIndex: $imageIndex, forwards: $forwards)
                    
                    // Item detail
                    VStack{
                        Text(item.name)
                            .font(.title2)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 3)
                        
                        Text("$\(String(format: "%.2f", item.pricePerDay))/day")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 3)
                        
                        if (item.vendor == dataManager.user.email) {
                            EmptyView()
                            
                        } else if (dataManager.user.itemInRent.contains(item.id)) {
                            // if item is borrowed by current user => Return
                            Button {
                                isReturnModalShown.toggle()
                            } label: {
                                PrimaryButton(title: "Return", fore: Color(.white), back: Color(.black))
                            }
                        } else if (item.lendingInfo?.lendDate == nil) {
                            // if item is available
                            Button {
                                isRentModalShown.toggle()
                            } label: {
                                PrimaryButton(title: "Rent", fore: Color(.white), back: Color(.black))
                            }
                        } else {
                            // else: item is borrowed by other users
                            PrimaryButton(title: "Rent", fore: Color(.white), back: Color(.gray))
                        }
                        
                        // Item status
                        HStack {
                            Text("Status:").font(.title3)
                            Text(item.lendingInfo == nil ? "Available" : "Unavailable")
                                .foregroundColor(item.lendingInfo == nil ? Color.green : Color(red: 0.62, green: 0.3, blue: 0.3))
                            
                            Spacer()
                        }.padding(.bottom)
                        
                        // Description
                        
                        Text("Description:")
                            .font(.title3).fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(item.description)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom)
                        
                        
                        Text("Tags:")
                            .font(.title3).fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ZStack(alignment: .topLeading){
                            ForEach(item.itemTag, id: \.self) { name in
                                if(name != "") {
                                    Chips(titleKey: name )
                                        .padding([.horizontal, .vertical], 4)
                                        .  alignmentGuide(.leading) { dimension in
                                            if (abs(width - dimension.width) > UIScreen.screenWidth) {
                                                width = 0
                                                height -= dimension.height
                                            }
                                            
                                            let result = width
                                            if name == item.itemTag.last! {
                                                width = 0
                                            } else {
                                                width -= dimension.width
                                            }
                                            return result
                                        }
                                        .alignmentGuide(.top, computeValue: {d in
                                            let result = height
                                            if name == item.itemTag.last! {
                                                height = 0 // last item
                                            }
                                            return result
                                        })
                                }
                            }
                        }
                        
                        // MARK: Store info
                        if (dataManager.user.name != dataManager.currentVendor.name) {
                            NavigationLink(destination: VendorView(vendorEmail: item.vendor)) {
                                HStack{
                                    if(!dataManager.currentVendor.avatarImage.isEmpty){
                                        KFImage( URL(string: dataManager.currentVendor.avatarImage))
                                            .centerCropped()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color(.white),lineWidth: 2))
                                        
                                    }
                                    VStack{
                                        Text("\(dataManager.currentVendor.name)")
                                            .font(.title).bold()
                                            .foregroundColor(Color(red: 0.62, green: 0.3, blue: 0.3))
                                        Text("\(dataManager.getDistance(),specifier: "%.2f")km")
                                            .font(.callout.bold())
                                    }
                                    .frame(maxWidth:.infinity)
                                    
                                }
                                .frame(maxWidth:.infinity )
                                .padding()
                                .cornerRadius(20)
                                .border(.primary,width: 2)
                                .foregroundColor(.black)
                                .background(.white)
                            }
                        }
                        
                        
                        
                    }
                    .padding(UIScreen.screenHeight / 50)
                    
                    Spacer()
                }
            }
            
            //MARK: Rent Modal
            if isRentModalShown {
                Color.black.opacity(0.6)
                let distance = dataManager.getDistance()
                VStack {
                    Text("Confirm Rental Order")
                        .font(.title2)
                        .bold()
                    HStack {
                        KFImage(URL(string:item.itemImage[0]))
                            .resizable()
                            .frame(width: UIScreen.screenWidth / 5, height: UIScreen.screenHeight / 10)
                        
                        VStack {
                            Text(item.name)
                                .font(.callout)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(dataManager.currentVendor.name)
                                .font(.caption)
                                .foregroundColor(.black.opacity(0.6))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("$\(item.pricePerDay, specifier: "%.2f")/day")
                                .font(.callout).bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 0.1)
                            
                        }
                    }
                    
                    if(dataManager.user.balance > Float(item.pricePerDay)) {
                        if (distance != 0 && distance < 1000) {
                            Text("Shipping Fee: \(distance, specifier: "%.2f") x $1/km = $\(distance, specifier: "%.2f")")
                                .font(.callout)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 0.1)
                        } else {
                            Text("The store is too far away... Or you have not update your location...")
                                .font(.callout).bold()
                                .foregroundColor(Color.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 0.1)
                        }
                    } else {
                        Text("You don't have enough balance")
                            .font(.callout).bold()
                            .foregroundColor(Color.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 0.1)
                    }
                    

                    // Modal button
                    HStack {
                        Button {
                            isRentModalShown.toggle()
                        } label: {
                            PrimaryButton(title: "Cancel", fore: Color(.black), back: Color(.white))
                                .border(.black, width: 2)
                                .padding(.vertical, 10)
                        }
                        if (distance != 0 && distance < 1000 && dataManager.user.balance > Float(item.pricePerDay)) {
                            Button {
                                handleRent(item: item)
                            } label: {
                                PrimaryButton(title: "Confirm", fore: Color(.white), back: Color(.black))
                                    .padding(.vertical, 10)
                            }
                        }
                    }
                    
                    
                }
                .padding()
                .background(ColorElement.ColorModifier.background())
                .cornerRadius(10)
                .frame(width: UIScreen.screenWidth / 1.2)
                
            }
            
            // MARK: Return Modal
            if isReturnModalShown {
                Color.black.opacity(0.6)
                
                VStack {
                    Text("Confirm Return Order")
                        .font(.title2)
                        .bold()
                    
                    HStack {
                        KFImage(URL(string: item.itemImage[0]))
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.screenWidth / 5, height: UIScreen.screenHeight / 10)
                        
                        VStack {
                            Text(item.name)
                                .font(.callout)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(dataManager.currentVendor.name)
                                .font(.caption)
                                .foregroundColor(.black.opacity(0.6))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("$\(calculateTotalFees(lendingInfo: item.lendingInfo, pricePerDay: item.pricePerDay), specifier: "%.2f")")
                                .font(.callout).bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 0.1)
                        }
                    }
                    
                    // Modal button
                    HStack {
                        Button {
                            isReturnModalShown.toggle()
                        } label: {
                            PrimaryButton(title: "Cancel", fore: Color(.black), back: Color(.white))
                                .border(.black, width: 2)
                                .padding(.vertical, 10)
                        }
                        
                        Button {
                            handleReturn(item: item)
                        } label: {
                            PrimaryButton(title: "Confirm", fore: Color(.white), back: Color(.black))
                                .padding(.vertical, 10)
                        }
                    }
                }
                .padding()
                .background(ColorElement.ColorModifier.background())
                .cornerRadius(10)
                .frame(width: UIScreen.screenWidth / 1.2)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            // Get vendor name
            dataManager.getVendorByEmail(email: item.vendor)
        }
        
        // Custom back button here using extension
        .addCustomBackButton(mode: mode)
        
    }
    
    
    
    func handleRent(item: Item) {
        if (dataManager.user.balance > 0) {
            // Update user
            dataManager.user.balance -= Float(dataManager.getDistance())
            dataManager.user.itemInRent.append(item.id)
            dataManager.updateUser(user: dataManager.user)
            
            // Update item
            var updatedItem = item
            let lendingInfo = ItemLendingInformation(lendDate: Date(), dueDate: nil)
            updatedItem.lendingInfo = lendingInfo
            
            // Update on db
            dataManager.updateItem(updatedItem)
            
            // Disable modal
            isRentModalShown.toggle()
        } else {
            
        }

    }
    
    func handleReturn(item: Item) {
        // Update user
        guard let itemIndex = dataManager.user.itemInRent.firstIndex(of: item.id) else {
            print("User did not rent this item")
            return
        }
        dataManager.user.itemInRent.remove(at: itemIndex)
        dataManager.updateUser(user: dataManager.user)
        
        // Update item
        var updatedItem = item
        updatedItem.lendingInfo = nil
        
        // Update on db
        dataManager.updateItem(updatedItem)
        // Update user and vendor's balance
        updateBalance(totalFee: calculateTotalFees(lendingInfo: item.lendingInfo, pricePerDay: item.pricePerDay))
        
        // Disable modal
        isReturnModalShown.toggle()
        
    }
    
    func calculateTotalFees(lendingInfo: ItemLendingInformation?, pricePerDay: Double) -> Double {
        guard let tmpLendingInfo = lendingInfo else {
            return pricePerDay
        }
        guard let numOfDays = Calendar.current.dateComponents([.day], from: tmpLendingInfo.lendDate!, to: Date()).day else {
            return pricePerDay
        }
        let totalFee = Double(numOfDays + 1) * pricePerDay
        return totalFee
    }
    
    func updateBalance(totalFee: Double) {
        // Update user balance
        dataManager.user.balance -= Float(totalFee)
        dataManager.updateUser(user: dataManager.user)
        
        // Update vendor balance
        dataManager.currentVendor.balance += Float(totalFee)
        dataManager.updateUser(user: dataManager.currentVendor)
    }
}



struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView()
    }
}
