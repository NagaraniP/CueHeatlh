//
//  DetailsPresenter.swift
//  HelloTreeline
//
//  Copyright © 2021 Treeline. All rights reserved.
//

import Foundation

class DetailsPresenter: DetailsInteractorDelegate {
    
    private let router: DetailsRouter
    private let interactor: DetailsInteractor
    private weak var view: DetailsViewController!
    
    private let objectId: String
    let list: [ListItem]?
    let inventory: [ListItem]?
    
    init(view: DetailsViewController,
         interactor: DetailsInteractor,
         router: DetailsRouter,
         objectId: String, salesList: [ListItem]?, inventoryAdded: [ListItem]?) {
        
        self.view = view
        self.interactor = interactor
        self.router = router
        
        self.objectId = objectId
        self.list = salesList
        self.inventory = inventoryAdded
        
        self.interactor.delegate = self
    }
    
    func viewDidLoad() {
        interactor.loadItem(objectId: objectId)
    }
    
    func itemDidLoad(item: InventoryItem) {
        if let list = list, let inventory = inventory, list.count > 0 , inventory.count > 0 {
            var salesCount: Int = 0
            var inventoryAddedCount: Int = 0
            for element in list  {
                if element.id == item.id {
                    salesCount = list.filter({ $0.id == element.id }).count
                }
            }
            
            for element in inventory {
                if element.id == item.id {
                    inventoryAddedCount = inventory.filter({ $0.id == element.id }).count
                }
            }
            
            let count = item.available - salesCount + inventoryAddedCount
            let availableCount = count > 0 ? count : 0
            self.loadItemDetails(navTitle: item.title, id: item.id, title: item.title, description: item.description, itemCount: "\(availableCount)", color: item.color)
            
        } else if let list = list, list.count > 0 , let inventory = inventory, inventory.count == 0 {
            for element in list {
                if element.id == item.id {
                    let count = list.filter({ $0.id == element.id }).count
                    let availableCount = (item.available - count) > 0 ? (item.available - count) : 0
                    self.loadItemDetails(navTitle: item.title, id: item.id, title: item.title, description: item.description, itemCount: " \(availableCount)", color: item.color)
                    return
                }
            }
            self.loadItemDetails(navTitle: item.title, id: item.id, title: item.title, description: item.description, itemCount: "\(item.available)", color: item.color)
            
        } else if let inventory = inventory, inventory.count > 0 , let list = list, list.count == 0 {
            
            for element in inventory {
                if element.id == item.id {
                    let count = inventory.filter({ $0.id == element.id }).count
                    self.loadItemDetails(navTitle: item.title, id: item.id, title: item.title, description: item.description, itemCount: " \(item.available + count)", color: item.color)
                    return
                }
            }
            self.loadItemDetails(navTitle: item.title, id: item.id, title: item.title, description: item.description, itemCount: "\(item.available)", color: item.color)
        } else {
            self.loadItemDetails(navTitle: item.title, id: item.id, title: item.title, description: item.description, itemCount: "\(item.available)", color: item.color)
        }
    }
    
    private func loadItemDetails(navTitle: String, id:String ,title: String, description: String, itemCount: String, color: String ) {
        view.navBarTitle = navTitle
        view.idLabelTitle = "ID: \(id)"
        view.titleLabelTitle = "Title: \(title)"
        view.desciptionLabelTitle = "Description: \(description)"
        view.colorLabelTitle = "Color: \(color)"
        view.availableLabelTitle = "Available: \(itemCount)"
    }
}
