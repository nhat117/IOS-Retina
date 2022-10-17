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

struct LoginView: View {    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var err: String = ""
    @State private var isLogin: Bool = false
    //    @Binding var isUserLoggedIn : Bool
    @Binding var loginScreenSwitcher: LoginScreenSwitcher
    @State private var isSecured: Bool = true
    
    @EnvironmentObject var messagesManager: MessagesManager
    @ObservedObject var dataManager: DataManager = DataManager.commonDataManager
    var body: some View {
        GeometryReader {screen in
            ZStack {
                Color("BgColor").edgesIgnoringSafeArea(.all)
                VStack (spacing : UIScreen.screenHeight*0.1){
                    Image(uiImage: #imageLiteral(resourceName: "onboard"))
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                        .padding(.horizontal,UIScreen.screenWidth*0.1)
                    VStack{
                        TextField("Email", text: $email).modifier(PrimaryTextFieldModifier())
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
                        
                        if(err != "") {
                            Text(err).foregroundColor(.red)
                        }
                        
                        PrimaryButton(title: "Sign In", fore: Color(.white), back: Color("PrimaryColor")).onTapGesture(perform: {
                            login()
                            dataManager.getUserByEmail(email: email)
                        })
                        .disabled($email.wrappedValue.isEmpty && $password.wrappedValue.isEmpty)
                        .padding(.vertical)
                        
                        HStack {
                            Text("New around here? ")
                            Text("Sign up")
                                .foregroundColor(Color("PrimaryColor"))
                                .onTapGesture(perform: {
                                    ////switchState to sign up
                                    loginScreenSwitcher = .signUp
                                })
                        }}
                }
                .padding()
            }
        }
    }
    //Authentication
    //Login
    func login() {
        //        dataManager.loadDummyData()
        Auth.auth().signIn(withEmail: email.lowercased(), password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                err = error?.localizedDescription ?? ""
            } else {
                loginScreenSwitcher = .navBar
                ////switchState to home screen
                print("success")
            }
        }
    }
}

