//
//  ProfileImageService.swift
//  GymBro
//
//  Created by macbook on 13/02/2026.
//
import UIKit

final class ProfileImageService: ProfileImageProtocol {
    
    init() {}
    
    func deleteImage(path: String) throws {
        try FileManager.default.removeItem(atPath: path)
    }
    
    func saveImage(image: UIImage) throws -> String {
        guard let data = prepareImage(image) else {
            throw ImageStorageError.preparationFailed
        }
        let url = try saveToDisk(data)
        return url.path
    }
    
    func loadImage(path: String) -> UIImage? {
        UIImage(contentsOfFile: path)
    }
}

private extension ProfileImageService {
    
    func prepareImage(_ image: UIImage) -> Data? {
        let size = CGSize(width: 512, height: 512)
        let renderer = UIGraphicsImageRenderer(size: size)
        let resized = renderer.image{_ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        return resized.jpegData(compressionQuality: 0.8)
    }
    
    func saveToDisk(_ data: Data) throws -> URL {
        let url = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(UUID().uuidString + ".jpg")
        
        try data.write(to: url, options: [.atomic, .completeFileProtection])
        
        return url
    }
}
