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

struct HomeView: View {
    @Binding var currentView: ScreenView
    let viewName = "home"
    @StateObject var itemsViewModel = ItemsViewModel()
    @StateObject var itemsViewModelCate = ItemsViewModel()
    @ObservedObject var oneItemViewModel = OneItemViewModel()
    @State var selected: Int = 0
    @State var searchString: String = ""
    
    //Filter product after category
    var filteredProducts: [Item] {
        itemsViewModelCate.items.filter{ (item) in
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
        ZStack{
            ColorElement.ColorModifier.background()
            VStack
            {
                SearchBar(search: $searchString, itemsVM: itemsViewModel)
                    .onChange(of: searchString) { newVlue in
                        if !searchString.isEmpty {
                            itemsViewModel.subscribe_tag(itemTag: searchString)
                        } else {
                            itemsViewModel.subscribe()
                        }
                    }
                
                if searchString.isEmpty {
                    CategoryCarousel(categories: categories, selectedIndex: $selected )
                }
                ScrollView (showsIndicators: false) {
                    if (searchString.isEmpty && selected == 0) {
                        
                        
                        VStack {
                            //                        Text("\(self.filteredProducts.count)")
                            HorizontalCaroussel(categoryName: "Feature Items", items: self.itemsViewModel.items.count > 4 ? Array(self.itemsViewModel.items[0...4]) : [])
                            
                            Spacer()
                            VerticalCaroussel(categoryName: "Listed Items", items: self.itemsViewModel.items.count > 5 ? Array(self.itemsViewModel.items[5...]) : [])
                        }
                    } else if (selected != 0) {
                        VerticalCaroussel(categoryName: "", items: self.filteredProducts)
                    } else if (!searchString.isEmpty && self.itemsViewModel.items.count > 0) {
                        VerticalCaroussel(categoryName: "Search Results", items: self.itemsViewModel.items)
                            .padding(.top)
                    } else {
                        Text("No results")
                            .padding()
                    }
                }
            }
            .onAppear(perform: {
                self.itemsViewModel.subscribe()
                self.itemsViewModelCate.subscribe()
            })
            
        }
    }
}
