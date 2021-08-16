//
//  InventoryItemRepository.swift
//  HelloTreeline
//
//  Copyright © 2021 Treeline. All rights reserved.
//

import Foundation

protocol InventoryItemRepository {
    func getAll(completion: @escaping (Result<[InventoryItem], Error>) -> Void)
    func get(objectId: String) -> InventoryItem?
}

class DefaultInventoryItemRepository: InventoryItemRepository {
    
    static let shared: InventoryItemRepository = DefaultInventoryItemRepository()
    
    private let apiClient: APIClient
    
    private var items: [InventoryItem] = []
    
    init(apiClient: APIClient = DefaultAPIClient.shared) {
        self.apiClient = apiClient
    }
    
    func getAll(completion: @escaping (Result<[InventoryItem], Error>) -> Void) {
        apiClient.get(endpoint: "getInventory", type: [InventoryItem].self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self.items = items
                    completion(.success(self.items))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func get(objectId: String) -> InventoryItem? {
        items.first(where: { $0.id == objectId })
    }
}
