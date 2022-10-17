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
import MapKit

struct MyAnnotationItem: Identifiable {
    var coordinate: CLLocationCoordinate2D
    let id = UUID()
}

struct MapView: View {
    @State var long: Double
    @State var lat: Double
    
    @State private var region = MKCoordinateRegion()
    
    var body: some View {
        Map(coordinateRegion: $region,
            interactionModes: .all,
            showsUserLocation: true,
            annotationItems: [
                MyAnnotationItem(coordinate: getCoordinate(long: long, lat: lat))]) { item in
                    MapMarker(coordinate: item.coordinate)
                }
                .onAppear {
                    setRegion(getCoordinate(long: long, lat: lat))
                    
                }
    }
    func getCoordinate(long:Double, lat: Double) -> CLLocationCoordinate2D{
        return CLLocationCoordinate2D(
            latitude: CLLocationDegrees(lat),
            longitude: CLLocationDegrees(long)
        )
        
    }
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
        )
    }
}
