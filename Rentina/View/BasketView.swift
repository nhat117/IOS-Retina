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

struct BasketView: View {
    @ObservedObject var dataManager: DataManager = DataManager.commonDataManager
    @ObservedObject var itemsViewModel = ItemsViewModel()
    @ObservedObject var oneItemViewModel = OneItemViewModel()
    @Binding var currentView: ScreenView
    @State var isReturnModalShown = false
    @State var selectedItem = Item(name: "Upholstered Lounge Chair Zuiver", vendor: "Lazy Sack", description: "Stay light-years ahead of the competition with our Aim Analog Watch. The flexible, rubberized strap is contoured to conform to the shape of your wrist for a comfortable all-day fit. The face features three illuminated hands, a digital read-out of the current time, and stopwatch functions.", pricePerDay: 10.0, itemImage: ["http://eimages.valtim.com/acme-images/product/m/g/mg03-br-0.jpg"])
    @State var selectedVendor = User()
    let viewName = "basket"
    var body: some View {
        ZStack {
            ColorElement.ColorModifier.background()
            // MARK: Basket view
            VStack(spacing: 0) {
                AppBar(title: "Your Basket")
                
                ScrollView (showsIndicators: false) {
                    VStack (spacing: 10) {
                        
                        // Each basket item
                        ForEach(self.itemsViewModel.items) { item in
                            if (dataManager.user.itemInRent.contains(item.id)){
                                BasketItemCard(selectedItem: $selectedItem, selectedVendor: $selectedVendor, isReturnModalShown: $isReturnModalShown, item: item, size: 100)
                            }
                        }
                    }
                }.padding()
                
                if (self.itemsViewModel.items.count == 0) {
                    Text("Empty basket")
                        .font(.title3)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            
            
            // MARK: Return modal
            if isReturnModalShown {
                Color.black.opacity(0.6)
                
                ZStack { 
                    VStack {
                        Text("Confirm Return Order")
                            .font(.title2)
                            .bold()
                        
                        HStack {
                            KFImage( URL(string:selectedItem.itemImage[0]))
                                .centerCropped()
                                .frame(width: UIScreen.screenWidth / 5, height: UIScreen.screenHeight / 10)
                            
                            VStack {
                                Text(selectedItem.name)
                                    .font(.callout)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(dataManager.currentVendor.name)
                                    .font(.caption)
                                    .foregroundColor(.black.opacity(0.6))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("$\(calculateTotalFees(lendingInfo: selectedItem.lendingInfo, pricePerDay: selectedItem.pricePerDay), specifier: "%.2f")")
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
                                handleReturn(item: selectedItem)
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
        }.onAppear(perform: {
            self.itemsViewModel.subscribe()
        })
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
        
        // Update on item on Firestore
        dataManager.updateItem(updatedItem)
        // Update user and vendor's balance
        updateBalance(totalFee: calculateTotalFees(lendingInfo: selectedItem.lendingInfo, pricePerDay: selectedItem.pricePerDay))
        
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

struct BasketView_Previews: PreviewProvider {
    static var previews: some View {
        BasketView(currentView: .constant(.basket))
    }
}
