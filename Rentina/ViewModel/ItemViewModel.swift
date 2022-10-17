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
import Combine
import FirebaseFirestore

class ItemsViewModel: ObservableObject {
    
    @Published var items = [Item]()
    
    @Published var asyncItem : Item = Item()
    
    @Published var itemsLatest = [Item]()
    
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    deinit {
        unsubscribe()
    }
    
    func unsubscribe() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    func subscribe() {
        listenerRegistration = db.collection("products").order(by: "publishDate", descending: true).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.items = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: Item.self)
            }
        }
        
    }
    
    
    func subscribe_tag(itemTag: String) {
        
        if itemTag.lowercased() == "" {
            listenerRegistration = db.collection("products").order(by: "publishDate", descending: true).addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.items = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Item.self)
                }
                
            }
        }
        else {
            listenerRegistration = db.collection("products").whereField("itemTag", arrayContains: itemTag).addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.items = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Item.self)
                }
                print(self.items)
                
            }
            
        }
    }
    
    func subscribe_category(category: String) {
        
        listenerRegistration = db.collection("products").whereField("category", isEqualTo: category).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.items = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: Item.self)
            }
            
            print("Search \(self.items)")
            
        }
    }
    
    func subscribe_latest() {
        listenerRegistration = db.collectionGroup("products").order(by: "timestamp").limit(to: 5).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.itemsLatest = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: Item.self)
            }
        }
        
    }
    
    func fetchVendorItems(vendorId: String) {
        listenerRegistration = db.collection("products").whereField("vendor", isEqualTo: vendorId).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.items = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: Item.self)
            }
        }
    }
    
    func fetchTagItems(tag: String) {
        if listenerRegistration != nil {
            listenerRegistration = db.collection("products").whereField("itemTag", arrayContains: tag).addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.items = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Item.self)
                }
            }
        }
    }
    
    func getItem(itemId: String){
        //        var item: Item?
        
        let docRef = db.collection("products").document(itemId)
        docRef.getDocument(as: Item.self) { result  in
            switch result {
            case .success(let resItem):
                self.asyncItem = resItem
            case .failure(let error):
                //                item = nil
                print("Error decoding products: \(error)")
            }
        }
        
        //        return item
    }
    
    func removeItems(atOffsets indexSet: IndexSet) {
        let items = indexSet.lazy.map { _ in self.items[0] }
        items.forEach { item in
            if let documentId = item.id {
                db.collection("products").document(documentId).delete { error in
                    if let error = error {
                        print("Unable to remove document: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
}
