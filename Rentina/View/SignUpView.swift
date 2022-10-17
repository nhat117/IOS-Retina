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
import Firebase

struct SignUpView: View {
    @State private var user : User = User()
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var phone: String = ""
    @State private var address: Address = Address(long: 0, lat: 0, address: "")
    @State private var balance: Float = 0
    @State private var avatarImage: String = ""
    @State private var itemForLesse: [Item] = []
    @State private var itemInRent: [Item] = []
    
    @Binding var loginScreenViewSwitcher: LoginScreenSwitcher
    @State private var isSecured: Bool = true
    @State private var err: String = ""
    
    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            VStack {
                ScrollView (showsIndicators: false) {
                    VStack {
                        Text("Sign Up")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 30)
                        
                        TextField("Email", text: $user.email).modifier(PrimaryTextFieldModifier())
                        ZStack(alignment: .trailing) {
                            if isSecured {
                                SecureField("Password", text: $password).modifier(PrimaryTextFieldModifier())
                            } else {
                                TextField("Password", text: $password).modifier(PrimaryTextFieldModifier())
                            }
                            
                            Button(action: {
                                isSecured.toggle()
                            }) {
                                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                                    .accentColor(.gray)
                            }
                            .padding(.trailing, 15)
                        }
                        TextField("Username", text: $user.name).modifier(PrimaryTextFieldModifier())
                        TextField("Phone number", text: $user.phone).modifier(PrimaryTextFieldModifier())
                        AddressComponent(user: $user)
                        
                    }
                    .padding(.bottom)
                    if (checkEmptyTextview()){
                        Text("Please fill in all the fields!")
                            .foregroundColor(.red)
                            .padding(.bottom, 30)
                        
                    }
                    
                }
                PrimaryButton(title: "Sign up with email", fore: Color(.white), back: !checkEmptyTextview() ? Color("PrimaryColor") : Color.black).onTapGesture(perform: {
                    register()
                })
                .disabled(checkEmptyTextview())
                .padding(.vertical)
                Text("or you can sign up with")
                    .foregroundColor(Color.black.opacity(0.4))
                HStack {
                    SocalLoginButton(image: Image(uiImage: #imageLiteral(resourceName: "apple")))
                    SocalLoginButton(image: Image(uiImage: #imageLiteral(resourceName: "google"))).foregroundColor(Color("PrimaryColor"))
                }
                
                
                
                Spacer()
                Divider()
                Text("Back to Sign In")
                    .foregroundColor(Color("PrimaryColor"))
                    .onTapGesture(perform: {
                        loginScreenViewSwitcher = .login
                    })
            }
            .padding()
        }
    }
    func checkEmptyTextview() -> Bool{
        return $user.email.wrappedValue.isEmpty || $password.wrappedValue.isEmpty || $user.name.wrappedValue.isEmpty || $user.phone.wrappedValue.isEmpty || $user.address.address.wrappedValue.isEmpty || ($user.address.lat.wrappedValue == 0 && $user.address.long.wrappedValue == 0)
    }
    //Authentication
    //SignUp
    func register() {
        Auth.auth().createUser(withEmail: user.email.lowercased(), password: password) {res, error in
            err = "Account created, please log in"
            if error != nil {
                err = error!.localizedDescription
                return
            }
            //Creat an instance of database
            DataManager.commonDataManager.createUser(user: user)
            ////switchState to log in
            loginScreenViewSwitcher = .login
        }
    }
}
