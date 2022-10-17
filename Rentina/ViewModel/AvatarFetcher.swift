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

//Fetching avatar data
import Foundation
import Firebase
import FirebaseFirestore
class AvatarFetcher: ObservableObject {
    static let avtFetcher : AvatarFetcher = AvatarFetcher()
    @Published var user: User = User.init()
    //    
    var db: Firestore!
    
    private init() {
        //Initial firestore setup
        db = Firestore.firestore()
    }
    
    
    public func getUserByEmail(email: String) {
        let docRef = db.collection("users").document(email)
        
        docRef.getDocument { (document, error) in
            guard error == nil else {
                print("error", error ?? "")
                return
            }
            
            if let document = document, document.exists {
                do {
                    try self.user = document.data(as: User.self)
                } catch let error {
                    print("Error writing user to Firestore: \(error)")
                }
            }
        }
    }
}
