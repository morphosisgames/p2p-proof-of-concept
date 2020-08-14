//
//  Directory.swift
//  FileStorageApp
//
//  Created by Christopher Evans on 8/7/20.
//  Copyright © 2020 Morphosis Games. All rights reserved.
//

import Foundation


/**
 This is a basic Directory scanner, it is meant for simple file and folder management.
 */
public class Directory {
    
    public let at: URL
    
    public let entries: [Entry];
    
    /// Pass in the directory URL to use
    public init(at: URL) throws {
        self.at = at
        self.entries = try Directory.scanDirectoryRoot(at: at)
    }
    
    public static func scanDirectoryRoot(at: URL) throws -> [Entry] {
        var items: [Entry] = []
        
        do {
            let keys: [URLResourceKey] = [
                .isDirectoryKey,
                .isRegularFileKey,
                .parentDirectoryURLKey
            ]
            
            let mask: FileManager.DirectoryEnumerationOptions = [
                .skipsHiddenFiles,
                .skipsPackageDescendants,
                .skipsSubdirectoryDescendants
            ]
            
            let urls = try FileManager.default.contentsOfDirectory(at: at, includingPropertiesForKeys: keys, options: mask)
            
            items = urls.map { Entry(url: $0) }
            
        } catch {
            stop("Had error trying to scan folder: \(error)")
            throw error
        }
        
        return items
    }
}

public extension Directory {
    
    /// Holds quick access information about the entries in the Directory
    struct Entry {
        public var url: URL
        
        public var isFolder: Bool { self.url.hasDirectoryPath }
        public var name: String { self.url.lastPathComponent }
    }
}
