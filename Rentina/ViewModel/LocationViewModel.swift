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

import SwiftUI
import SwiftUI
import MapKit
class LocationManager : ObservableObject {
    //Converting location and address of user and retrieve long lat coordinate
    @Published var location : CLLocationCoordinate2D = CLLocationCoordinate2D(
        latitude: CLLocationDegrees(10.8301474),
        longitude: CLLocationDegrees(106.7229644)
    )
    @Published var index : Int = 0
    
    func convertAddress(address: String) {
        getCoordinate(addressString: address) { (location, error) in
            if error != nil {
                //handle error
                return
            }
            DispatchQueue.main.async {
                self.location = location
                self.index += 1
            }
        }
    }
    
    private func getCoordinate(addressString : String,
                               completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
} 
