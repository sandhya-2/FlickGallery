//
//  ContentView.swift
//  FlickGallery
//
//  Created by Sandhya on 31/05/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showSplash: Bool = false
    
    var body: some View {
        
        ZStack {
            
            if self.showSplash {
                
                NavigationStack {
                    HomeView().navigationBarHidden(true)
                }
            } else {
                
                SplashScreenView()
                    .transition(.opacity) 
                    .onAppear {
                        
                        withAnimation(.easeIn(duration: 1.5)) {
                           
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                               
                                self.showSplash = false
                            }
                        }
                    }
                
                
            }
    
        }.edgesIgnoringSafeArea(.all)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        self.showSplash = true
                    }
                }
            }

        
    }
}

#Preview {
    ContentView()
}

