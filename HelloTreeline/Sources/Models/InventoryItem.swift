//
//  InventoryItem.swift
//  HelloTreeline
//
//  Copyright © 2021 Treeline. All rights reserved.
//

import Foundation

struct InventoryItem: Decodable {
    let id: String
    let title: String
    let description: String
    let color: String
    let available: Int
    let type: String
}
