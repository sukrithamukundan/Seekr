//
//  Avatar.swift
//  Seekr
//
//  Created by Jishnu Raj  on 17/07/25.
//

import Contacts
import SwiftUI

func fetchUserAvatar() -> UIImage? {
    let store = CNContactStore()
    let keysToFetch = [CNContactThumbnailImageDataKey, CNContactImageDataAvailableKey] as [CNKeyDescriptor]

    do {
        let predicate = CNContact.predicateForContacts(matchingName: UIDevice.current.name)
        let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)

        if let contact = contacts.first, contact.imageDataAvailable, let imageData = contact.thumbnailImageData {
            return UIImage(data: imageData)
        }
    } catch {
        print("Error fetching contact image: \(error)")
    }

    return nil
}
