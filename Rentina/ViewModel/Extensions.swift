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
 https://swiftwombat.com/tag/swiftui/
 https://github.com/onevcat/Kingfisher
 https://developer.apple.com/documentation/coreml
 https://arxiv.org/abs/1801.04381
 https://firebase.google.com/docs/ios/setup
 */
import SwiftUI
import Kingfisher

func isObjectNotNil(object:AnyObject!) -> Bool
{
    if let _:AnyObject = object
    {
        return true
    }
    
    return false
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension View{
    func makeNavigationPrettier(viewName : String, mode:Binding<PresentationMode>) -> some View {
        self
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button {  mode.wrappedValue.dismiss() } label: {
                Image(systemName: "arrow.backward")
                
            }.foregroundColor(.black))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { // <2>
                ToolbarItem(placement: .principal) { // <3>
                    Text(viewName.capitalizingFirstLetter()).font(.title)
                }
            }
    }
    func addCustomBackButton( mode:Binding<PresentationMode>) -> some View {
        self
            .navigationBarBackButtonHidden(true)
        // Custom back button here
            .navigationBarItems(leading:
                                    Button {mode.wrappedValue.dismiss()} label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
                    .padding(10)
                    .background(.white)
                    .cornerRadius(50)
                    .shadow(color: .black, radius: 3)
                
            }
            )
    }
}
// Extension for adding rounded corners to specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

// Custom RoundedCorner shape used for cornerRadius extension above
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

//Custom formatting Date
extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

extension KFImage {
    func centerCropped() -> some View {
        GeometryReader { screen in
            self
                .resizable()
                .scaledToFill()
                .frame(width: screen.size.width, height: screen.size.height)
            //                .frame(width: w, height: h/2.5)
                .clipped()
        }
    }
}

extension Image {
    func centerCropped() -> some View {
        GeometryReader { screen in
            self
                .resizable()
                .scaledToFill()
                .frame(width: screen.size.width, height: screen.size.height)
                .clipped()
        }
    }
}
extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}

//Handling machine learning resize image

extension UIImage {
    
    func resizeImg(size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resImage
    }
    
    func bufferConverter() -> CVPixelBuffer? {
        
        let attr = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ] as CFDictionary
        
        var buff: CVPixelBuffer?
        
        let stat = CVPixelBufferCreate(
            kCFAllocatorDefault, Int(self.size.width),
            Int(self.size.height),
            kCVPixelFormatType_32ARGB,
            attr,
            &buff)
        
        guard (stat == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(buff!, CVPixelBufferLockFlags(rawValue: 0))
        
        let pixelData = CVPixelBufferGetBaseAddress(buff!)
        let rgb = CGColorSpaceCreateDeviceRGB()
        
        let context = CGContext(
            data: pixelData,
            width: Int(self.size.width),
            height: Int(self.size.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buff!),
            space: rgb,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        UIGraphicsPopContext()
        
        CVPixelBufferUnlockBaseAddress(buff!, CVPixelBufferLockFlags(rawValue: 0))
        
        return buff
    }
    
}

extension Array where Element: Hashable {
    func deDuplicates() -> [Element] {
        var inputDict = [Element: Bool]()
        
        return filter {
            inputDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func deDuplicates() {
        self = self.deDuplicates()
    }
}


