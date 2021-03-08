//
//  MetadataCache.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/07.
//

import Foundation
import LinkPresentation

struct MetadataCache {
    static func cache(metadata: LPLinkMetadata) {
        do {
            guard retrieve(urlString: metadata.url!.absoluteString) == nil else {
                return
            }
            
            let data = try NSKeyedArchiver.archivedData(withRootObject: metadata, requiringSecureCoding: true)
            
            UserDefaults.standard.setValue(data, forKey: metadata.url!.absoluteString)
        }
        catch let error {
            print("Error when caching: \(error.localizedDescription)")
        }
    }
    
    static func retrieve(urlString: String) -> LPLinkMetadata? {
        do {
            guard
                let data = UserDefaults.standard.object(forKey: urlString) as? Data,
                let metadata = try NSKeyedUnarchiver.unarchivedObject(ofClass: LPLinkMetadata.self, from: data)
            else { return nil }
            return metadata
        }
        catch let error {
            print("Error when caching: \(error.localizedDescription)")
            return nil
        }
    }
}
