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


struct GalleryView: View {
    let images: [String]
    let w: CGFloat
    let h: CGFloat
    @Binding var imageIndex: Int
    @Binding var forwards: Bool
    var body: some View {
        let len = images.count
        
        ZStack {
            ForEach(0..<len, id: \.self) { i in
                if i == imageIndex {
                    KFImage( URL(string: images[imageIndex]))
                        .placeholder {
                            ProgressView()
                        }
                        .centerCropped()
                        .frame(width: w, height: h/2.5)
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: forwards ? .trailing : .leading),
                                removal: .move(edge: forwards ? .leading : .trailing)
                            )
                        )
                    
                }
                
                // Slide dots
                if (len > 1) {
                    HStack( spacing: 10 ){
                        ForEach(0..<len, id: \.self) { i in
                            Circle()
                                .frame(width: 9, height: 9)
                                .foregroundColor(i == imageIndex ? Color("Primary") : .black.opacity(0.2))
                                .shadow(radius: 1)
                            
                        }
                    }
                    .frame( maxWidth: .infinity,   maxHeight: .infinity , alignment:.bottom )
                    .padding()
                }
            }
            .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                .onEnded { value in
                    switch(value.translation.width, value.translation.height) {
                    case (...0, -30...30):
                        if imageIndex == 0 {
                            forwards = true
                        }
                        
                        withAnimation(.easeInOut) {
                            imageIndex += (imageIndex + 1 < len) ? 1 : 0
                        }
                    case (0..., -30...30):
                        if imageIndex != len {
                            forwards = false
                        }
                        
                        withAnimation(.easeInOut) {
                            imageIndex -= (imageIndex > 0) ? 1 : 0
                        }
                    default:  print("no clue")
                    }
                }
            )
            
        }
    }
}


struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { screen in
            GalleryView(images: ["chair_1.png", "chair_2.png", "chair_3.png", "chair_4.png"], w: screen.size.width, h: screen.size.height, imageIndex: .constant(1), forwards: .constant(false))
        }
        
    }
}
