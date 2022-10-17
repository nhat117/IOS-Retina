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


struct UploadItemView: View {
    let w: CGFloat = UIScreen.screenWidth
    let h: CGFloat = UIScreen.screenHeight
    @Binding var isPlusTap: Bool
    @Binding var imageIndex: Int
    @Binding var forwards: Bool
    var displayImages: [UIImage]
    //    @Binding var imageArr
    var body: some View {
        ZStack {
            if displayImages.count == 0 {
                Image(systemName: "plus")
                    .font(.system(size: h/5))
                    .frame(width: w, height: h/2.5)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: forwards ? .trailing : .leading),
                            removal: .move(edge: forwards ? .leading : .trailing)
                        )
                    ).onTapGesture {
                        if(displayImages.count < 5) {
                            isPlusTap.toggle()
                            
                        }
                    }
            } else  {
                ForEach(0..<displayImages.count) { i in
                    if (imageIndex == (displayImages.count)) {
                        //MARK: For adding image
                        Image(systemName: "plus")
                            .font(.system(size: h/5))
                            .frame(width: w, height: h/2.5)
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: forwards ? .trailing : .leading),
                                    removal: .move(edge: forwards ? .leading : .trailing)
                                )
                            ).onTapGesture {
                                if(displayImages.count < 5) {
                                    isPlusTap.toggle()
                                    
                                }
                            }
                        
                    } else {
                        //Mark: Display the image
                        
                        Image(uiImage: displayImages[imageIndex])
                            .centerCropped()
                            .frame(width: w, height: h/2.5)
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: forwards ? .trailing : .leading),
                                    removal: .move(edge: forwards ? .leading : .trailing)
                                )
                            )
                    }
                    
                    if imageIndex > 0 {
                        HStack {
                            ZStack {
                                Rectangle()
                                    .fill(.red)
                                    .opacity(0.00001)
                                    .frame(maxHeight: .infinity)
                                    .frame(width: w / 5)
                                
                                Image(systemName: "chevron.left.circle.fill")
                                    .font(Font.system(.largeTitle))
                                    .foregroundColor(.black.opacity(0.4))
                                    .padding()
                            }
                            .onTapGesture {
                                if imageIndex != displayImages.count {
                                    forwards = false
                                }
                                
                                withAnimation(.easeInOut) {
                                    imageIndex -= (imageIndex > 0) ? 1 : 0
                                }
                            }
                            
                            Spacer()
                        }
                        
                    }
                    
                    HStack(  spacing: 10 ){
                        ForEach(0...displayImages.count, id: \.self) { i in
                            Circle()
                                .frame(width: 9, height: 9)
                                .foregroundColor(i == imageIndex ? Color("Primary") : .black.opacity(0.2))
                            //                                             .overlay(Circle().stroke(.black, lineWidth: 0.5))
                                .shadow(radius: 1)
                            
                        }
                    }
                    .frame( maxWidth: .infinity,   maxHeight: .infinity , alignment:.bottom )
                    .padding()
                }
            }
            
            if imageIndex < displayImages.count {
                HStack {
                    Spacer()
                    
                    ZStack {
                        Rectangle()
                            .fill(.red)
                            .opacity(0.00001)
                            .frame(maxHeight: .infinity)
                            .frame(width: w / 5)
                        
                        Image(systemName: "chevron.right.circle.fill")
                            .font(Font.system(.largeTitle))
                            .foregroundColor(.black.opacity(0.4))
                            .padding()
                    }
                    .onTapGesture {
                        if imageIndex == 0 {
                            forwards = true
                        }
                        
                        withAnimation(.easeInOut) {
                            imageIndex += (imageIndex < displayImages.count) ? 1 : 0
                        }
                    }
                }
                .frame(width: .infinity, height: .infinity)
            }
        }
        
    }
}


struct UploadItemView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {screen in
            UploadItemView( isPlusTap: .constant(false), imageIndex: .constant(1), forwards: .constant(false), displayImages: [UIImage(imageLiteralResourceName: "Profile")])
        }
        
    }
}
