//
//  DetailsRouter.swift
//  HelloTreeline
//
//  Copyright © 2021 Treeline. All rights reserved.
//

import Foundation
import UIKit

protocol DetailsRouter: AnyObject {
    // nothing yet
}

class DetailsDefaultRouter: DetailsRouter {

    private weak var viewController: DetailsDefaultViewController!

    public init(viewController: DetailsDefaultViewController) {
        self.viewController = viewController
    }

}
