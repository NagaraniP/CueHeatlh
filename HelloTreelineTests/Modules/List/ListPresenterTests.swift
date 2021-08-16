//
//  ListPresenterTests.swift
//  HelloTreelineTests
//
//  Copyright © 2021 Treeline. All rights reserved.
//

import XCTest
@testable import HelloTreeline

class ListPresenterTests: XCTestCase {
    
    private var presenter: ListPresenter!
    private var mockRouter: MockRouter!
    private var view: MockViewController!
    
    private let inventoryItems = [
        InventoryItem(id: "test-id-1", title: "title-1", description: "description-1", color: "color-1", available: 1001, type: "type-1"),
        InventoryItem(id: "test-id-2", title: "title-2", description: "description-2", color: "color-2", available: 1002, type: "type-2"),
        InventoryItem(id: "test-id-3", title: "title-3", description: "description-3", color: "color-3", available: 1003, type: "type-3")
    ]

    override func setUpWithError() throws {
        
        self.mockRouter = MockRouter()
        self.view = MockViewController()
        
        
        let itemRepository = MockInventoryItemRepository()
        itemRepository.items = inventoryItems
        let interactor = ListInteractor(itemRepository: itemRepository)
        
        self.presenter = ListPresenter(view: view, interactor: interactor, router: mockRouter)
    }
    
    func testViewWillAppearToLoadListItems() {
        
        // before
        XCTAssertEqual(presenter.itemCount, 0)
        XCTAssertEqual(view.reloadListCalledCount, 0)
        
        // when
        presenter.viewWillAppear()
        
        // then
        XCTAssertEqual(presenter.itemCount, inventoryItems.count)
        XCTAssertEqual(view.reloadListCalledCount, 1)
        for i in 0..<(inventoryItems.count) {
            let listItem = presenter.listItem(at: IndexPath(row: i, section: 0))
            let inventoryItem = inventoryItems[i]
            XCTAssertEqual(listItem.id, inventoryItem.id)
            XCTAssertEqual(listItem.title, inventoryItem.title)
        }
    }
    
    func testListItemSelection() {
        
        // before
        XCTAssertNil(mockRouter.routeToDetailsCallObjectId)
        let salesCount = mockRouter.salesCount?.count ?? 0
        XCTAssertTrue( salesCount == 0, "No sales" );
        
        let inventoryAdded = mockRouter.inventoryCount?.count ?? 0
        XCTAssertTrue( inventoryAdded == 0, "No inventory" )
        
        // when
        presenter.viewWillAppear()
        
        let objectId = inventoryItems[0].id
        presenter.listItemSelected(objectId: objectId)
        
        // then
        XCTAssertEqual(mockRouter.routeToDetailsCallObjectId, objectId)
    }
    
    func testSalesReport() {
        //before
        XCTAssertNil(mockRouter.salesMessages)
        XCTAssertNil(mockRouter.subject)
        XCTAssertNil(mockRouter.email)
        
        // when
        presenter.viewWillAppear()
        presenter.salesSelected()
        
        // then
        XCTAssertEqual(mockRouter.subject, "Daily Sales Status")
        XCTAssertEqual(mockRouter.email, ["bossman@bosscompany.com"])
        
    }
    
}

fileprivate class MockViewController: ListViewController {
    var reloadListCalledCount = 0
    func reloadList() {
        reloadListCalledCount += 1
    }
    func reloadSelectedRow(atItem: IndexPath) {}
}

fileprivate class MockRouter: ListRouter {
    
    var routeToDetailsCallObjectId: String? = nil
    var salesCount: [ListItem]? = nil
    var inventoryCount: [ListItem]? = nil
    var salesMessages: String? = nil
    var email: [String]? = nil
    var subject: String? = nil
    
    func routeToDetails(objectId: String, list: [ListItem]?, invetoryAdded: [ListItem]?) {
        routeToDetailsCallObjectId = objectId
        salesCount = list
        inventoryCount = invetoryAdded
    }
    
    func routeToReportSales(list: [ListItem], message: String, to: [String], subject: String) {
        self.salesMessages = message
        self.subject = subject
        self.email = to
    }
}
