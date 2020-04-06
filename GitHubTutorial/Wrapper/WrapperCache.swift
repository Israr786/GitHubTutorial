//
//  WrapperCache.swift
//  GitHubTutorial
//
//  Created by Israrul on 3/31/20.
//  Copyright © 2020 Israrul Haque. All rights reserved.
//

import Foundation


class WrappedCache<Key, Value> where Key: AnyObject, Value: AnyObject {
    
    let cache = NSCache<Key, Value>()
    
    subscript(key: Key) -> Value? {
        get {
            return cache.object(forKey: key)
        }
        set {
            if let newValue = newValue {
                cache.setObject(newValue, forKey: key)
            }
            else {
                cache.removeObject(forKey: key)
            }
        }
    }
}
