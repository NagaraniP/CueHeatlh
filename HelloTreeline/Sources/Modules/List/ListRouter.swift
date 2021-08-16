//
//  ListRouter.swift
//  HelloTreeline
//
//  Copyright © 2021 Treeline. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

protocol ListRouter: AnyObject {
    func routeToDetails(objectId: String, list: [ListItem]?, invetoryAdded: [ListItem]?)
    func routeToReportSales(list: [ListItem],message: String,to: [String],subject: String)
}

class ListDefaultRouter: ListRouter {

    private weak var viewController: ListDefaultViewController!

    public init(viewController: ListDefaultViewController) {
        self.viewController = viewController
    }

    func routeToDetails(objectId: String, list: [ListItem]?, invetoryAdded: [ListItem]?) {
        let detailsViewController = DetailsDefaultViewController.build(objectId: objectId, list: list, inventoryAdded: invetoryAdded)
        viewController.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func routeToReportSales(list: [ListItem], message: String, to: [String], subject: String) {
        let inventorySalesReport = MFMailComposeViewController()
        inventorySalesReport.mailComposeDelegate = viewController.self
        inventorySalesReport.setToRecipients(to)
        inventorySalesReport.setSubject(subject)
        inventorySalesReport.setMessageBody(message, isHTML: false)
        viewController.present(inventorySalesReport, animated: true, completion: nil)
    }
}
