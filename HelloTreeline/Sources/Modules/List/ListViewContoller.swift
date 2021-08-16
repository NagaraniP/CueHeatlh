//
//  ListViewContoller.swift
//  HelloTreeline
//
//  Copyright © 2021 Treeline. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

private struct  ListConstants {
    static let alertTitle = "Could not sent email"
    static let alertMessage = "check if your device have email support!"
    static let navBtnText = "Sales"
    static let alertOkBtnText = "Ok"
}

protocol ListViewController: AnyObject {
    func reloadList()
    func reloadSelectedRow(atItem:IndexPath)
}

class ListDefaultViewController: UIViewController, ListViewController {

    static func build() -> ListDefaultViewController {
        let viewController = UIStoryboard.main.instantiateViewController(of: ListDefaultViewController.self)!
        let router = ListDefaultRouter(viewController: viewController)
        let interactor = ListInteractor()

        viewController.presenter = ListPresenter(view: viewController, interactor: interactor, router: router)

        return viewController
    }

    private var presenter: ListPresenter!

    @IBOutlet weak var tableView: UITableView!
    
    private let CellIdentifier = "ListCellIdentifier"
    
    private let ItemCustomTableViewCell = "ListTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: ItemCustomTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifier)
        
        let salesBtn = UIBarButtonItem(title: ListConstants.navBtnText, style: .plain, target: self, action: #selector(salesReport))
        navigationItem.rightBarButtonItems = [salesBtn]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
    
    @objc func salesReport() {
        if MFMailComposeViewController.canSendMail() {
            presenter.salesSelected()
        } else {
            let alertMessage = UIAlertController(title: ListConstants.alertTitle, message: ListConstants.alertMessage, preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title:ListConstants.alertOkBtnText, style: UIAlertAction.Style.default, handler: nil)
            alertMessage.addAction(action)
            self.present(alertMessage, animated: true, completion: nil)
        }
    }
    
    func reloadList() {
        tableView.reloadData()
    }
    
    func reloadSelectedRow(atItem:IndexPath) {
        tableView.reloadRows(at: [atItem], with: .none)
    }
}

extension ListDefaultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! ListTableViewCell
        cell.itemTypeLabel.text = presenter.listItem(at: indexPath).title
        cell.itemAvailableLabel.text = "Available: \(String(presenter.listItem(at: indexPath).available))"
        cell.itemSelected = indexPath
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objectId = presenter.listItem(at: indexPath).id
        presenter.listItemSelected(objectId: objectId)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListDefaultViewController: ListTableViewCellDelegate {
    func itemIncrement(itemSelectedAt: IndexPath) {
        presenter.listItemUpdate(at: itemSelectedAt, updateTo: 1)
    }
    
    func itemDecrement(itemSelectedAt: IndexPath) {
        presenter.listItemSalesUpdate(at: itemSelectedAt, updateTo: -1)
    }
}

extension ListDefaultViewController : MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("SalesReport cancelled")
        case .saved:
            print("Report saved")
        case .sent:
            print("Report sent")
        case .failed:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
}
