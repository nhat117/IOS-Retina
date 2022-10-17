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


enum FilterCategory {
    case all;
    case electronics;
    case furniture;
    case books;
    case kitchen;
    case outdoors;
}
struct SearchBar: View {
    @Binding var search: String
    
    @ObservedObject var itemsVM: ItemsViewModel
    //    @State search
    var body: some View {
        HStack {
            TextField("Search", text: $search)
                .textCase(.lowercase)
                .autocapitalization(.none)
                .padding(.all, 20)
                .background(Color.white)
                .cornerRadius(10.0)
                .padding(.trailing, 8)
            
            Button(action: {
                if (search == "") {
                    itemsVM.subscribe_tag(itemTag: search.lowercased())
                } else {
                    search = ""
                }
                
            }) {
                if(search == "") {
                    Image(systemName: "magnifyingglass")
                        .font(.title)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color("Primary"))
                        .cornerRadius(10.0)
                } else {
                    Image(systemName: "xmark")
                        .font(.title)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color("Primary"))
                        .cornerRadius(10.0)
                }
                
            }
        }
        .padding(.horizontal)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(search: .constant("Ho"), itemsVM: ItemsViewModel())
    }
}
