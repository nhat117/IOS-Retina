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

struct MyStoreView: View {
    @Binding var currentView: ScreenView
    let viewName = "myStore"
    @ObservedObject var dataManager: DataManager = DataManager.commonDataManager
    @StateObject var itemsViewModel = ItemsViewModel()
    @ObservedObject var oneItemViewModel = OneItemViewModel()
    @State var selected: Int = 0
    @State private var whiteBtnTap: Bool = false
    //Filter by category handler
    var filteredProducts: [Item] {
        self.itemsViewModel.items.filter{ (item) in
            switch selected{
            case 0:
                return true
            case 1:
                if item.category == "Electronics" {
                    return true
                }
                return false
            case 2:
                if item.category == "Furniture" {
                    return true
                }
                return false
            case 3:
                if item.category == "Books" {
                    return true
                }
                return false
                
            case 4:
                if item.category == "Kitchen" {
                    return true
                }
                return false
                
            case 5:
                if item.category == "Outdoors" {
                    return true
                }
                return false
            default:
                return false
            }
        }
    }
    
    var body: some View {
        GeometryReader{ screen in
            ZStack {
                ColorElement.ColorModifier.background()
                
                ScrollView (showsIndicators: false) {
                    VStack (alignment: .leading) {
                
                        AppBarView(isVendor: false, imageName: dataManager.user.avatarImage, name: dataManager.user.name, email: "", whiteBtnTap: $whiteBtnTap)
                        
                        CategoryCarousel(categories: categories, selectedIndex: $selected)
                        
                        VStack
                        {
                            ScrollView (showsIndicators: false) {
                                VStack {
                                    HorizontalCaroussel(categoryName: "My Products", items: self.filteredProducts)
                                }
                            }
                        }
                        .onAppear(perform: {
                            self.itemsViewModel.fetchVendorItems(vendorId: dataManager.user.email)
                        })
                    }
                }
            }
            .sheet(isPresented: $whiteBtnTap) {
                AddProductView(whiteBtnTap: $whiteBtnTap).padding()
            }
        }
        
    }
}

struct MyStoreView_Previews: PreviewProvider {
    static var previews: some View {
        MyStoreView(currentView: .constant(.myStore))
    }
}
