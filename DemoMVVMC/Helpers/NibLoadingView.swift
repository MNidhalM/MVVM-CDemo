//
//  NibLoadingView.swift
//  DemoMVVMC
//
//  Created by mac on 1/3/2022.
//

import UIKit

protocol NibDefinable {
    var nibName: String { get }
}

@IBDesignable
class NibLoadingView: UIView, NibDefinable {
    
    @IBOutlet weak var view: UIView!
    
    var nibName: String {
        return String(describing: type(of: self))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        backgroundColor = .clear
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        // swiftlint:disable force_cast
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        // swiftlint:enable force_cast
        
        return nibView
    }
}

@IBDesignable
class NibLoading<T>: UIView, NibDefinable where T: UIView {
    
    weak var view: T!
    
    var nibName: String {
        return String(describing: type(of: self))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        backgroundColor = .clear
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
    }
    
    private func loadViewFromNib() -> T {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        // swiftlint:disable force_cast
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! T
        // swiftlint:enable force_cast
        
        return nibView
    }
}
