//
//  NotificationListView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 30/10/2025.
//

import Foundation
import SwiftUI
import Combine

struct NotificationListView : View {
    var notificationList : [NotificationItem] = []
    
    @ObservedObject var viewModel : NotificationViewModel
    
    init(_ viewmodel : NotificationViewModel) {
        // Remove default separators and background
        viewModel = viewmodel
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = UIColor.black
        UITableViewCell.appearance().backgroundColor = UIColor.black
    }
    
    var body: some View {
        
        ScrollView {
            VStack {
                ForEach(viewModel.notificationItems) { notification in
                    NotificationItemView(
                        notification: notification
                    )
                    .onTapGesture {
                        ViewNavigation.shared.showNotificationDetailView(notificaiton: notification)
                    }
                }
            }
        }
        .padding()
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

struct NotificationItemView : View {
    var notification : NotificationItem?
    var body: some View {
        HStack(alignment: .center, spacing: 15, content: {
            Image("ic.notification")
                .resizable()
                .frame(width: 40 , height: 40)
            
            VStack (alignment: .leading, content: {
                Text(notification?.title ?? "")
                    .font(FontUtility.body2())
                    .foregroundColor(Color.white)
                
                Text(notification?.message ?? "")
                    .font(FontUtility.smallText1())
                    .foregroundColor(Color.lightGrey)
            })
            Spacer()
        })
        .padding(.all)
        .background(Color.grey)
        .cornerRadius(10)
       
    }
    
    func navigateToDetails() {
        
    }
}

#Preview {
    NotificationListView(
        NotificationViewModel()
    )
}

