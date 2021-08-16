//
//  DetailsPresenterTests.swift
//  HelloTreelineTests
//
//  Copyright © 2021 Treeline. All rights reserved.
//

import XCTest
@testable import HelloTreeline

class DetailsPresenterTests: XCTestCase {
    
    private var presenter: DetailsPresenter!
    private var view: MockViewController!
    
    private let inventoryItem = InventoryItem(id: "test-id", title: "title", description: "description", color: "color", available: 100, type: "type")

    override func setUpWithError() throws {
        
        self.view = MockViewController()
        
        let itemRepository = MockInventoryItemRepository()
        itemRepository.items = [inventoryItem]
        let listItem:ListItem =  ListItem(id: "id", title: "title", available: 10)
        let interactor = DetailsInteractor(itemRepository: itemRepository)
        self.presenter = DetailsPresenter(view: view, interactor: interactor, router:StubRouter() , objectId: inventoryItem.id, salesList: [listItem], inventoryAdded: [listItem])
        
    }

    func testViewDidLoadToPopulateAllLabels() throws {
        
        // before
        XCTAssertNil(view.navBarTitle)
        XCTAssertNil(view.idLabelTitle)
        XCTAssertNil(view.titleLabelTitle)
        XCTAssertNil(view.desciptionLabelTitle)
        XCTAssertNil(view.colorLabelTitle)
        XCTAssertNil(view.costLabelTitle)
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertEqual(view.navBarTitle, "\(inventoryItem.title)")
        XCTAssertEqual(view.idLabelTitle, "ID: \(inventoryItem.id)")
        XCTAssertEqual(view.titleLabelTitle, "Title: \(inventoryItem.title)")
        XCTAssertEqual(view.desciptionLabelTitle, "Description: \(inventoryItem.description)")
        XCTAssertEqual(view.colorLabelTitle, "Color: \(inventoryItem.color)")
        XCTAssertEqual(view.availableLabelTitle, "Available: \(inventoryItem.available)")
    }
}

fileprivate class MockViewController: DetailsViewController {
    var availableLabelTitle: String?
    
    var navBarTitle: String?
    
    var idLabelTitle: String?
    
    var titleLabelTitle: String?
    
    var desciptionLabelTitle: String?
    
    var colorLabelTitle: String?
    
    var costLabelTitle: String?
}

fileprivate class StubRouter: DetailsRouter { }
