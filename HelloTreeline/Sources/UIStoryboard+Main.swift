//
//  UIStoryboard+Main.swift
//  HelloTreeline
//
//  Copyright © 2021 Treeline. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static var main: UIStoryboard { .init(name: "Main", bundle: nil) }
    
    func instantiateViewController<T: UIViewController>(of type: T.Type) -> T? {
        instantiateViewController(identifier: String(describing: type))
    }
}
