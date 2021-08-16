//
//  DetailsViewContoller.swift
//  HelloTreeline
//
//  Copyright © 2021 Treeline. All rights reserved.
//

import Foundation
import UIKit

protocol DetailsViewController: AnyObject {
    var navBarTitle: String? { get set }
    var idLabelTitle: String? { get set}
    var titleLabelTitle: String? { get set}
    var desciptionLabelTitle: String? { get set}
    var colorLabelTitle: String? { get set}
    var availableLabelTitle: String? { get set }
}

class DetailsDefaultViewController: UIViewController, DetailsViewController {
    
    var navBarTitle: String? {
        get { navigationItem.title }
        set { navigationItem.title = newValue }
    }
    
    var idLabelTitle: String? {
        get { idLabel.text }
        set { idLabel.text = newValue }
    }
    var titleLabelTitle: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    var desciptionLabelTitle: String? {
        get { desciptionLabel.text }
        set { desciptionLabel.text = newValue }
    }
    var colorLabelTitle: String? {
        get { colorLabel.text }
        set { colorLabel.text = newValue }
    }
    var availableLabelTitle: String? {
        get { costLabel.text }
        set { costLabel.text = newValue }
    }
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var desciptionLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    static func build(objectId: String, list: [ListItem]?, inventoryAdded: [ListItem]?) -> DetailsDefaultViewController {
        let viewController = UIStoryboard.main.instantiateViewController(of: DetailsDefaultViewController.self)!
        let router = DetailsDefaultRouter(viewController: viewController)
        let interactor = DetailsInteractor()
        
        viewController.presenter = DetailsPresenter(view: viewController, interactor: interactor, router: router, objectId: objectId, salesList: list, inventoryAdded: inventoryAdded)
        
        return viewController
    }
    
    private var presenter: DetailsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}
