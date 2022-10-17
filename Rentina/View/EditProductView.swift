//
//  EditProductView.swift
//  Rentina
//
//  Created by Jimmy on 15/09/2022.
//

import SwiftUI

struct EditProductView: View {
    

    @StateObject var editProductViewModel: EditProductViewModel  = EditProductViewModel()
    
    var product: Item
    @Binding var whiteBtnTap: Bool

    let viewName = "addItem"
    var len = 2

    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var pickImage: UIImage =  UIImage(imageLiteralResourceName: "Profile")
    
    @ObservedObject private var dataManager: DataManager = DataManager.commonDataManager
    
    
    var body: some View {
        GeometryReader { screen in
            ZStack{
                Color(viewName).opacity(0.7)
                    ScrollView (showsIndicators: false){
                        UploadItemView(len: len, w: screen.size.width, h: screen.size.height, imageIndex: $editProductViewModel.imageIndex, forwards: $editProductViewModel.forwards)
                        
                        //MARK: Form group
                        
                        VStack( spacing: 15){
                            VStack(alignment:.leading, spacing: 5){
                                Text("Product Name")
                                    .font(.title3.bold())
                                TextField("", text: $editProductViewModel.product.name).modifier(PrimaryTextFieldModifier())
                            }
                            
                            VStack(alignment:.leading, spacing: 5){
                                Text("Lending Rate Rate")
                                    .font(.title3.bold())
                                HStack {
                                    TextField("", text: $editProductViewModel.pricePerDayString)
                                        .keyboardType(.numberPad)
                                        .modifier(PrimaryTextFieldModifier())
                                    Text("Per Day").modifier(TextModifier())
                                }
                                
                            }
                            
                            VStack(alignment:.leading, spacing: 5){
                                Text("Description")
                                    .font(.title3.bold())
                                TextField("", text: $editProductViewModel.product.description).modifier(PrimaryTextFieldModifier())
                            }
                            
                            VStack(alignment:.leading, spacing: 5){
                                Text("Tag")
                                    .font(.title3.bold())
                                TextField("", text: $editProductViewModel.itemTag).modifier(PrimaryTextFieldModifier())
                            }
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Lending Duration").font(.title3.bold())
                                    Text(product.expireDayType).modifier(TextModifier()).onTapGesture {
                                        editProductViewModel.isExpireTypeTap.toggle()
                                    }
                                }.padding(.trailing)
                               
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Categories")
                                        .font(.title3.bold())
                                    //TODO: Insert picker
                                    Text(product.category).modifier(TextModifier()).onTapGesture {
                                        editProductViewModel.isCategoryTap.toggle()
                                    }
                                }
                                Spacer()
                            }
                        }
                        .frame(maxWidth:.infinity )
                        .padding(.top)
                        Button{
                            //TODO: Wiring data for item
                            //MARK: add right here
                            //Parsing item tag
                            let dataArray = editProductViewModel.itemTag.components(separatedBy: " ")
                            print(dataArray)
                            editProductViewModel.product.itemTag = dataArray
                            editProductViewModel.product.vendor = dataManager.user.email
                            guard let safePricePerday = Double(editProductViewModel.pricePerDayString) else {
                                return
                            }
                            editProductViewModel.product.pricePerDay = safePricePerday
//                            dataManager.addItem(product)
                            //TODO: For t
                            guard let itemId = dataManager.addItemHaveId(product) else {
                                fatalError("Cannot save data")
                            }
                            print(product.asDictionary)
                            dataManager.user.itemForLesse.append(itemId.id)
                            dataManager.updateUser(user: dataManager.user)
                            //Close the sheet
                            //TODO: Handling upload image
//                            whiteBtnTap = false
                            
                        } label :{
                            PrimaryButton(title: "Edit Item", fore: Color(.white), back: Color("PrimaryColor"))
                                .onTapGesture(perform: {
                                    editProductViewModel.editProduct()
                                    whiteBtnTap.toggle()
                                })
                            
                            
                        }.padding(.top)
                        
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    
                    .padding()
                    .background()
                
                
            }
        }

        
//        .makeNavigationPrettier(viewName: viewName, mode: mode)
        
        .sheet(isPresented: $editProductViewModel.showImagePicker) {
            CustomImagePicker(sourceType: sourceType, selectedImage: $pickImage)
        }
        
        //MARK: Doing some logic for posting image
        //TODO: Add some logic for posting multiple image
        .actionSheet(isPresented: $editProductViewModel.showActionSheet) { () -> ActionSheet in
            ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your product image"), buttons: [
                ActionSheet.Button.default(Text("Camera"), action: {
                    self.sourceType = .camera
                    editProductViewModel.showImagePicker.toggle()
                }),
                ActionSheet.Button.default(Text("Photo Library"), action: {
                    sourceType = .photoLibrary
                    editProductViewModel.showImagePicker.toggle()
                }), ActionSheet.Button.cancel()])
        }.onAppear{
            editProductViewModel.initProduct(item: product)
        }
        
        .customBottomSheet(isPresented: $editProductViewModel.isExpireTypeTap) {
            Picker("",selection: $editProductViewModel.product.expireDayType) {
                ForEach(expireDayCategory, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(.wheel)
        }
        
        .customBottomSheet(isPresented: $editProductViewModel.isCategoryTap) {
            Picker("",selection: $editProductViewModel.product.category) {
                ForEach(categories, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(.wheel)
        }
        
    }
}

struct EditProductView_Previews: PreviewProvider {
    static var previews: some View {
        EditProductView(product: Item(name: "Upholstered Lounge Chair Zuiver", vendor: "Lazy Sack", description: "Stay light-years ahead of the competition with our Aim Analog Watch. The flexible, rubberized strap is contoured to conform to the shape of your wrist for a comfortable all-day fit. The face features three illuminated hands, a digital read-out of the current time, and stopwatch functions.", pricePerDay: 10.0, itemImage: ["http://eimages.valtim.com/acme-images/product/m/g/mg03-br-0.jpg"]), whiteBtnTap: .constant(false))
    }
}
