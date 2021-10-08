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

extension FlagsBrowserController {
    
    // MARK: - Store Values
    
    public func didSelectAction(_ action: FlagBrowserItem.ActionType, cell: UITableViewCell?) {
        do {
            switch action {
            case .none:
                break
                
            case .clearValue:
                try setFlagClearValue()
                
            case .setBoolValue(let value):
                try setFlagBoolValue(value)
                
            case .setStringValue:
                try setFlagStringValue()
                
            case .setNumericValue(let valueType):
                try setFlagNumericValue(valueType)
                
            case .setJSONValue:
               try setFlagJSONValue()
                
            }
        } catch {
            
        }
    }
    
    private func setFlagClearValue() throws {
        guard case .flagData(let flagInProvider) = data else {
            return
        }
        
        let value: Bool? = nil
        try flagInProvider.provider.setValue(value, forFlag: flagInProvider.flag.keyPath)
        goBackInNavigation()
    }
    
    private func setFlagBoolValue(_ value: Bool) throws {
        guard case .flagData(let flagInProvider) = data else {
            return
        }
        
        try flagInProvider.provider.setValue(value, forFlag: flagInProvider.flag.keyPath)
        goBackInNavigation()
    }
    
    private func setFlagStringValue() throws {
        guard case .flagData(let flagInProvider) = data,
              let entryCell = firstEntryFieldCell() else {
            return
        }
        
        if let newValue = entryCell.valueField.text, newValue.isEmpty == false {
            try flagInProvider.provider.setValue(newValue, forFlag: flagInProvider.flag.keyPath)
            goBackInNavigation()
        }
    }
    
    private func setFlagNumericValue(_ valueType: FlagBrowserItem.NumericConversion) throws {
        guard case .flagData(let flagInProvider) = data else {
            return
        }
        
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
    }
    
    private func setFlagJSONValue() throws {
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
    
    private func firstEntryFieldCell() -> FlagBrowserDataCell? {
        tableView?.visibleCells.first(where: { $0 as? FlagBrowserDataCell != nil }) as? FlagBrowserDataCell
    }
    
}
