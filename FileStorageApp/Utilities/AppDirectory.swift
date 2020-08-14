//
//  AppDirectory.swift
//  FileStorageApp
//
//  Created by Christopher Evans on 8/7/20.
//  Copyright © 2020 Morphosis Games. All rights reserved.
//

import Foundation

public class AppFileHelper {
    
    public static func getDocumentPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
    
    public static func getDocument() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    public static func getTemporaryPath() -> String {
        return NSTemporaryDirectory()
    }
    
    public static func getTemporary() -> URL {
        return FileManager.default.temporaryDirectory
    }

    public static func getCachesPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    }
    
    public static func getCaches() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    public static func urlFor(fileNameInTempDirectory: String) -> URL? {
        let tempDirURL = self.getTemporary()
        return tempDirURL.appendingPathComponent(fileNameInTempDirectory)
    }
    
    public static func fileSize(atURL url: URL) -> UInt64? {
        let attributesOfItem = try? FileManager.default.attributesOfItem(atPath: url.path)
        let sourceLength = (attributesOfItem as NSDictionary?)?.fileSize()
        
        return sourceLength
    }
    
    public static func createFolder(at: URL, name: String? = nil) throws {
        let folder = name ?? UUID().uuidString // If we do not have a name then lets create a unique name for it
        let path = at.appendingPathComponent(folder)
        
        do {
            try FileManager.default.createDirectory(at: path, withIntermediateDirectories: false, attributes: [:])
        } catch {
            stop("Had and error creating folder: \(error).")
            throw error
        }
    }
    
    public static func save(text: String, to: URL) throws {
        do {
            try text.write(to: to, atomically: true, encoding: .utf8)
        } catch {
            stop("Could NOT write file?!")
            throw error
        }
    }
}
