//
//  ListInteractor.swift
//  HelloTreeline
//
//  Copyright © 2021 Treeline. All rights reserved.
//

import Foundation

protocol ListInteractorDelegate: AnyObject {
    func itemsDidLoad(items: [InventoryItem])
}

class ListInteractor {

    weak var delegate: ListInteractorDelegate?
    
    private let itemRepository: InventoryItemRepository

    init(itemRepository: InventoryItemRepository = DefaultInventoryItemRepository.shared) {
        self.itemRepository = itemRepository
    }
    
    func loadItems() {
        itemRepository.getAll { result in
            switch result {
            case .success(let remoteItems):
                self.delegate?.itemsDidLoad(items: remoteItems)
            case .failure(_):
                /// TODO: show error
                break
            }
        }
    }
}
