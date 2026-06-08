//
//  NotificationRequest.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Notification List Request
struct NotificationListRequest: Encodable {
    let pageNo: Int

    init(pageNo: Int = 1) {
        self.pageNo = pageNo
    }
}

// MARK: - Notification Detail Request
struct NotificationDetailRequest: Encodable {
    let notiId: Int
    let notiHistoryFlag: Int

    init(notiId: Int, notiHistoryFlag: Int = 0) {
        self.notiId = notiId
        self.notiHistoryFlag = notiHistoryFlag
    }
}
