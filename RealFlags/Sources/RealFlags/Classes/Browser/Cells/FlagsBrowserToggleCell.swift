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

public class FlagsBrowserToggleCell: FlagsBrowserDefaultCell { //, Reusable, NibType {
    
    // MARK: - IBOutlets
    
    @IBOutlet public var switchButton: UISwitch!
    
    // MARK: - Public Properties
    
    /// Callback to listen and react to event. If return `false` the previous value will be restored.
    public var onChangeSwitchValue: ((Bool) -> Bool)?
    
    // MARK: - IBAction
    
    @IBAction public func didChangeSwitchValue(_ sender: UISwitch) {
        if onChangeSwitchValue?(switchButton.isOn) == false {
            switchButton.isOn = !switchButton.isOn // restore previous value
        }
    }
    
}
