//
//  Color.swift
//  FlickGallery
//
//  Created by Sandhya on 06/06/2024.
//

import Foundation
import SwiftUI

extension Color {
    
    static let theme = colorTheme()
    
}

struct colorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let greenColor = Color("CustomGreenColor")
    let redColor = Color("CustomRedColor")
    let secondaryText = Color("SecondaryTextColor")
}
