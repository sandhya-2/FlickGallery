//
//  CircleButtonView.swift
//  FlickGallery
//
//  Created by Sandhya on 06/06/2024.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.theme.accent)
            .frame(width: 30, height: 30)
            .background(
                Circle()
                    .foregroundColor(Color.theme.background)
            
            ).shadow(
                color: Color.theme.accent.opacity(0.25), radius: 10, x: 0, y: 0)
            .padding()
    }
}

#Preview {
    CircleButtonView(iconName: "chevron.left")
}
