//
//  BentoFlags
//  Easily manage feature flags in Swift.
//
//  Created by Daniele Margutti
//  Email: hello@danielemargutti.com
//  Web: http://www.danielemargutti.com
//
//  Copyright ©2021 Daniele Margutti. All rights reserved.
//  Licensed under MIT License.
//


import UIKit

public protocol NibType {
    
    static var nibName: String { get }
    
    static var nibBundle: Bundle { get }
    
    static var nib: UINib { get }
}

public extension NibType where Self: NSObjectProtocol {
    
    static var nibBundle: Bundle {
        Bundle(for: self)
    }
    
    static var nib: UINib {
        .init(nibName: nibName, bundle: nibBundle)
    }
        
    static var nibName: String {
        .init(describing: self)
    }
}

public protocol Reusable {
    static var reusableIdentifier: String { get }
}

public extension Reusable {
    
    static var reusableIdentifier: String {
        return String(describing: Self.self)
    }
}

public extension Reusable where Self: UITableViewCell {
    
    static func dequeue(from tableView: UITableView, for indexPath: IndexPath) -> Self {
        tableView.dequeueReusableCell(withIdentifier: Self.reusableIdentifier, for: indexPath) as! Self
    }
    
}

public extension Reusable where Self: UITableViewHeaderFooterView {
    
    static func dequeue(from tableView: UITableView) -> Self {
        tableView.dequeueReusableHeaderFooterView(withIdentifier: Self.reusableIdentifier) as! Self
    }
    
}

public extension UITableView {
    
    func register<C: UITableViewCell>(type: C.Type) where C: Reusable {
        register(C.self, forCellReuseIdentifier: C.reusableIdentifier)
    }
    
    func registerNib<C: UITableViewCell>(type: C.Type) where C: Reusable, C: NibType {
        register(C.nib, forCellReuseIdentifier: C.reusableIdentifier)
    }
    
}

public extension UITableView {
    
    func register<C: UITableViewHeaderFooterView>(type: C.Type) where C: Reusable {
        register(C.self, forHeaderFooterViewReuseIdentifier: C.reusableIdentifier)
    }
    
    func registerNib<C: UITableViewHeaderFooterView>(type: C.Type) where C: Reusable, C: NibType {
        register(C.nib, forHeaderFooterViewReuseIdentifier: C.reusableIdentifier)
    }
    
}
