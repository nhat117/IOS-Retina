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

struct LeaseItemView: View {
    @State var imageIndex = 0
    @State private var forwards = false
    let viewName = "basket"
    let len = 4
    
    var body: some View {
        GeometryReader { screen in
            ZStack {
                ColorElement.ColorModifier.background()
                
                ScrollView {
                    VStack {
                        // Image slide
                        ZStack {
                            ForEach(0..<len, id: \.self) { i in
                                if i == imageIndex {
                                    Image("chair_\(imageIndex + 1)")
                                        .centerCropped()
                                        .frame(width: screen.size.width, height: screen.size.height/2.5)
                                        .transition(
                                            .asymmetric(
                                                insertion: .move(edge: forwards ? .trailing : .leading),
                                                removal: .move(edge: forwards ? .leading : .trailing)
                                            )
                                        )
                                    
                                }
                                HStack(  spacing: 10 ){
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
                            
                            if imageIndex > 0 {
                                HStack {
                                    ZStack {
                                        Rectangle()
                                            .fill(.red)
                                            .opacity(0.00001)
                                            .frame(maxHeight: .infinity)
                                            .frame(width: screen.size.width / 5)
                                        
                                        Image(systemName: "chevron.left.circle.fill")
                                            .font(Font.system(.largeTitle))
                                            .foregroundColor(.black.opacity(0.4))
                                            .padding()
                                    }
                                    .onTapGesture {
                                        if imageIndex != len {
                                            forwards = false
                                        }
                                        
                                        withAnimation(.easeInOut) {
                                            imageIndex -= (imageIndex > 0) ? 1 : 0
                                        }
                                    }
                                    
                                    Spacer()
                                }
                            }
                            
                            if imageIndex + 1 < len {
                                HStack {
                                    Spacer()
                                    
                                    ZStack {
                                        Rectangle()
                                            .fill(.red)
                                            .opacity(0.00001)
                                            .frame(maxHeight: .infinity)
                                            .frame(width: screen.size.width / 5)
                                        
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
                                            imageIndex += (imageIndex + 1 < len) ? 1 : 0
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Item info
                        VStack {
                            Text("Upholstered Lounge Chair Zuiver")
                                .font(.title3)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 3)
                            
                            Text("10$/hour")
                                .font(.title3).bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 3)
                            
                            Text("Lazy Sack")
                                .bold()
                                .foregroundColor(Color(red: 0.62, green: 0.3, blue: 0.3))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 3)
                            
                            Text("Stay light-years ahead of the competition with our Aim Analog Watch. The flexible, rubberized strap is contoured to conform to the shape of your wrist for a comfortable all-day fit. The face features three illuminated hands, a digital read-out of the current time, and stopwatch functions.")
                        }
                        .padding(screen.size.height / 50)
                        
                        // Lease info
                        VStack {
                            HStack {
                                Text("Rent date")
                                Spacer()
                                Text("September 19th")
                                    .bold()
                            }
                            .padding(.top, 10)
                            .padding(.horizontal)
                            
                            HStack {
                                Text("Return deadline")
                                Spacer()
                                Text("October 19th")
                                    .bold()
                            }
                            .padding(.top, 1)
                            .padding(.bottom, 10)
                            .padding(.horizontal)
                        }
                        .background(Color("Primary").opacity(0.15))
                        .padding(.horizontal, screen.size.height / 50)
                        
                        // Button
                        Button {
                            // TODO: Billie => return order
                        } label: {
                            PrimaryButton(title: "Return", fore: Color(.white), back: Color(.black))
                        }
                        .padding(screen.size.height / 50)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct LeaseItemView_Previews: PreviewProvider {
    static var previews: some View {
        LeaseItemView()
    }
}
