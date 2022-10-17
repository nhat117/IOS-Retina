//
//  Modal.swift
//  Rentina
//
//  Created by Phuc Nguyen Phuoc Nhu on 12/09/2022.
//

import SwiftUI

struct Modal: View {
    let image: String
    let title: String
    let screenWidth: CGFloat
    let screenHeight: CGFloat

    var body: some View {
        ZStack {
            ColorElement.ColorModifier.background()

            VStack {

                Text("Confirm Rental Order")

                HStack {
                    Image("chair_1")
                        .centerCropped()
                        .frame(width: screenWidth / 5, height: screenHeight / 10)
                }

                HStack {
                    Button {
//                        isModalShown.toggle()
                    } label: {
                        PrimaryButton(title: "Cancel", fore: Color(.black), back: Color(.white))
                            .border(.black, width: 2)
                            .padding(.vertical, 10)
                    }

                    Button {

                    } label: {
                        PrimaryButton(title: "Confirm", fore: Color(.white), back: Color(.black))
                            .padding(.vertical, 10)
                    }
                }
            }
            .padding()
        }
        .frame(width: screenWidth / 1.2, height: screenHeight / 3)
        .border(.black, width: 2)
    }
}

//struct Modal_Previews: PreviewProvider {
//    static var previews: some View {
//        Modal()
//    }
//}
