//
//  Helpers.swift
//  DemoMVVMC
//
//  Created by mac on 27/2/2022.
//

import UIKit

extension String {
    func toInt() -> Int {
        return Int(self) ?? 0
    }
}

public extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController {
    class func instantiateFromStoryboard(_ name: String) -> Self {
        return instantiateFromStoryboardHelper(name)
    }

    private class func instantiateFromStoryboardHelper<T>(_ name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! T
        return controller
    }
}

@IBDesignable extension UIView {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
