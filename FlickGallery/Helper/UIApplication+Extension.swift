//
//  UIApplication+Extension.swift
//  FlickGallery
//
//  Created by Sandhya on 05/06/2024.
//

import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
