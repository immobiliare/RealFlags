//
//  IndomioFlags
//  Easily manage Feature Flags in Swift
//
//  Created by the Mobile Team @ ImmobiliareLabs
//  Email: mobile@immobiliare.it
//  Web: http://labs.immobiliare.it
//
//  Copyright ©2021 Daniele Margutti. All rights reserved.
//  Licensed under MIT License.
//

import UIKit

// MARK: - FlagsBrowserController

public struct FlagInProvider {
    var flag: AnyFlag
    var provider: FlagsProvider
}

public class FlagsBrowserController: UIViewController {
    
    public enum DataType {
        case flag(AnyFlag)
        case flags(AnyFlagsLoader)
        case flagsInCollection(AnyFlagCollection)
        case loaders([AnyFlagsLoader])
        case flagData(FlagInProvider)
    }
    
    // MARK: - Private Properties
    
    /// Loaded loaders.
    public private(set) var data: DataType!
    public private(set) var items = [FlagBrowserItem]()
    
    /// Tableview of the content.
    @IBOutlet public var tableView: UITableView?
    
    // MARK: - Initialization (with Navigation)
    
    public static func create(manager: FlagsManager, title: String? = nil) -> UINavigationController {
        create(loaders: Array(manager.loaders.values), title: title)
    }
    
    public static func create(loaders: [AnyFlagsLoader], title: String? = nil) -> UINavigationController {
        let controller = UIStoryboard(name: "FlagsBrowserController", bundle: .module).instantiateInitialViewController() as! FlagsBrowserController
        controller.title = title ?? "FeatureFlags Browser"
        controller.data = .loaders(loaders)
        
        let navigation = UINavigationController(rootViewController: controller)
        return navigation
    }
    
    // MARK: - View Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.registerNib(type: FlagsBrowserDefaultCell.self)
        tableView?.registerNib(type: FlagBrowserDataCell.self)
        tableView?.estimatedRowHeight = 44.0
        tableView?.dataSource = self
        tableView?.delegate = self
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    // MARK: - Private Functions
    
    private func reloadData() {
        switch data {
        case .flags(let loader):
            self.items = reloadDataForLoader(loader)
            
        case .flag(let flag):
            self.items = reloadDataForFlag(flag)
            
        case .loaders(let loaders):
            self.items = reloadDataForLoaders(loaders)
            
        case .flagData(let flagInProvider):
            self.items = reloadDataForFlagDetail(flagInProvider.flag, inProvider: flagInProvider.provider)
            
        case .flagsInCollection(let collection):
            self.items = reloadDataForFlagCollection(collection)
            
        case .none:
            break
        }
        
        tableView?.reloadData()
    }
    
    private func reloadDataForFlagDetail(_ flag: AnyFlag, inProvider provider: FlagsProvider) -> [FlagBrowserItem] {
        let infoSection = FlagBrowserItem(title: "Info")
        
        infoSection.childs = [
            FlagBrowserItem(title: "Key", subtitle: flag.keyPath.fullPath, value: flag.name),
            FlagBrowserItem(title: "Data Type", value: flag.readableDataType),
            FlagBrowserItem(title: "Provider", value: provider.name)
        ]
        
        let dataSection = FlagBrowserItem(title: "Current Value")
        let value = flag.getValueForFlag(from: type(of: provider))
        let isWritableProvider = provider.isWritable
        var isWritableObject = (flag.metadata.isLocked == false)
        
        // Current value change options
        switch flag.dataType {
        case is String.Type:
            dataSection.childs.append(contentsOf: [
                FlagBrowserItem(value: (value as? String) ?? "",
                                accessoryType: .none,
                                disabled: !isWritableProvider,
                                cellType: .entryTextField),
                FlagBrowserItem(title: "Save Changes",
                                subtitle: "Save changes to the field above",
                                accessoryType: .disclosureIndicator,
                                selectable: isWritableProvider,
                                disabled: !isWritableProvider,
                                cellType: .default,
                                actionType: .setStringValue)
            ])
        case is Bool.Type:
            dataSection.childs.append(
                FlagBrowserItem(title: "True",
                                accessoryType: ((value as? Bool) == true ? .checkmark : .none),
                                selectable: isWritableProvider,
                                disabled: !isWritableProvider,
                                actionType: .setBoolValue(true))
            )
            dataSection.childs.append(
                FlagBrowserItem(title: "False",
                                accessoryType: ((value as? Bool) == false ? .checkmark : .none),
                                selectable: isWritableProvider,
                                disabled: !isWritableProvider,
                                actionType: .setBoolValue(false))
            )
        case is Int.Type, is Int8.Type, is Int16.Type, is Int32.Type, is Int64.Type:
            dataSection.childs.append(
                FlagBrowserItem(title: "Int Value",
                                subtitle: "Tap to modify the value",
                                value: String(describing: value!),
                                accessoryType: (value != nil ? .checkmark : .none),
                                selectable: isWritableProvider,
                                disabled: !isWritableProvider,
                                actionType: .setNumericValue(.int))
            )
            
        case is Double.Type:
            dataSection.childs.append(
                FlagBrowserItem(title: "Double Value",
                                subtitle: "Tap to modify the value",
                                value: String(describing: value!),
                                accessoryType: (value != nil ? .checkmark : .none),
                                selectable: isWritableProvider,
                                disabled: !isWritableProvider,
                                actionType: .setNumericValue(.double))
            )
            
        case is JSONData.Type:
            dataSection.childs.append(contentsOf: [
                FlagBrowserItem(value: (value as? String) ?? "",
                                disabled: !isWritableProvider,
                                cellType: .entryTextField,
                                actionType: .setJSONValue),
                FlagBrowserItem(title: "Save Changes",
                                subtitle: "Save changes to the field above",
                                accessoryType: .disclosureIndicator,
                                selectable: isWritableProvider,
                                disabled: !isWritableProvider,
                                cellType: .default,
                                actionType: .setJSONValue)
            ])
            
        default:
            // Cannot edit these objects (Conforms to codable) directly via IDE
            isWritableObject = false
        }
        
        if isWritableObject {
            // Clear current value
            dataSection.childs.append(
                FlagBrowserItem(title: "Nil (No Value)",
                                subtitle: "Tap to clear current value (if any)",
                                accessoryType: (value == nil ? .checkmark : .none),
                                selectable: isWritableProvider,
                                disabled: !isWritableProvider,
                                actionType: .clearValue)
            )
        } else {
            dataSection.childs.append(
                FlagBrowserItem(title: "Cannot Edit Value",
                                subtitle: "Value is not editable via IDE, continue via code",
                                selectable: false,
                                disabled: true)
            )
        }
        
        return [infoSection, dataSection]
    }
    
    private func reloadDataForLoaders(_ loaders: [AnyFlagsLoader]) -> [FlagBrowserItem] {
        loaders.map { FlagBrowserItem(loader: $0) }
    }
    
    private func reloadDataForFlagCollection(_ flag: AnyFlagCollection) -> [FlagBrowserItem] {
        let section = FlagBrowserItem(title: "\(flag.hierarchyFeatureFlags().count) Feature Flags")
        section.childs = flagsInList(flag.hierarchyFeatureFlags())
        return [section]
    }
    
    private func reloadDataForLoader(_ loader: AnyFlagsLoader) -> [FlagBrowserItem] {
        let section = FlagBrowserItem(title: "\(loader.hierarcyFeatureFlags.count) Feature Flags")
        section.childs = flagsInList(loader.hierarcyFeatureFlags)
        return [section]
    }
    
    private func reloadDataForFlag(_ flag: AnyFlag) -> [FlagBrowserItem] {
        var sections = [FlagBrowserItem]()
        
        // MAIN INFO
        let mainSection = FlagBrowserItem(title: "INFORMATIONS")
        mainSection.childs = [
            FlagBrowserItem(title: "KeyPath", subtitle: flag.keyPath.fullPath, value: flag.name),
            FlagBrowserItem(title: "Data Type", value: flag.readableDataType),
            FlagBrowserItem(title: "Default Value", value: flag.readableDefaultFallbackValue),
            FlagBrowserItem(title: "Description", subtitle: flag.description)
        ]
        sections.append(mainSection)
        
        // CURRENT VALUE
        let resultDescription = flag.getValueDescriptionForFlag(from: nil)
        let currentValueSection = FlagBrowserItem(title: "CURRENT VALUE")
        currentValueSection.childs = [
            FlagBrowserItem(title: "Value", value: resultDescription.value),
            FlagBrowserItem(title: "From", value: resultDescription.sourceProvider?.name ?? "(Default Value)")
        ]
        sections.append(currentValueSection)
        
        // HIERARCHY SOURCE PROVIDERS
        let providersSection = FlagBrowserItem(title: "HIERARCHY SOURCE PROVIDERS")
        providersSection.childs = flag.providers.map({ provider -> FlagBrowserItem in
            let isDisabled = flag.excludedProviders?.contains(where: { $0 == type(of: provider) }) ?? false
            let item = FlagBrowserItem(title: provider.name,
                                       subtitle: provider.shortDescription,
                                       value: flag.getValueDescriptionForFlag(from: type(of: provider)).value.trunc(length: 20),
                                       accessoryType: .disclosureIndicator)
            item.isDisabled = isDisabled
            item.isSelectable = !isDisabled
            item.representedObj = FlagInProvider(flag: flag, provider: provider)
            return item
        })
        sections.append(providersSection)
        
        return sections
    }
    
    private func flagsInList(_ list: [AnyFlagOrCollection]) -> [FlagBrowserItem] {
        list.compactMap { flag -> FlagBrowserItem? in
            if flag.metadata.isInternal {
                return nil // hidden to the browser
            }
            
            switch flag {
            case let flag as AnyFlag:
                return FlagBrowserItem(title: flag.name,
                                       subtitle: flag.description,
                                       value: flag.getValueDescriptionForFlag(from: nil).value,
                                       icon: flag.icon,
                                       accessoryType: .disclosureIndicator,
                                       selectable: true, representedObj: flag)
                
            case let collection as AnyFlagCollection:
                return FlagBrowserItem(title: collection.name,
                                       subtitle: collection.description,
                                       icon: UIImage(named: "datatype_list", in: .module, with: nil),
                                       accessoryType: .disclosureIndicator,
                                       selectable: true,
                                       representedObj: collection)
                
            default:
                return nil
            }
        }
    }
    
    private func didSelectItem(_ item: FlagBrowserItem, cell: UITableViewCell?) {
        guard let value = item.representedObj else {
            didSelectAction(item.actionType, cell: cell)
            return
        }
        
        switch value {
        case let loader as AnyFlagsLoader:
            createAndPushBrowserController(withData: .flags(loader), title: loader.collectionType)
            
        case let flag as AnyFlag:
            createAndPushBrowserController(withData: .flag(flag), title: flag.name)
            
        case let collection as AnyFlagCollection:
            createAndPushBrowserController(withData: .flagsInCollection(collection), title: collection.name)
            
        case let flagInProvider as FlagInProvider:
            createAndPushBrowserController(withData: .flagData(flagInProvider), title: flagInProvider.provider.name)
            
        default:
            didSelectAction(item.actionType, cell: cell)
            
        }
    }
    
    private func didSelectAction(_ action: FlagBrowserItem.ActionType, cell: UITableViewCell?) {
        do {
            switch action {
            case .none:
                break
                
            case .clearValue:
                guard case .flagData(let flagInProvider) = data else { return }
                
                let value: Bool? = nil
                try flagInProvider.provider.setValue(value, forFlag: flagInProvider.flag.keyPath)
                goBackInNavigation()
                
            case .setBoolValue(let value):
                guard case .flagData(let flagInProvider) = data else { return }
                
                try flagInProvider.provider.setValue(value, forFlag: flagInProvider.flag.keyPath)
                goBackInNavigation()
                
            case .setStringValue:
                guard case .flagData(let flagInProvider) = data,
                      let entryCell = firstEntryFieldCell() else {
                    return
                }
                
                if let newValue = entryCell.valueField.text, newValue.isEmpty == false {
                    try flagInProvider.provider.setValue(newValue, forFlag: flagInProvider.flag.keyPath)
                    goBackInNavigation()
                }
                
            case .setNumericValue(let valueType):
                guard case .flagData(let flagInProvider) = data else { return }
                
                let alert = UIAlertController(title: "Set Numeric Value", message: nil, preferredStyle: .alert)
                alert.addTextField { field in
                    field.keyboardType = .numbersAndPunctuation
                    field.autocorrectionType = .no
                }
                alert.addAction(UIAlertAction(title: "Set", style: .default, handler: { [weak self] _ in
                    guard let value = alert.textFields?.first?.text, value.isEmpty == false else {
                        return
                    }
                    
                    do {
                        switch valueType {
                        case .double:
                            let doubleValue = Double(value)
                            try flagInProvider.provider.setValue(doubleValue, forFlag: flagInProvider.flag.keyPath)
                        case .float:
                            let floatValue = Float(value)
                            try flagInProvider.provider.setValue(floatValue, forFlag: flagInProvider.flag.keyPath)
                        case .int:
                            let intValue = Int(value)
                            try flagInProvider.provider.setValue(intValue, forFlag: flagInProvider.flag.keyPath)
                        }
                        
                        self?.goBackInNavigation()
                    } catch {
                        self?.showErrorMessage("Failed to cast value", message: error.localizedDescription)
                    }
                    
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                
            case .setJSONValue:
                guard case .flagData(let flagInProvider) = data,
                      let entryCell = firstEntryFieldCell() else {
                    return
                }

                if let newValue = entryCell.valueField.text, newValue.isEmpty == false,
                   let jsonData = JSONData(jsonString: newValue) {
                    try flagInProvider.provider.setValue(jsonData, forFlag: flagInProvider.flag.keyPath)
                    goBackInNavigation()
                }
            }
        } catch {
            
        }
    }
    
    private func firstEntryFieldCell() -> FlagBrowserDataCell? {
        tableView?.visibleCells.first(where: { $0 as? FlagBrowserDataCell != nil }) as? FlagBrowserDataCell
    }
    
    private func showErrorMessage(_ title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func createAndPushBrowserController(withData data: DataType, title: String?) {
        let controller = UIStoryboard(name: "FlagsBrowserController", bundle: .module).instantiateInitialViewController() as! FlagsBrowserController
        controller.title = title ?? ""
        controller.data = data
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func goBackInNavigation() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - FlagsBrowserController (UITableViewDataSource, UITableViewDelegate)

extension FlagsBrowserController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        items.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        items[section].title
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items[section].childs.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section].childs[indexPath.row]
        
        switch item.cellType {
        case .default:
            let cell = FlagsBrowserDefaultCell.dequeue(from: tableView, for: indexPath)
            _ = cell.contentView
            
            cell.set(title: item.title, subtitle: item.subtitle, value: item.value, image: item.icon)
            cell.accessoryType = item.accessoryType
            cell.isDisabled = item.isDisabled
            return cell
            
        case .entryTextField:
            let cell = FlagBrowserDataCell.dequeue(from: tableView, for: indexPath)
            cell.parentTableView = tableView
            cell.set(title: "Data", value: item.value ?? "")
            cell.accessoryType = item.accessoryType
            cell.isDisabled = item.isDisabled
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let item = items[indexPath.section].childs[indexPath.row]
        return item.isSelectable
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items[indexPath.section].childs[indexPath.row]
        didSelectItem(item, cell: tableView.cellForRow(at: indexPath))
    }
    
}

extension AnyFlag {
    
    var readableDefaultFallbackValue: String {
        guard let val = defaultFallbackValue else {
            return "<null>"
        }
        
        return String(describing: val)
    }
 
    var icon: UIImage? {
        if let customIcon = metadata.uiIcon {
            return customIcon
        }
        
        // Default data type icons
        switch dataType {
        case is String.Type:
            return UIImage(named: "datatype_string", in: .module, with: .none)
            
        case is Bool.Type:
            return UIImage(named: "datatype_bool", in: .module, with: .none)

        case is Int.Type, is Int8.Type, is Int16.Type, is Int32.Type, is Int64.Type:
            return UIImage(named: "datatype_number", in: .module, with: .none)
            
        case is Double.Type:
            return UIImage(named: "datatype_number", in: .module, with: .none)
            
        case is JSONData.Type:
            return UIImage(named: "datatype_json", in: .module, with: .none)
            
        default:
            return nil
            
        }
    }
    
}
