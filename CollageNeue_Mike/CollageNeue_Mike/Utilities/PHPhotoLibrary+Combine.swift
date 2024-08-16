//
//  PHPhotoLibrary+Combine.swift
//  CollageNeue_Mike
//
//  Created by ming on 2024/8/16.
//

import Foundation
import Photos
import Combine

extension PHPhotoLibrary {
    
    static var isAuthorized: Future<Bool, Never> {
        Future { resove in
            fetchAuthorizationStatus { isAuthorized in
                resove(.success(isAuthorized))
            }
        }
    }
    
    static func fetchAuthorizationStatus(callback: @escaping (Bool) -> Void) {
        let currentlyAuthorized = authorizationStatus() == .authorized
        
        guard !currentlyAuthorized else {
            return callback(currentlyAuthorized)
        }
        
        requestAuthorization { newStatus in
            callback(newStatus == .authorized)
        }
    }
    
}
