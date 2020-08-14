//
//  AppDirectory.swift
//  FileStorageApp
//
//  Created by Christopher Evans on 8/7/20.
//  Copyright © 2020 Morphosis Games. All rights reserved.
//

import Foundation

/**
 Make it a little easier when working with files.
 */
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
    
    /// Will create a folder based on the named passed into it. This is more of an example of how to do this
    /// If you do not pass in a name it will create a random name
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
    
    /// Will create a file based on the passed in string. This is more of an example of how to do this
    /// If you do not pass in a name it will create a random name
    public static func createFileWith(text: String, at: URL, name: String? = nil) throws {
        let file = name ?? UUID().uuidString // If we do not have a name then lets create a unique name for it
        let path = at.appendingPathComponent(file)
        
        do {
            try text.write(to: path, atomically: true, encoding: .utf8)
        } catch {
            stop("Could NOT write file?!")
            throw error
        }
    }
}
