//
//  ProfileImageProtocol.swift
//  GymBro
//
//  Created by macbook on 13/02/2026.
//
import UIKit

protocol ProfileImageProtocol {
    
    func saveImage(image: UIImage) throws -> String
    func loadImage(path: String) -> UIImage?
    func deleteImage(path: String) throws
}

enum ImageStorageError: Error {
    case preparationFailed
}
