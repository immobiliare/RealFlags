//
//  IndomioFlags
//  Easily manage Feature Flags in Swift
//
//  Created by the Mobile Team @ ImmobiliareLabs
//  Email: mobile@immobiliare.it
//  Web: http://labs.immobiliare.it
//
//  Copyright ©2021 Immobiliare.it SpA. All rights reserved.
//  Licensed under MIT License.
//

import UIKit

public class FlagBrowserItem {
    
    public enum CellType {
        case `default`
        case entryTextField
    }
    
    public enum NumericConversion {
        case int
        case float
        case double
    }
    
    public enum ActionType {
        case none
        case setBoolValue(Bool)
        case setStringValue
        case setNumericValue(NumericConversion)
        case setJSONValue
        case clearValue
    }
    
    // MARK: - Public Properties
    
    public private(set) var title: String?
    public private(set) var subtitle: String?
    public private(set) var value: String?
    public private(set) var icon: UIImage?

    public var childs = [FlagBrowserItem]()
    public private(set) var accessoryType: UITableViewCell.AccessoryType = .none
    public var isSelectable = false
    public var isDisabled = false

    public var representedObj: Any?
    public var cellType: CellType = .default
    public var actionType: ActionType = .none

    // MARK: - Initialization

    public init(title: String? = nil,
                subtitle: String? = nil,
                value: String? = nil,
                icon: UIImage? = nil,
                accessoryType: UITableViewCell.AccessoryType = .none,
                selectable: Bool = false,
                disabled: Bool = false,
                representedObj: Any? = nil,
                cellType: CellType = .default,
                actionType: ActionType = .none) {
        self.title = title
        self.subtitle = subtitle
        self.value = value
        self.accessoryType = accessoryType
        self.isSelectable = selectable
        self.representedObj = representedObj
        self.cellType = cellType
        self.actionType = actionType
        self.isDisabled = disabled
        self.icon = icon
    }
    
    public init(loader: AnyFlagsLoader) {
        self.title = loader.collectionType
        self.representedObj = loader
        
        childs.append(contentsOf: [
            FlagBrowserItem(title: "Group Name",
                            value: loader.collectionType,
                            selectable: false),
            FlagBrowserItem(title: "Providers",
                            value: loader.providers?.map({ $0.name }).joined(separator: "\n"),
                            selectable: false),
            FlagBrowserItem(title: "Browse Data",
                            value: "\(loader.hierarcyFeatureFlags.count) Elements",
                            accessoryType: .disclosureIndicator,
                            selectable: true,
                            representedObj: loader)
        ])
    }
    
}
