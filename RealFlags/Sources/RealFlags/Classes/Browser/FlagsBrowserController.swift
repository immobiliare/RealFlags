//
//  RealFlags
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

public class FlagsBrowserController: UIViewController {
    
    // MARK: - DataType

    public enum DataType {
        case loaders([AnyFlagsLoader])
        case flags(AnyFlagsLoader)
        case flagsInCollection(AnyFlagCollection)
        case flag(AnyFlag)
        case flagData(FlagInProvider)
    }
    
    // MARK: - Private Properties
    
    /// Loaded loaders.
    public private(set) var data: DataType!
    public private(set) var items = [FlagBrowserItem]()
    
    /// Section footer's title
    private var sectionFooters = [Int: String]()
    
    /// Tableview of the content.
    @IBOutlet public var tableView: UITableView?
    
    // MARK: - Initialization (with Navigation)
    
    public static func create(manager: FlagsManager, title: String? = nil) -> UINavigationController {
        create(loaders: Array(manager.loaders.values), title: title)
    }
    
    public static func create(loaders: [AnyFlagsLoader], title: String? = nil) -> UINavigationController {
        guard let controller = UIStoryboard(name: "FlagsBrowserController", bundle: .libraryBundle).instantiateInitialViewController() as? FlagsBrowserController else {
            fatalError("Failed to get FlagsBrowserController from xib")
        }
        
        controller.title = title ?? "Feature Flags"
        controller.data = .loaders(loaders)
        
        let navigation = UINavigationController(rootViewController: controller)
        return navigation
    }
    
    // MARK: - View Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.registerNib(type: FlagsBrowserDefaultCell.self)
        tableView?.registerNib(type: FlagBrowserDataCell.self)
        tableView?.registerNib(type: FlagsBrowserToggleCell.self)
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
    
    // swiftlint:disable function_body_length
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
        let valueIsEditable = (isWritableProvider && isWritableObject)
        
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
                                selectable: valueIsEditable,
                                disabled: !valueIsEditable,
                                cellType: .default,
                                actionType: .setStringValue)
            ])
        case is Bool.Type:
            dataSection.childs.append(
                FlagBrowserItem(title: "True",
                                accessoryType: ((value as? Bool) == true ? .checkmark : .none),
                                selectable: valueIsEditable,
                                disabled: !valueIsEditable,
                                actionType: .setBoolValue(true))
            )
            dataSection.childs.append(
                FlagBrowserItem(title: "False",
                                accessoryType: ((value as? Bool) == false ? .checkmark : .none),
                                selectable: valueIsEditable,
                                disabled: !valueIsEditable,
                                actionType: .setBoolValue(false))
            )
        case is Int.Type, is Int8.Type, is Int16.Type, is Int32.Type, is Int64.Type, is UInt8.Type, is UInt16.Type, is UInt32.Type, is UInt64.Type:
            dataSection.childs.append(
                FlagBrowserItem(title: "Int Value",
                                subtitle: "Tap to modify the value",
                                // swiftlint:disable force_unwrapping
                                value: String(describing: value!),
                                accessoryType: (value != nil ? .checkmark : .none),
                                selectable: valueIsEditable,
                                disabled: !valueIsEditable,
                                actionType: .setNumericValue(.int))
            )
            
        case is Double.Type:
            dataSection.childs.append(
                FlagBrowserItem(title: "Double Value",
                                subtitle: "Tap to modify the value",
                                value: String(describing: value!),
                                accessoryType: (value != nil ? .checkmark : .none),
                                selectable: valueIsEditable,
                                disabled: !valueIsEditable,
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
                                selectable: valueIsEditable,
                                disabled: !valueIsEditable,
                                cellType: .default,
                                actionType: .setJSONValue)
            ])
            
        default:
            // Cannot edit these objects (Conforms to codable) directly via IDE
            isWritableObject = false
        }
        
        if isWritableObject && isWritableProvider {
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
            if isWritableProvider == false {
                sectionFooters[1] = "This data provider is ready only and does not support value set."
            }
            if isWritableObject == false {
                sectionFooters[1] = "This property is locked and cannot be edited via user interface."
            }
        }
        
        return [infoSection, dataSection]
    }
    
    private func reloadDataForLoaders(_ loaders: [AnyFlagsLoader]) -> [FlagBrowserItem] {
        let collections = loaders.map({ FlagBrowserItem(loader: $0) }).sorted { l, r in
            l.order < r.order // follow the order when available
        }
        let section = FlagBrowserItem(title: "\(collections.count) COLLECTIONS")
        section.childs = collections
        return [section]
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
            FlagBrowserItem(title: "Current Value", value: resultDescription.value),
            FlagBrowserItem(title: "Provider Source", value: resultDescription.sourceProvider?.name ?? "(Default Value)")
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
                // For boolean flags we want to show a fast toggle directly on tag page without
                // the needs to open the detail panel to alter value.
                let isLocalWritableBooleanFlag = flag.dataType == Bool.self && flag.hasWritableProvider
                let cellType: FlagBrowserItem.CellType = (isLocalWritableBooleanFlag ? .booleanToggle : .default)
                
                return FlagBrowserItem(title: flag.name,
                                       subtitle: flag.description,
                                       value: flag.getValueDescriptionForFlag(from: nil).value,
                                       icon: flag.icon,
                                       accessoryType: .detailButton,
                                       selectable: false,
                                       representedObj: flag,
                                       cellType: cellType)
                
            case let collection as AnyFlagCollection:
                return FlagBrowserItem(title: collection.name,
                                       subtitle: collection.description,
                                       icon: UIImage(named: "datatype_list", in: .libraryBundle, with: nil),
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
            createAndPushBrowserController(withData: .flags(loader),
                                           title: loader.metadata?.name ?? loader.collectionType)
            
        case let flag as AnyFlag:
            let isLocked = (flag.isUILocked)
            createAndPushBrowserController(withData: .flag(flag),
                                           title: "\(flag.name) \(isLocked ? " 🔒" : "")")
            
        case let collection as AnyFlagCollection:
            createAndPushBrowserController(withData: .flagsInCollection(collection),
                                           title: collection.name)
            
        case let flagInProvider as FlagInProvider:
            let isLocked = (!flagInProvider.provider.isWritable || flagInProvider.flag.isUILocked)
            createAndPushBrowserController(withData: .flagData(flagInProvider),
                                           title: "\(flagInProvider.provider.name) \(isLocked ? " 🔒" : "")")
            
        default:
            didSelectAction(item.actionType, cell: cell)
            
        }
    }
    
    // MARK: - Miscs
    
    internal func showErrorMessage(_ title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    internal func createAndPushBrowserController(withData data: DataType, title: String?) {
        guard let controller = UIStoryboard(name: "FlagsBrowserController", bundle: .libraryBundle).instantiateInitialViewController() as? FlagsBrowserController else {
            return
        }
        
        controller.title = title ?? ""
        controller.data = data
        navigationController?.pushViewController(controller, animated: true)
    }
    
    internal func goBackInNavigation() {
        navigationController?.popViewController(animated: true)
    }
    
    internal func toggleBooleanValueForFlag(_ flag: AnyFlag?, value: Bool) -> Bool {
        guard let flag = flag else { return false }
        
        let providers = flag.providers.filter({ $0.isWritable })
        guard providers.isEmpty == false else { return false }
        
        do {
            for provider in providers {
                try provider.setValue(value, forFlag: flag.keyPath)
            }
            return true
        } catch {
            showErrorMessage("Failed to set toggle value for '\(flag.name)'", message: error.localizedDescription)
            return false
        }
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
            cell.accessoryView = item.accessoryType != .none ? nil : UIView(frame: .init(x: 0, y: 0, width: 10, height: 0))
            cell.isDisabled = item.isDisabled
            return cell
            
        case .booleanToggle:
            let cell = FlagsBrowserToggleCell.dequeue(from: tableView, for: indexPath)
            _ = cell.contentView
            
            cell.set(title: item.title, subtitle: item.subtitle, value: item.value, image: item.icon)
            cell.accessoryType = item.accessoryType
            cell.accessoryView = item.accessoryType != .none ? nil : UIView(frame: .init(x: 0, y: 0, width: 10, height: 0))
            cell.isDisabled = item.isDisabled
            cell.onChangeSwitchValue = { [weak self] newValue in
                return self?.toggleBooleanValueForFlag(item.representedObj as? AnyFlag, value: newValue) ?? false
            }
            cell.switchButton.isOn = ((item.representedObj as? AnyFlag)?.getValueForFlag(from: nil) as? Bool) ?? false
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
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        sectionFooters[section]
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
    
    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let item = items[indexPath.section].childs[indexPath.row]
        if let _ = item.representedObj as? AnyFlag {
            // Info about a particular flag
            didSelectItem(item, cell: tableView.cellForRow(at: indexPath))
        }
    }
    
}

// MARK: - AnyFlag Extension

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
            return UIImage(named: "datatype_string", in: .libraryBundle, with: .none)
            
        case is Bool.Type:
            return UIImage(named: "datatype_bool", in: .libraryBundle, with: .none)

        case is Int.Type, is Int8.Type, is Int16.Type, is Int32.Type, is Int64.Type:
            return UIImage(named: "datatype_number", in: .libraryBundle, with: .none)
            
        case is Double.Type:
            return UIImage(named: "datatype_number", in: .libraryBundle, with: .none)
            
        case is JSONData.Type:
            return UIImage(named: "datatype_json", in: .libraryBundle, with: .none)
            
        default:
            return nil
            
        }
    }
    
}

// MARK: - FlagInProvider

public struct FlagInProvider {
    var flag: AnyFlag
    var provider: FlagsProvider
    
    internal init(flag: AnyFlag, provider: FlagsProvider) {
        self.flag = flag
        self.provider = provider
    }
    
}
