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

struct VendorView: View {
    @ObservedObject var dataManager: DataManager = DataManager.commonDataManager
    @StateObject var itemsViewModel = ItemsViewModel()
    @ObservedObject var oneItemViewModel = OneItemViewModel()
    @State private var search: String = ""
    @State private var selectedIndex: Int = 0
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var vendorEmail = ""
    @State private var items: [Item] = []
    
    var body: some View {
        ZStack {
            ColorElement.ColorModifier.background()
            
            ScrollView (showsIndicators: false) {
                VStack (alignment: .leading) {
                    //TODO: Nhat refractor app bar and do something
                    AppBarView(isVendor: true, imageName: dataManager.currentVendor.avatarImage, name: dataManager.currentVendor.name, email: dataManager.currentVendor.email, whiteBtnTap: .constant(false))
                    
                    CategoryCarousel(categories: categories, selectedIndex: $selectedIndex)
                    
                    VStack
                    {
                        ScrollView (showsIndicators: false) {
                            VStack {
                                VerticalCaroussel(categoryName: "", items: selectedIndex > 0 ? self.itemsViewModel.items.filter { $0.vendor == dataManager.currentVendor.email && ($0.category == categories[selectedIndex]) } :
                                                    self.itemsViewModel.items
                                )
                            }
                        }
                    }
                    
                }
            }
        }
        .makeNavigationPrettier(viewName: "", mode: mode )
        .onAppear {
            self.itemsViewModel.subscribe()
        }
        
    }
    
    func handleDoneTapped() {
        self.oneItemViewModel.handleDoneTapped()
    }
}


struct VendorView_Previews: PreviewProvider {
    static var previews: some View {
        VendorView()
    }
}





