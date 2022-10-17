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

class OneItemViewModel: ObservableObject {
    
    @Published var item: Item
    @Published var modified = false
    
    
    private var cancellables = Set<AnyCancellable>()
    let dataManager = DataManager.commonDataManager
    init(item: Item = Item()) {
        self.item = item
        
        self.$item
            .dropFirst()
            .sink { [weak self] item in
                self?.modified = true
            }
            .store(in: &self.cancellables)
    }
    
    // UI handlers
    
    private func updateOrAddItem() {
        if let _ = item.id {
            dataManager.updateItem(self.item)
        }
        else {
            dataManager.addItem(self.item)
        }
    }
    
    func handleDoneTapped() {
        self.updateOrAddItem()
    }
    
    func handleDeleteTapped() {
        dataManager.removeItem(self.item)
    }
    
}
