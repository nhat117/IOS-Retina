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
import Kingfisher
import Combine
struct MenuView: View {
    @Binding var loginScreenViewSwitcher : LoginScreenSwitcher
    @ObservedObject var dataManager: DataManager = DataManager.commonDataManager
    @State var isDepositeBalance = false
    let viewName = "menu"
    @State var  buttonList : [String] = ["Profile", "Credit"]
    @State var depositBalance = ""
    @State var bankAccount = ""
    var body: some View {
        ZStack {
            Color(viewName).opacity(0.7)
                .ignoresSafeArea(.all)
            
            VStack (alignment: .center, spacing: 0){
                
                
                profileInfo()
                Divider()
                
                ScrollView(.vertical, showsIndicators: false){
                    VStack(alignment: .leading, spacing: 0){
                        //Tab buttons
                        ForEach (buttonList, id:\.hashValue) {
                            button in
                            NavigationLink{
                                switch button {
                                case "Profile":
                                    ProfileView()
                                case "Credit":
                                    CreditView()
                                default:
                                    Text("")
                                }
                            } label: {
                                TabButton(title:button)
                            }
                            
                        }
                        
                    }
                }
                
                VStack(spacing:0){
                    Divider()
                    HStack{
                        Button{
                            self.loginScreenViewSwitcher = .login
                            try! Auth.auth().signOut()
                        }label: {
                            HStack{
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.red)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 22, height: 22)
                                    .scaleEffect(CGSize(width: -1.0, height: 1.0))
                                
                                Text("Sign Out")
                                    .font(.title2)
                                    .foregroundColor(.red)
                                
                            }
                            .foregroundColor(.primary)
                            .padding(5)
                        }
                    }
                    .padding(.vertical,10)
                }
            }
            
            .frame(maxWidth: .infinity, maxHeight:.infinity, alignment: .leading)
            if isDepositeBalance{
                Color.black.opacity(0.6)
                
                VStack {
                    Text("Deposit Balance")
                        .font(.title2)
                        .bold()
                    
                    VStack{
                        TextField("Bank Account", text: $bankAccount).modifier(PrimaryTextFieldModifier())
                        TextField("Money Amount", text: $depositBalance)
                            .keyboardType(.numberPad)
                            .onReceive(Just(depositBalance)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.depositBalance = filtered
                                }
                            }
                            .modifier(PrimaryTextFieldModifier())
                        
                    }
                    
                    // Modal button
                    HStack {
                        Button {
                            bankAccount = ""
                            depositBalance = ""
                            isDepositeBalance.toggle()
                        } label: {
                            PrimaryButton(title: "Cancel", fore: Color(.black), back: Color(.white))
                                .border(.black, width: 2)
                                .padding(.vertical, 10)
                        }
                        
                        Button {
                            handleAddMoney()
                            bankAccount = ""
                            depositBalance = ""
                        } label: {
                            PrimaryButton(title: "Confirm", fore: Color(.white), back: Color(.black))
                                .padding(.vertical, 10)
                        }
                    }
                }
                
                .padding()
                .background(ColorElement.ColorModifier.background())
                .cornerRadius(10)
                .frame(width: UIScreen.screenWidth / 1.2)            }
        }
    }
    func handleAddMoney(){
        
        let trimmedString = depositBalance.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
        dataManager.user.balance += Float(trimmedString) ?? 0
        dataManager.updateUser(user: dataManager.user)
        isDepositeBalance.toggle()
    }
    @ViewBuilder
    func DefaultHomeView() -> some View {
    }
    @ViewBuilder
    func TabButton(title:String ) -> some View{
        let buttonIcon = buttonIcons[title] ?? "default"
        
        HStack(spacing:14){
            Image(systemName: buttonIcon)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fill)
                .frame(width: 22, height: 22)
            Text(title)
        }
        .foregroundColor(.primary)
        .frame(maxWidth:.infinity, alignment:.leading)
        
        .padding()
    }
    @ViewBuilder
    func profileInfo() -> some View{
        VStack (alignment: .center, spacing: 5){
            KFImage( URL(string: dataManager.user.avatarImage))
                .centerCropped()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color(.white),lineWidth: 2))
            
            Text(dataManager.user.name)
                .font(.title.bold())
            Text("\(dataManager.user.email)")
                .font(.callout)
            HStack(spacing:12){
                Button{
                    isDepositeBalance = true
                } label: {
                    Label{
                        HStack{
                            Text("\(dataManager.user.balance,specifier: "%.2f")")
                                .bold()
                            Image(systemName: buttonIcons["Plus"]!)
                        }
                    }icon:{
                        Text("$")
                    }
                }
                
            }
        }
        .foregroundColor(.primary)
        .frame(maxWidth:.infinity)
        .padding(.horizontal)
        .padding(.vertical)
        
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(loginScreenViewSwitcher: .constant(.navBar))
    }
}
