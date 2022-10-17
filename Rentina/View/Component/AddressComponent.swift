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

struct AddressComponent: View {
    @Binding var user: User
    @ObservedObject var locationManager: LocationManager = LocationManager()
    @State var isTypingAddress = false
    
    var body: some View {
        VStack(alignment:.leading, spacing: 5){
            VStack(spacing: 5){
                TextField("Address", text: $user.address.address).modifier(PrimaryTextFieldModifier())
                    .onSubmit {
                        locationManager.convertAddress(address: user.address.address)
                        isTypingAddress = false
                        
                    }
                    .onChange(of: user.address.address){
                        newV in
                        if !isTypingAddress {
                            user.address = Address()
                        }
                        isTypingAddress = true
                    }
                    .onChange(of: locationManager.index){newValue in
                        user.address.long = locationManager.location.longitude
                        user.address.lat = locationManager.location.latitude
                    }
                if (user.address.long != 0.0 || user.address.lat != 0.0){
                    //                    Text("\(user.address.long) - \(user.address.lat)")
                    //                        .font(.title3)
                    MapView(long: user.address.long, lat:user.address.lat)
                        .frame(height: 300)
                        .padding(.top)
                        .cornerRadius(10)
                } else {
                    Text("The given address is not existed")
                        .foregroundColor(.red)
                }
            }
            .padding()
            .overlay(Rectangle().opacity(0).border(.primary,width: 2))
            
            
        }
        .frame(maxWidth:.infinity, alignment: .center)
    }
}

struct AddressComponent_Previews: PreviewProvider {
    static var previews: some View {
        AddressComponent(user: .constant(User()))
    }
}
