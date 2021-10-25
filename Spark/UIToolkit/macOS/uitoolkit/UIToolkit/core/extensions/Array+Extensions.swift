//
//  Array+Extensions.swift
//  UIToolkit
//
//  Created by James Nestor on 04/06/2021.
//

import Cocoa

extension Array {
    public func hasIndex(_ index: Int) -> Bool {
        return !isEmpty && index >= 0 && index < count
    }
    
    ///Bounds checks the index before returning the element
    ///If item is out of bounds returns nil
    public func getItemAtIndex(_ index: Int) -> Element?{
        if hasIndex(index){
            return self[index]
        }
        return nil
    }
    
    public func chunked(size: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, self.count)])
        }
    }
}

extension Array where Element: Hashable {
    // The array with any duplicate items removed
    public var duplicatesRemoved: [Element] {
        var uniqueArray = [Element]()
        var added = Set<Element>()

        for element in self {
            if added.insert(element).inserted {
                uniqueArray.append(element)
            }
        }
        return uniqueArray
    }
}

