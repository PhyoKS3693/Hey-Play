//
//  PackageDataSource.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 11/6/25.
//

import Foundation

struct PackagePlan: Identifiable {
    let id = UUID()
    let packageName: String
    let packageBilledType: String
    let packageChargedAmount: String
    let packageIcon: String
}
