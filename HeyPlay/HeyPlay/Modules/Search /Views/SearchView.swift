//
//  SearchView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 24/10/2025.
//

import Foundation
import SwiftUI

struct SearchView : View {
   
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 50)
            SearchTopView()
            SearchTextView()
            RecentView()
            MostSearchView()
            Spacer()
        }
        .padding()
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

struct SearchTopView : View {
    @Environment(\.presentationMode) var presentationMode
   
    var body: some View {
        HStack {
            Text("Search")
                .foregroundColor(Color.white)
                .font(FontUtility.heading2())
            Spacer()
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("ic.cross")
                    .resizable()
                    .frame(width: 30 , height: 30)
            }
        }
        .padding()
       
    }
}

struct SearchTextView : View {
    @State var phoneNumber: String = ""
    var body: some View {
        ZStack(alignment: .leading) {
            if phoneNumber.isEmpty {
                Text("Search by keywords".localized())
                    .foregroundColor(.white)
                    .padding(.leading, 20)
            }

            TextField("", text: $phoneNumber)
                .padding(.horizontal, 20)
                .frame(height: 40)
                .background(Color.black)
                .font(FontUtility.caption())
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 1)
                )
                .foregroundColor(.white)
        }
    }
}

#Preview {
    SearchView()
}
