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

public class FlagBrowserItem {
    
    // MARK: - Public Properties
    
    public private(set) var title: String?
    public private(set) var subtitle: String?
    public private(set) var value: String?
    
    public private(set) var childs = [FlagBrowserItem]()
    public private(set) var accessoryType: UITableViewCell.AccessoryType = .none
    public private(set) var isSelectable = false
    
    public var representedObj: Any?
    
    // MARK: - Initialization

    public init(title: String? = nil,
                subtitle: String? = nil,
                value: String? = nil,
                accessoryType: UITableViewCell.AccessoryType = .none,
                selectable: Bool = false,
                representedObj: Any? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.value = value
        self.accessoryType = accessoryType
        self.isSelectable = selectable
        self.representedObj = representedObj
    }
    
    public init(loader: AnyFlagsLoader) {
        self.title = loader.collectionType
        self.representedObj = loader
        
        childs.append(contentsOf: [
            FlagBrowserItem(title: "Group Type",
                            value: loader.collectionType,
                            selectable: false),
            FlagBrowserItem(title: "Data Providers",
                            subtitle: loader.providers?.map({ $0.name }).joined(separator: ", "),
                            value: "\(loader.providers?.count ?? 0)",
                            accessoryType: .disclosureIndicator,
                            selectable: true),
            FlagBrowserItem(title: "Browse Flags",
                            value: "\(loader.collection?.featureFlags().count ?? 0)",
                            accessoryType: .disclosureIndicator,
                            selectable: true,
                            representedObj: loader)
        ])
    }
    
}
