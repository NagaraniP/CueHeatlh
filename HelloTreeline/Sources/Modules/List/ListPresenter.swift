//
//  ListPresenter.swift
//  HelloTreeline
//
//  Copyright © 2021 Treeline. All rights reserved.
//

import Foundation

class ListPresenter: ListInteractorDelegate {

    private let router: ListRouter
    private let interactor: ListInteractor
    private weak var view: ListViewController!
    
    private var listItems: [ListItem] = []
    private var salesItems: [ListItem] = []
    private var inventoryAdded: [ListItem] = []
    
    var itemCount: Int { listItems.count }

    init(view: ListViewController, interactor: ListInteractor, router: ListRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router

        self.interactor.delegate = self
    }
    
    func viewWillAppear() {
        salesItems.removeAll()
        inventoryAdded.removeAll()
        interactor.loadItems()
    }
    
    func listItem(at indexPath: IndexPath) -> ListItem {
        listItems[indexPath.row]
    }
    
    func listItemSelected(objectId: String) {
        router.routeToDetails(objectId: objectId, list: salesItems, invetoryAdded: inventoryAdded)


    }
    
    func itemsDidLoad(items: [InventoryItem]) {
        self.listItems = items.map { .init(id: $0.id, title: $0.title, available: $0.available) }
        self.view.reloadList()
    }
    
    func listItemSalesUpdate(at indexPathRow: IndexPath, updateTo: Int) {
        guard listItems[indexPathRow.row].available > 0 else {
            return
        }
        var templistItem = listItems[indexPathRow.row]
        listItems[indexPathRow.row].available += updateTo
        templistItem.available = templistItem.available - listItems[indexPathRow.row].available
        salesItems.append(templistItem)
        self.view.reloadSelectedRow(atItem: indexPathRow)
    }
    
    func listItemUpdate(at indexPathRow: IndexPath, updateTo: Int) {
        var templistItem = listItems[indexPathRow.row]
        listItems[indexPathRow.row].available += updateTo
        templistItem.available = templistItem.available + listItems[indexPathRow.row].available
        inventoryAdded.append(templistItem)
        self.view.reloadSelectedRow(atItem: indexPathRow)
    }
    
    func salesSelected() {
        var counts: [ListItem: Int] = [:]
        for item in salesItems {
            counts[item] = (counts[item] ?? 0) + 1
        }
        var salesReport:String = "Hi Bossman, \n\n Today's sales report.\n "
        for (key, values) in counts {
            salesReport += "\n\n ID:  \(key.id):\( values) \n Title: \(key.title) \n Sold: \( values) "
        }
        router.routeToReportSales(list: salesItems, message: salesReport, to: ["bossman@bosscompany.com"], subject: "Daily Sales Status")
    }
}
