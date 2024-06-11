//
//  SplashScreenView.swift
//  FlickGallery
//

import SwiftUI

struct SplashScreenView: View {
  
    
    var body: some View {
        ZStack {
            Color.theme.redColor.opacity(0.4).edgesIgnoringSafeArea(.all)
           
            VStack {
                Image(systemName: "photo.on.rectangle.angled")
                    .resizable()
                    .scaleEffect(1.0)
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                
                Text("Flick Gallery")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.accent)
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
