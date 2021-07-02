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

// MARK: - FlagsBrowserController

public class FlagsBrowserController: UIViewController {
    
    public enum DataType {
        case flag(AnyFlag)
        case collectionsOfLoader(AnyFlagsLoader)
        case loaders([AnyFlagsLoader])
    }
    
    // MARK: - Private Properties
    
    /// Loaded loaders.
    public private(set) var data: DataType
    public private(set) var items = [FlagBrowserItem]()

    /// Tableview of the content.
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.registerNib(type: FlagsBrowserDefaultCell.self)
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    // MARK: - Initialization (with Navigation)
    
    public static func create(manager: FlagsManager, title: String? = nil) -> UINavigationController {
        create(loaders: Array(manager.loaders.values), title: title)
    }
    
    public static func create(loaders: [AnyFlagsLoader], title: String? = nil) -> UINavigationController {
        let controller = FlagsBrowserController.init(data: .loaders(loaders), title: title)
        let navigation = UINavigationController(rootViewController: controller)
        return navigation
    }
    
    // MARK: - Initialization (Private)
    
    fileprivate init(data: DataType, title: String? = nil) {
        self.data = data
        super.init(nibName: nil, bundle: nil)

        self.title = title ?? "FeatureFlags Browser"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view = tableView
        reloadData()
    }
    
    // MARK: - Private Functions
    
    private func reloadData() {
        switch data {
        case .collectionsOfLoader(let collection):
            break
        case .flag(let flag):
            break
        case .loaders(let loaders):
            self.items = reloadDataForLoaders(loaders)
        
        }
    }
    
    private func reloadDataForLoaders(_ loaders: [AnyFlagsLoader]) -> [FlagBrowserItem] {
        loaders.map { FlagBrowserItem(loader: $0) }
    }
    
    private func didSelectItem(_ item: FlagBrowserItem) {
        guard let value = item.representedObj else {
            return
        }
        
        switch value {
        case let loader as AnyFlagsLoader:
            browseLoader(loader)
            
        default:
            break
        }
    }
    
    private func browseLoader(_ loader: AnyFlagsLoader) {
        let data: DataType = .collectionsOfLoader(loader)
        let controller = FlagsBrowserController(data: data, title: loader.collectionType)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

// MARK: - FlagsBrowserController (UITableViewDataSource, UITableViewDelegate)

extension FlagsBrowserController: UITableViewDataSource, UITableViewDelegate {
    
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
        
        let cell = FlagsBrowserDefaultCell.dequeue(from: tableView, for: indexPath)
        _ = cell.contentView
        
        cell.set(title: item.title, subtitle: item.subtitle, value: item.value, image: nil)
        cell.accessoryType = item.accessoryType
        return cell
    }
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let item = items[indexPath.section].childs[indexPath.row]
        return item.isSelectable
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items[indexPath.section].childs[indexPath.row]
        didSelectItem(item)
    }
    
}

