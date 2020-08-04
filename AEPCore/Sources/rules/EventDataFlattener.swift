/*
 Copyright 2020 Adobe. All rights reserved.
 This file is licensed to you under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License. You may obtain a copy
 of the License at http://www.apache.org/licenses/LICENSE-2.0
 Unless required by applicable law or agreed to in writing, software distributed under
 the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
 OF ANY KIND, either express or implied. See the License for the specific language
 governing permissions and limitations under the License.
 */

import Foundation

/// Provides functions to "flatten"  an`EventData` dictionary.
class EventDataFlattener {
    /// Returns a "flattened" `Dictionary` which will not contain any `Dictionary` as a value. For example:
    ///  `[rootKey:[key1: value1, key2: value2]]`
    ///  will be flattened to
    ///  `[rootKey.key1: value1]`
    ///  `[rootKey.key2: value2]`
    ///
    /// - Parameter eventData: the `EventData` to flatten
    /// - Returns: flattened dictionary
    static func getFlattenedDataDict(eventData: [String: Any]) -> [String: Any] {
        var flattenedDict = [String: Any]()
        for (key, value) in eventData {
            if let subDict = value as? [String: Any] {
                flattenedDict.merge(dict: flatten(key: key, eventData: subDict))
            } else {
                flattenedDict[key] = value
            }
        }
        return flattenedDict
    }

    private static func flatten(key: String, eventData: [String: Any]) -> [String: Any] {
        var flattenedDict = [String: Any]()
        for (subKey, value) in eventData {
            let newKey = key + "." + subKey
            if let subDict = value as? [String: Any] {
                flattenedDict.merge(dict: flatten(key: newKey, eventData: subDict))
            } else {
                flattenedDict[newKey] = value
            }
        }
        return flattenedDict
    }
}

/// extend the `Dictionary` struct
extension Dictionary {
    /// Merge a new dictionary to the current dictionary
    /// - Parameter dict: a new dictionary to be merged
    mutating func merge<K, V>(dict: [K: V]) {
        for (k, v) in dict {
            updateValue(v as! Value, forKey: k as! Key)
        }
    }
}