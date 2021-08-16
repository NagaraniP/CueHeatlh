//
//  MockInventoryItemRepository.swift
//  HelloTreelineTests
//
//  Copyright © 2021 Treeline. All rights reserved.
//

import Foundation
@testable import HelloTreeline

class MockInventoryItemRepository: InventoryItemRepository {
    
    var items: [InventoryItem] = []
    
    func getAll(completion: @escaping (Result<[InventoryItem], Error>) -> Void) {
        completion(.success(items))
    }
    
    func get(objectId: String) -> InventoryItem? {
        items.first(where: { $0.id == objectId })
    }
}
