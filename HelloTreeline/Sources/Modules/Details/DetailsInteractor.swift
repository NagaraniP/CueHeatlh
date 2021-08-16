//
//  DetailsInteractor.swift
//  HelloTreeline
//
//  Copyright © 2021 Treeline. All rights reserved.
//

import Foundation

protocol DetailsInteractorDelegate: AnyObject {
    func itemDidLoad(item: InventoryItem)
}

class DetailsInteractor {

    weak var delegate: DetailsInteractorDelegate?
    
    private let itemRepository: InventoryItemRepository

    init(itemRepository: InventoryItemRepository = DefaultInventoryItemRepository.shared) {
        self.itemRepository = itemRepository
    }
    
    func loadItem(objectId: String) {
        guard let item = itemRepository.get(objectId: objectId) else { return }
        delegate?.itemDidLoad(item: item)
    }
}
