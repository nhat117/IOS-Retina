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

struct ProfileView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var showImagePicker = false
    @State var showActionSheet = false
    @ObservedObject private var dataManager: DataManager = DataManager.commonDataManager
    @State var isChangeImage : Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var pickImage: UIImage? = UIImage(imageLiteralResourceName: "Profile")
    
    
    let viewName = "menu"
    var body: some View {
        ZStack (alignment: .top){
            Color(viewName).opacity(0.7)
                .ignoresSafeArea(.all)
            //MARK: Vendor profile info
            ScrollView(){
                VStack( spacing: 0){
                    ZStack (alignment: .bottomTrailing ){
                        if (isChangeImage){
                            Image(uiImage: pickImage!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color(.white),lineWidth: 2))
                                .onTapGesture {
                                    // Edit image over here
                                    showActionSheet.toggle()
                                }
                        } else {
                            KFImage( URL(string: dataManager.user.avatarImage))
                                .centerCropped()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color(.white),lineWidth: 2))
                            
                        }
                        Button{
                            // Edit image over here
                            showActionSheet.toggle()
                            isChangeImage = true
                        } label: {
                            Image( systemName: "pencil")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.primary)
                                .frame(width: 20, height: 20)
                                .padding(10)
                                .background(.white)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(.black,lineWidth: 2))
                        }
                    }
                    .shadow(radius: 7)
                    .padding()
                    Text(dataManager.user.name)
                        .font(.title.bold())
                    Text("\(dataManager.user.id ?? "")")
                        .font(.callout.bold())
                    VStack( spacing: 15){
                        VStack(alignment:.leading, spacing: 5){
                            Text("Display Name")
                                .font(.title3.bold())
                            TextField("", text: $dataManager.user.name).modifier(PrimaryTextFieldModifier())
                        }
                        VStack(alignment:.leading, spacing: 5){
                            Text("Phone")
                                .font(.title3.bold())
                            TextField("", text: $dataManager.user.phone).modifier(PrimaryTextFieldModifier())
                        }
                        VStack(alignment:.leading, spacing: 5){
                            Text("Address")
                                .font(.title3.bold())
                            AddressComponent(user: $dataManager.user)
                        }
                        
                        
                    }
                    .frame(maxWidth:.infinity )
                    .padding(.top)
                    
                    
                    if (checkEmptyTextview()){
                        Text("Please fill in all the fields!")
                            .foregroundColor(.red)
                            .padding(.vertical, 20)
                    }
                    Button{
                        if  isObjectNotNil(object: pickImage) {
                            let uuid = UUID().uuidString
                            let path = "\(dataManager.user.email)_profile_\(uuid)"
                            dataManager.count = 1
                            dataManager.imgArr = []
                            dataManager.uploadImage(pickImage!, name: path)
                        }
                        
                        DispatchQueue.global(qos:.userInitiated).async
                        {
                            while (true) {
                                
                                if(dataManager.count == 0) {
                                    if  isObjectNotNil(object: pickImage) {
                                        dataManager.user.avatarImage = dataManager.imgArr[0]
                                    }
                                    dataManager.updateUser(user: dataManager.user)
                                    break
                                    
                                }
                                
                            }
                        }
                        
                        //Close the sheet
                        mode.wrappedValue.dismiss()
                        
                    }label :{
                        PrimaryButton(title: "Update Information", fore: Color(.white), back: !checkEmptyTextview() ? Color("PrimaryColor") : Color.black)
                    }.padding(.top)
                        .disabled(checkEmptyTextview())
                    
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()            
        }
        .makeNavigationPrettier(viewName: viewName, mode: mode)
        .sheet(isPresented: $showImagePicker) {
            //Allow user to pick image form libary or from camera
            CustomImagePickerView(selectedImage: $pickImage, sourceType: sourceType)
            
        }
        .actionSheet(isPresented: $showActionSheet) { () -> ActionSheet in
            ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your product image"), buttons: [
                ActionSheet.Button.default(Text("Camera"), action: {
                    self.sourceType = .camera
                    showImagePicker.toggle()
                }),
                ActionSheet.Button.default(Text("Photo Library"), action: {
                    sourceType = .photoLibrary
                    showImagePicker.toggle()
                }), ActionSheet.Button.cancel()])
        }
    }
    
    func checkEmptyTextview() -> Bool{
        return dataManager.user.email.isEmpty ||   dataManager.user.name.isEmpty || dataManager.user.phone.isEmpty || dataManager.user.address.address.isEmpty || (dataManager.user.address.lat == 0 && dataManager.user.address.long == 0)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
