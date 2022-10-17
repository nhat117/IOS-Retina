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

struct PrimaryButton: View {
    var title: String
    var fore: Color
    var back: Color
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(fore)
            .frame(maxWidth: .infinity)
            .padding()
            .background(back)
            .cornerRadius(3)
            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
    }
}


struct SocalLoginButton: View {
    let image: Image
    
    
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color("PrimaryColor"),lineWidth: 2)
                .background(Circle().foregroundColor(Color.white))
                .frame(width: 40, height: 40)
            
            
            // Use this implementation for an SF Symbol
            image
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: 20, height: 20)
            
            // Use this implementation for an image in your assets folder.
            //            Image(icon)
            //                .resizable()
            //                .aspectRatio(1.0, contentMode: .fit)
            //                .frame(width: squareSide, height: squareSide)
            
        }
    }
}

struct ProductCardViewHorizontal: View {
    let image: Image
    let height: CGFloat
    let name: String
    let price: Double
    let status: String
    
    var body: some View {
        HStack {
            image
                .resizable()
                .frame(width: height, height: height, alignment: .leading)
                .padding(.leading, 0)
            VStack (alignment: .leading) {
                Text(name).font(.title3).fontWeight(.regular)
                Text("\(String(price))$/day").font(.body).fontWeight(.regular)
                Text(status).font(.body).fontWeight(.bold).foregroundColor(.green)
            }
            Spacer()
        }
        .frame(alignment: .leading)
        .foregroundColor(.white)
        .frame(height: height)
        .background(Color("PrimaryColor"))
        
    }
}

struct TagLineView: View {
    var body: some View {
        Text("Find the \nBest ")
            .font(.custom("PlayfairDisplay-Regular", size: 28))
            .foregroundColor(Color("Primary"))
        + Text("Furniture!")
            .font(.custom("PlayfairDisplay-Bold", size: 28))
            .fontWeight(.bold)
            .foregroundColor(Color("Primary"))
    }
}

struct SearchAndScanView: View {
    @Binding var search: String
    var body: some View {
        HStack {
            HStack {
                Image("Search")
                    .padding(.trailing, 8)
                TextField("Search Furniture", text: $search)
            }
            .padding(.all, 20)
            .background(Color.white)
            .cornerRadius(10.0)
            .padding(.trailing, 8)
            
            Button(action: {}) {
                Image("Scan")
                    .padding()
                    .background(Color("Primary"))
                    .cornerRadius(10.0)
            }
        }
        .padding(.horizontal)
    }
}

struct CategoryView: View {
    let isActive: Bool
    let text: String
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            Text(text)
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundColor(isActive ? Color("Primary") : Color.black.opacity(0.5))
            if (isActive) { Color("Primary")
                    .frame(width: 15, height: 2)
                    .clipShape(Capsule())
            }
        }
        .padding(.trailing)
    }
}




struct BottomNavBarView: View {
    var body: some View {
        HStack {
            BottomNavBarItem(image: Image("Home"), action: {})
            BottomNavBarItem(image: Image("fav"), action: {})
            BottomNavBarItem(image: Image("shop"), action: {})
            BottomNavBarItem(image: Image("User"), action: {})
        }
        .padding()
        .background(Color.white)
        .clipShape(Capsule())
        .padding(.horizontal)
        .shadow(color: Color.blue.opacity(0.15), radius: 8, x: 2, y: 6)
    }
}

struct BottomNavBarItem: View {
    let image: Image
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            image
                .frame(maxWidth: .infinity)
        }
    }
}

