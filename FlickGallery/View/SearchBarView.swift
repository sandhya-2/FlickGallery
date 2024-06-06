//
//  SearchBarView.swift
//  FlickGallery
//
//  Created by Sandhya on 02/06/2024.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    @State private var isEditing = false
        
    var body: some View {
        
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(!searchText.isEmpty ? Color.theme.secondaryText : .accentColor)
                .opacity(isEditing ? 0.0 : 1.0)
                
            
            TextField("Search by tags or text", text: $searchText, onEditingChanged: { editing in
                isEditing = editing
               
            })
                .foregroundColor(Color.theme.accent)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .onChange(of: searchText, { oldValue, newValue in
                    isEditing = !newValue.isEmpty
                    print("Search text changed: \(newValue)")
                })
                .overlay (
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundColor(.accentColor)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                            isEditing = false
                            
                        }
                    
                    ,alignment: .trailing
                )
        }
        .font(.headline)
            .padding()
            .background(
                //
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.theme.background)
                    .shadow(color: Color.theme.accent.opacity(0.15), radius: 10, x: 0, y: 0)
            ).padding()
        
    }
        
}

/*struct SearchBarView: View {
    
    @Binding var searchText: String
    @FocusState private var focus: Bool
    @State private var isEditing = false
    
    var body: some View {
        
        VStack {
            
            TextField("Search", text: $searchText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($focus)
                .padding(.leading, 40)
                .frame(width: 360, height: 40).background(
                    RoundedRectangle(cornerRadius: 10).strokeBorder(Color.black, style: StrokeStyle(lineWidth: 1.0))
                        .font(.subheadline)
                )
                .onChange(of: searchText, { oldValue, newValue in
                    isEditing = !searchText.isEmpty
                    print("Search text changed: \(newValue)")
                })
                .overlay(
                    
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .offset(x: -160)
                            .opacity(!searchText.isEmpty ? 0.0 : 1.0)
                        Spacer()
                        
                        if !searchText.isEmpty {
                            
                            Image(systemName: "xmark.circle.fill")
                                .padding()
                                .offset(x: 10)
                                .foregroundColor(Color.red)
                                .opacity(searchText.isEmpty ? 0.0 : 1.0)
                                .onTapGesture {
                                    isEditing = false
                                    UIApplication.shared.endEditing()
                                    searchText = ""
                                }
                            
                        }
                        
                        
                        
                    }
                    
                )
            
        }
        .onAppear {
            focus = true
        
        
        
        
        /*    VStack {
         
         TextField("Search", text: $searchText)
         .textInputAutocapitalization(.never)
         .autocorrectionDisabled()
         .padding(.leading, 40)
         .frame(width: 360, height: 40)
         .onTapGesture {
         isEditing = true
         }
         .focused($focus)
         .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.black, style: StrokeStyle(lineWidth: 1.0)))
         .font(.subheadline)
         .overlay(Image(systemName: "magnifyingglass")
         .foregroundColor(.gray)
         .offset(x: -160)
         .opacity(!searchText.isEmpty ? 0.0 : 1.0)
         )
         .overlay(
         Image(systemName: "xmark.circle.fill")
         .padding()
         .offset(x: 10)
         .foregroundColor(Color.red)
         .opacity(searchText.isEmpty ? 0.0 : 1.0)
         .onTapGesture {
         isEditing = false
         UIApplication.shared.endEditing()
         searchText = ""
         }
         ,alignment: .trailing)
         }
         .onAppear {
         focus = true
         }.onChange(of: searchText) { oldValue, newValue in
         print("Search text changed: \(newValue)")
         }*/
        
    }
}
*/


#Preview {
    
    SearchBarView(searchText: .constant("yorkshire"))
}


