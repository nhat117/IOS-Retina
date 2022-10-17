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
 */


import FirebaseFirestoreSwift
import Foundation
import CoreLocation


enum ExpiredDateType: String, Codable, CaseIterable {
    case oneDay = "One Day"
    case oneWeek = "One Week"
    case twoWeek = "Two Week"
    case oneMonth = "One Month"
}

enum ItemStatus: Codable {
    case available, leasedInProgress
}

//Conditon post and after lend
struct ItemLendingInformation: Codable {
    var lendDate: Date?
    var dueDate: Date?
}

struct Item: Identifiable, Codable {
    var id: String?
    var publishDate: Date = Date()
    var name: String = ""
    var category: String = "All"
    var vendor: String = ""
    var itemTag: [String] = [""]
    var description: String = ""
    var pricePerDay: Double = 0
    var expireDayType: String = "3 Day"
    var lendingInfo: ItemLendingInformation? = nil
    var itemImage : [String] = ["chair_1.png"]
    
    
    var asDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
            guard let label = label else { return nil }
            return (label, value)
        }).compactMap { $0 })
        return dict
    }
}

struct Address: Codable {
    var long: Double = 0
    var lat: Double = 0
    var address: String = ""
}

struct User: Codable {
    @DocumentID var id: String?
    var email: String = ""
    var name: String = ""
    var phone: String = ""
    var address: Address  = Address(long: 0, lat: 0, address: "")
    var balance: Float = 0
    var avatarImage: String = ""
    var itemForLesse : [String?] = []
    //Considering place and for lease Item, User cannot rend and for lease item at the sametime
    var itemInRent: [String?] = []
    var chat: [String] = []
    
    init(){ 
        self.email = ""
        self.name = ""
        self.phone = ""
        self.address = Address(long: 0, lat: 0, address: "")
        self.balance = 0
        self.avatarImage = ""
        self.itemForLesse = []
        //Considering place and for lease Item, User cannot rend and for lease item at the sametime
        self.itemInRent = []
        self.chat = []
    }
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: CLLocationDegrees(address.long),
            longitude: CLLocationDegrees(address.lat)
        )
    }
}



