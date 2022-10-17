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
 */

import Foundation
import CoreML
import UIKit

class MLHelper: ObservableObject {
    //Singleton Design pattern
    static let mlHelper = MLHelper()
    
    private init() {
        
    }
    
    let model = MobileNetV2()
    @Published var predictCategory : String = ""
    
    func classifyImage(inputImage: UIImage) {
        guard let resizedImage = inputImage.resizeImg(size: CGSize(width: 224, height: 224)),
              let buff = resizedImage.bufferConverter() else {
            fatalError("Cannot converting image")
        }
        
        let output = try? model.prediction(image: buff)
        
        if let output = output {
            //Determine the result of the model
            let results = output.classLabelProbs.sorted { $0.1 > $1.1 }
            var arr: [String] = []
            //Processing the return result
            let result = results.map { (key, value) in
                arr.append("\(key)")
            }
            predictCategory = arr.first!
        }
    }
}
