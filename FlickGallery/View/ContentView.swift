//
//  ContentView.swift
//  FlickGallery
//
//  Created by Sandhya on 31/05/2024.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            HomeView().navigationBarHidden(true)
        }
       
    }
}

#Preview {
    ContentView()
}

