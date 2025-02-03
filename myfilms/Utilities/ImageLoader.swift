import Foundation
import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: Image?
    
    func loadImage(from url: String) {
        // Check cache first
        if let cachedImage = ImageCache.shared.getImage(forKey: url) {
            image = cachedImage
            return
        }
        
        // Load image from the URL
        guard let url = URL(string: url) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let uiImage = UIImage(data: data) else { return }
            let loadedImage = Image(uiImage: uiImage)
            ImageCache.shared.saveImage(loadedImage, forKey: url.absoluteString)
            
            DispatchQueue.main.async {
                self.image = loadedImage
            }
        }.resume()
    }
}

// Image cache for optimization
class ImageCache {
    static let shared = ImageCache()
    private var cache = [String: Image]()
    
    func getImage(forKey key: String) -> Image? {
        return cache[key]
    }
    
    func saveImage(_ image: Image, forKey key: String) {
        cache[key] = image
    }
}
