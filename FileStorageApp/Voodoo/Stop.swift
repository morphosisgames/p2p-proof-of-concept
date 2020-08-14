//
//  Stop.swift
//  FileStorageApp
//
//  Created by Christopher Evans on 8/7/20.
//  Copyright © 2020 Morphosis Games. All rights reserved.
//

import Foundation

/// This will cause Xcode to create a breakpoint in this function, when called in debug mode.
/// I use this for code, that should not happen but does.
public func stop(_ message: @autoclosure () -> String? = nil) {
    #if DEBUG
    print("Stopped: \(message() ?? "")")
    raise(SIGTRAP)
    #else
    print("Asked to Stop but not in debug mode!  Message: \(message() ?? "NA")")
    #endif
}

/// This will cause Xcode to create a breakpoint in this function, when called in debug mode.
/// I use this for code that I want to crash, this lets me debug the app before it crashes.
public func fatalStop(_ message: @autoclosure () -> String? = nil) -> Never {
    #if DEBUG
    print("Stopped: \(message() ?? "")")
    raise(SIGTRAP)
    fatalError("After Stop!  Message: \(message() ?? "")")
    #else
    fatalError("FatalStop Not Debug.  Message: \(message() ?? "")")
    #endif
}
