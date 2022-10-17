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
 */

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import SwiftUI
import MapKit


class DataManager : ObservableObject {
    //Create data manager as a singleton class
    //Ignore the error in this file. It can still be compiled
    
    static let commonDataManager = DataManager()
    @Published var user: User = User.init()
    @Published var currentVendor: User = User.init()
    @Published var imgArr: [String] = []
    @Published var image: String = ""
    @Published var count: Int = 0
    private var itemViewModel = ItemsViewModel()
    let storage = Storage.storage()
    var db: Firestore!
    
    private init() {
        //Initial firestore setup
        db = Firestore.firestore()
    }
    
    
    //CRUD operation methods
    public func createUser(user: User) {
        let userTemp: User = user
        do {
            try db.collection("users").document(user.email).setData(from: userTemp)
        } catch let error {
            print("Error writing user to Firestore: \(error)")
        }
    }
    
    
    //    dataManager.db.collection("conversations").document().setData(from: newConversation)
    
    public func updateUser(user: User) {
        if let documentId = user.id {
            do {
                try db.collection("users").document(documentId).setData(from: user)
            }
            catch {
                print(error)
                return
            }
        }
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
    
    public func getVendorByEmail(email: String) {
        let docRef = db.collection("users").document(email)
        
        docRef.getDocument { (document, error) in
            guard error == nil else {
                print("error", error ?? "")
                return
            }
            
            if let document = document, document.exists {
                do {
                    try self.currentVendor = document.data(as: User.self)
                } catch let error {
                    print("Error writing user to Firestore: \(error)")
                }
            }
        }
    }
    
    //Get the distance
    func getDistance() -> Double {
        let original = user.locationCoordinate
        let destination = currentVendor.locationCoordinate
        let from = CLLocation(latitude: original.latitude, longitude: original.longitude)
        let to = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        return Double(from.distance(from: to))/1000
    }
    
    
    //Fill database with data
    public func loadDummyData() {
        let names = ["Aim Analog Watch",
                     "Endurance Watch",
                     "Summit Watch",
                     "Cruise Dual Analog Watch",
                     "Upholstered Lounge Chair Zuiver Lazy Sack",
                     "Modern Wooden Desk Steady",
                     "Black Swing Arm Wall Lamp Dutchbone Hector",
                     "Vintage Style Outdoor Carpet Zuiver Coventry",
                     "Industrial Standard Bookcase Eleonora Heidi",
                     "Hamilton Beach Stainless Steel Countertop Microwave Oven"]
        let categories = ["Electronics", "Electronics", "Electronics", "Electronics", "Electronics",
                          "Furniture", "Furniture", "Furniture", "Furniture", "Kitchen"]
        let descriptions = ["Stay light-years ahead of the competition with our Aim Analog Watch. The flexible, rubberized strap is contoured to conform to the shape of your wrist for a comfortable all-day fit. The face features three illuminated hands, a digital read-out of the current time, and stopwatch functions.",
                            "It's easy to track and monitor your training progress with the Endurance Watch. You'll see standard info like time, date and day of the week, but it also functions for the serious high-mileage athete: lap counter, stopwatch, distance, heart rate, speed/pace, cadence and altitude.",
                            "Trek high and low in the attractive Summit Watch, which features a digital LED display with time and date, stopwatch, lap counter, and 3-second backlight. It can also calculate the number of steps taken and calories burned.",
                            "Whether you're traveling or wish you were, you'll never let time zones perplex you again with the Cruise Dual Analog Watch. The thick, adjustable band promises a comfortable, personalized fit to this classy, modern time piece.",
                            "Lounge chair Lazy Sack by Zuiver is a seat you’ll want to claim for your own! All that gorgeous comfort with oversized cushions in soft comfortable fabric. The ideal chair to sink into after a long day. Want to relax even more? Combine this seater with the matching footstool Lazy Sack hocker and put your feet up!",
                            "Desk Steady by LABEL51 is very trendy the playful and functional desk which makes work and studying become fun again! Desk Steady combines all the functions of a home office in an eye-catching design.",
                            "Hector wall lamp certainly makes a statement. Not only in size, but also in class. This long-armed lighting fixture can be hung anywhere you like. At home next to the dining table or in a restaurant to add romantic light during a dinner for two. Hector is available in black and in teal, a colour that fits the Dutchbone collection like a glove.",
                            "With our Coventry rug, we give you a number of choices. Whether you use it indoors or outdoors, it's up to you. Whether you choose the round version or the rectangular version, is also: up to you. What's not up to you is the amount of style Coventry adds to your space. That's on this weatherproof rug. We are happy to convert gardens and terraces into fully-fledged additional living spaces. With Coventry, we enable you to furnish your outdoor space with the same dedication you give to your interior.",
                            "This stylish versatile Industrial Standard bookcase by Eleonora, featuring three spacious shelves that let you show off framed photos, artful accents, your favorite novels, and any other items that make you smile. Two cabinet doors below open to reveal concealed storage space, so you can store your valuables in a safe place.",
                            "Sharp design in stainless steel, this microwave oven fits your modern kitchen and offers a variety of menu choices to complete your cooking tastes and style. It has an output of 900 watts and includes 10 power levels. The LED display is simple to read, and the touch-pad makes it easy to control. This 900 watt microwave oven includes a lockout feature for child safety, as well as a timer and clock feature. It allows you to cook potatoes, popcorn, reheat frozen dinners, pizza or beverages with just one touch. It's designed to give you even heating for consistent results that you can feel good about feeding to your family."]
        let vendors = ["van.thanh@gmail.com", "van.thanh@gmail.com", "van.thanh@gmail.com", "billiemo@gmail.com", "billiemo@gmail.com", "van.thanh@gmail.com", "s123123@rmit.edu.vn", "s123123@rmit.edu.vn", "s123123@rmit.edu.vn", "billiemo@gmail.com"]
        let prices = [10.0, 20.0, 30.0, 40.0, 15.0, 25.0, 35.0, 45.0, 12.0, 18.0]
        let images = [["http://eimages.valtim.com/acme-images/product/m/g/mg04-bk-0.jpg"],
                      ["http://eimages.valtim.com/acme-images/product/m/g/mg01-bk-0.jpg"],
                      ["http://eimages.valtim.com/acme-images/product/m/g/mg01-bk-0.jpg"],
                      ["http://eimages.valtim.com/acme-images/product/m/g/mg03-br-0.jpg"],
                      ["https://cdn.shopify.com/s/files/1/0270/0908/9645/products/ZUI3100083.1_1000x.png?v=1646134801", "https://cdn.shopify.com/s/files/1/0270/0908/9645/products/ZUI3100083.2_1000x.png?v=1646134801", "https://cdn.shopify.com/s/files/1/0270/0908/9645/products/ZUI3100083.4_1000x.png?v=1646134801"],
                      ["https://cdn.shopify.com/s/files/1/0270/0908/9645/products/LABRF-37.096_3_1000x.png?v=1634564323", "https://cdn.shopify.com/s/files/1/0270/0908/9645/products/LABRF-37.096_4_1000x.png?v=1634564322", "https://cdn.shopify.com/s/files/1/0270/0908/9645/products/LABRF-37.096_5_1000x.png?v=1634564321", "https://cdn.shopify.com/s/files/1/0270/0908/9645/products/LABRF-37.096_1_1_1000x.png?v=1634564321"],
                      ["https://cdn.shopify.com/s/files/1/0270/0908/9645/products/DUB5400031_1_1000x.png?v=1639061613", "https://cdn.shopify.com/s/files/1/0270/0908/9645/products/DUB5400031_2_1000x.jpg?v=1639061611", "https://cdn.shopify.com/s/files/1/0270/0908/9645/products/DUB5400031_3_1000x.jpg?v=1639061612"],
                      ["https://cdn.shopify.com/s/files/1/0270/0908/9645/products/ZUI6200005_1_1000x.png?v=1649687473", "https://cdn.shopify.com/s/files/1/0270/0908/9645/products/ZUI6200005_6_1000x.png?v=1649687473", "https://cdn.shopify.com/s/files/1/0270/0908/9645/products/ZUI6200005_9_1000x.png?v=1649687473"],
                      ["https://cdn.shopify.com/s/files/1/0270/0908/9645/products/ELE22528_6553cc18-b614-46d6-abaf-4572cbc4a820_1000x.png?v=1632942219", "https://cdn.shopify.com/s/files/1/0270/0908/9645/products/ELE22528_2_1000x.png?v=1632942236", "https://cdn.shopify.com/s/files/1/0270/0908/9645/products/ele22528_1000x.png?v=1632942244"],
                      ["https://i5.walmartimages.com/asr/18652377-1a34-4154-925a-a51569ddee61_2.5da704269c4cbb2f250339ff59da724d.jpeg?odnHeight=612&odnWidth=612&odnBg=FFFFFF", "https://i5.walmartimages.com/asr/830c8d5e-e6f1-4bc6-b1a3-534d5e99b450_2.a84049aa609b30f9d152e3d25c414a8a.jpeg?odnHeight=612&odnWidth=612&odnBg=FFFFFF", "https://i5.walmartimages.com/asr/a6bd7829-72ae-438d-8f92-80c4fb523f5d_1.0ca33c84527b5221aa9b2a658c7c5672.jpeg?odnHeight=612&odnWidth=612&odnBg=FFFFFF"]]
        let expireDateTypes = [ExpiredDateType.oneDay, ExpiredDateType.oneWeek, ExpiredDateType.twoWeek, ExpiredDateType.oneMonth,
                               ExpiredDateType.twoWeek,
                               ExpiredDateType.oneMonth,
                               ExpiredDateType.oneDay,
                               ExpiredDateType.twoWeek,
                               ExpiredDateType.oneWeek,
                               ExpiredDateType.oneMonth]
        
        let itemTag = [["aim", "analog", "watch"],
                       [ "endurance","watch"],
                       ["summit","watch"],
                       ["cruise","dual","analog","watch"],
                       ["upholstered","lounge","chair","zuiver","lazy","sack"],
                       ["modern","wooden","desk","steady"],
                       ["black","swing","arm","wall","lamp","dutchbone","hector"],
                       ["vintage","style","outdoor","carpet","zuiver","coventry"],
                       ["industrial","standard","bookcase","eleonora","heidi"],
                       ["hamilton","beach","stainless","steel","countertop","microwave","oven"]]
        
        for (i, e) in names.enumerated() {
            let item = Item(name: e,
                            category: categories[i],
                            vendor: vendors[i],
                            itemTag: itemTag[i], description: descriptions[i],
                            pricePerDay: prices[i],
                            expireDayType: expireDateTypes[i].rawValue,
                            itemImage: images[i]
            )
            
            addItemHaveId(item)
        }
    }
    
    //MARK: Data manager part for item
    //Ignor error in this file, it can still be compiled
    
    public func addItem(_ item: Item) {
        do {
            let _ = try db.collection("products").addDocument(from: item)
        }
        catch {
            print(error)
        }
    }
    
    public func addItemHaveId(_ item: Item) -> Item? {
        do {
            let testRef = self.db.collection("products")
            let doc = testRef.document()
            var tmpItem = item
            tmpItem.id = doc.documentID
            doc.setData(tmpItem.asDictionary)
            print(tmpItem.asDictionary)
            return tmpItem
        }
        catch {
            fatalError("Cannot write data to database")
        }
        return nil
    }
    
    public func updateItem(_ item: Item) {
        if let documentId = item.id {
            do {
                try db.collection("products").document(documentId).setData(from: item)
            }
            catch {
                print(error)
            }
        }
    }
    
    
    
    
    
    public func removeItem(_ item: Item) {
        if let documentId = item.id {
            db.collection("products").document(documentId).delete { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    //Hacking function upload image
    func uploadImages(_ images : [UIImage], product: Item) {
        
        self.count = images.count
        var i = 0
        self.imgArr = []
    
        for image in images {
            let uuid = UUID().uuidString
            let path = "\(product.vendor)_\(product.name)_\(i)_\(uuid)"
            uploadImage(image, name: path)
            i += 1
        }
    }
    
    func uploadImage(_ image: UIImage, name: String) {
        let imageName:String = String("\(name).jpeg")
        let storageRef = Storage.storage().reference().child(imageName)
        guard let data = image.jpegData(compressionQuality: 1) else {
            fatalError("Unable to compress jpeg image")
        }
        //Declare file metadata
        let newMetadata = StorageMetadata()
        newMetadata.cacheControl = "public,max-age=300"
        newMetadata.contentType = "image/jpeg"
        
        storageRef.putData(data, metadata: newMetadata
                           , completion: { (metadata, error) in
            if error != nil {
                print("error \(error?.localizedDescription)")
                return
            }
            
            storageRef.downloadURL{ url, error in
                if let error = error {
                    fatalError(error.localizedDescription)
                } else {
                    let res =  url?.absoluteString
                    if let res = res {
                        self.imgArr.append(res)
                    }
                    self.count -= 1
                }
                
            }
        })
        
    }
    
    func downloadImage(path: String) {
        
        Storage.storage().reference().child("\(path).jpeg").downloadURL { url, error in
            if let error = error {
                fatalError(error.localizedDescription)
            } else {
                guard let res =  url?.absoluteString else {
                    fatalError("Cannot load URL")
                }
                self.image = res
                
                
            }
        }
    }
}
