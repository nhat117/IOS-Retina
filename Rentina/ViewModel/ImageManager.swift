import SwiftUI
import Firebase
import Combine
import FirebaseStorage

public class StorageManager: ObservableObject {
    let storage = Storage.storage()

    func upload(image: UIImage) {
        // Create a storage reference
        let storageRef = storage.reference().child("images/image.jpg")

        // Resize the image to 200px with a custom extension
        let resizedImage = image.aspectFittedToHeight(200)

        // Convert the image into JPEG and compress the quality to reduce its size
        let data = resizedImage.jpegData(compressionQuality: 0.2)

        // Change the content type to jpg. If you don't, it'll be saved as application/octet-stream type
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"

        // Upload the image
        if let data = data {
            storageRef.putData(data, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error while uploading file: ", error)
                }

                if let metadata = metadata {
                    print("Metadata: ", metadata)
                }
            }
        }
    }

    func listAllFiles() {
        // Create a reference
        let storageRef = storage.reference().child("images")

        // List all items in the images folder
        storageRef.listAll { (result, error) in
          if let error = error {
            print("Error while listing all files: ", error)
          }

          for item in result.items {
            print("Item in images folder: ", item)
          }
        }
    }

    func listItem() {
        // Create a reference
        let storageRef = storage.reference().child("images")

        // Create a completion handler - aka what the function should do after it listed all the items
        let handler: (StorageListResult, Error?) -> Void = { (result, error) in
            if let error = error {
                print("error", error)
            }

            let item = result.items
            print("item: ", item)
        }

        // List the items
        storageRef.list(maxResults: 1, completion: handler)
    }

		// You can use the listItem() function above to get the StorageReference of the item you want to delete
    func deleteItem(item: StorageReference) {
        item.delete { error in
            if let error = error {
                print("Error deleting item", error)
            }
        }
    }
}


// FirebaseImage(id: 'sdfsdf').resizable()
struct FirebaseImage : View {

    init(id: String) {
        self.imageLoader = Loader(id)
    }

    @ObjectBinding private var imageLoader : Loader

    var image: UIImage? {
        imageLoader.data.flatMap(UIImage.init)
    }

    var body: some View {
        Image(uiImage: image ?? placeholder)

    }
}

let placeholder = UIImage(named: "placeholder.jpg")!

struct FirebaseImage : View {

    init(id: String) {
        self.imageLoader = Loader(id)
    }

    @ObjectBinding private var imageLoader : Loader

    var image: UIImage? {
        imageLoader.data.flatMap(UIImage.init)
    }

    var body: some View {
        Image(uiImage: image ?? placeholder)
    }
}

final class Loader : BindableObject {
    let didChange = PassthroughSubject<Data?, Never>()
    var data: Data? = nil {
        didSet { didChange.send(data) }
    }

    init(_ id: String){
        // the path to the image
        let url = "images/\(id)"
        let storage = Storage.storage()
        let ref = storage.reference().child(url)
        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("\(error)")
            }

            DispatchQueue.main.async {
                self.data = data
            }
        }
    }
}