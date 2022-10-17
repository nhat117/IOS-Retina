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

struct AddProductView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    //    @Binding var currentView: ScreenView
    @State var product: Item = Item()
    @State var isCategoryTap: Bool = false
    @ObservedObject var mlHelper: MLHelper = MLHelper.mlHelper
    @ObservedObject private var dataManager: DataManager = DataManager.commonDataManager
    @Binding var whiteBtnTap: Bool
    //Mark:
    @ObservedObject private var itemViewModel : ItemsViewModel = ItemsViewModel()
    @State var recommendedTag: String = ""
    @State var pricePerDayString: String = ""
    @State var isLendingRateTap: Bool = false
    @State var isExpireTypeTap: Bool = false
    @State var tag: String = "All"
    @State var expireDay : String = "One Day"
    var len = 2
    
    
    //MARK: HANDLING THE CATEGORY SELECTOR
    
    
    let viewName = "addItem"
    
    //For image carroussel
    @State var showActionSheet: Bool = false
    @State var showImagePicker = false
    @State var imageIndex: Int = 0
    @State var itemTag: String = ""
    @State var forwards: Bool = false
    @State private var addedImages = [UIImage]()
    @State private var isShowPhotoLibrary = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var pickImage: UIImage =  UIImage(imageLiteralResourceName: "Profile")
    
    var bindingForImage: Binding<UIImage> {
        Binding<UIImage> { () -> UIImage in
            return addedImages.last ?? UIImage()
        } set: { (newImage) in
            addedImages.append(newImage)
        }
    }
    
    var body: some View {
        
        ScrollView {
            UploadItemView( isPlusTap: $showActionSheet, imageIndex: $imageIndex, forwards: $forwards, displayImages: addedImages)
                .background()
            
            
            //MARK: Form group
            
            VStack( spacing: 15){
                VStack(alignment:.leading, spacing: 5){
                    Text("Product Name")
                        .font(.title3.bold())
                    TextField("", text: $product.name).modifier(PrimaryTextFieldModifier())
                }.padding()
                
                VStack(alignment:.leading, spacing: 5){
                    Text("Lending Rate")
                        .font(.title3.bold())
                    HStack {
                        TextField("", text: $pricePerDayString)
                            .keyboardType(.numberPad)
                            .modifier(PrimaryTextFieldModifier())
                        Text("Per Day").modifier(TextModifier())
                    }
                    
                }.padding()
                
                VStack(alignment:.leading, spacing: 5){
                    Text("Description")
                        .font(.title3.bold())
                    TextField("", text: $product.description).modifier(PrimaryTextFieldModifier())
                }.padding()
                
                VStack(alignment:.leading, spacing: 5){
                    Text("Tag")
                        .font(.title3.bold())
                    TextField("", text: $itemTag).modifier(PrimaryTextFieldModifier())
                }.padding()
                
                HStack{
                    Text("Recommended Tag: \(recommendedTag)")
                        .font(.title3.bold())
                    Spacer()
                    Spacer()
                }.padding()
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Lending Duration").font(.title3.bold())
                        Text(product.expireDayType).modifier(TextModifier()).onTapGesture {
                            isExpireTypeTap.toggle()
                        }
                    }.padding(.trailing)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Categories")
                            .font(.title3.bold())
                        //TODO: Insert picker
                        Text(product.category).modifier(TextModifier()).onTapGesture {
                            isCategoryTap.toggle()
                        }
                    }
                    Spacer()
                }.padding()
            }
            .frame(maxWidth:.infinity )
            Button{
                product.vendor = dataManager.user.email
                dataManager.uploadImages(addedImages, product: product)
                //Handling uploading storage logic
                DispatchQueue.global(qos:.userInitiated).async
                {
                    while (true) {
                        
                        if(dataManager.count == 0) {
                            
                            product.itemImage = dataManager.imgArr
                            
                            var dataArray = itemTag.lowercased().components(separatedBy: " ")
                            var nameArr = product.name.lowercased().components(separatedBy: " ")
                            let reccommendTagArray = mlHelper.predictCategory.lowercased().components(separatedBy: ",")
                            
                            dataArray += reccommendTagArray
                            dataArray += nameArr
                            
                            product.itemTag = dataArray.deDuplicates()
                            
                            guard let safePricePerday = Double(pricePerDayString) else {
                                return
                            }
                            guard let itemId = dataManager.addItemHaveId(product) else {
                                fatalError("Cannot save data")
                            }
                            product = itemId
                            product.pricePerDay = safePricePerday
                            dataManager.updateItem(product)
                            dataManager.user.itemForLesse.append(itemId.id)
                            dataManager.updateUser(user: dataManager.user)
                            
                            break
                            
                        }
                        
                    }
                }
                
                //Close the sheet
                whiteBtnTap = false
                
            } label :{
                PrimaryButton(title: "Add Item", fore: Color(.white), back: Color("PrimaryColor"))
            }.padding()
            
        }
        .frame(maxWidth: UIScreen.screenWidth, maxHeight: .infinity,  alignment: .top)
        .padding()
        //MARK: Image picker and partial sheet
        .sheet(isPresented: $showImagePicker) {
            CustomImagePicker(sourceType: sourceType, selectedImage: $addedImages).onDisappear() {
                if(addedImages.count != 0) {
                    mlHelper.classifyImage(inputImage: addedImages[0])//Retrieve the first image
                    recommendedTag = mlHelper.predictCategory
                }
            }
            
        }
        
        //MARK: Doing some logic for posting image
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
        
        .customBottomSheet(isPresented: $isExpireTypeTap) {
            Picker("",selection: $product.expireDayType) {
                ForEach(expireDayCategory, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(.wheel)
        }
        
        .customBottomSheet(isPresented: $isCategoryTap) {
            Picker("",selection: $product.category) {
                ForEach(categories, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(.wheel)
        }
        
    }
}


struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView(whiteBtnTap: .constant(false))
    }
}


