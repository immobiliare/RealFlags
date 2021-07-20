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

public class FlagBrowserDataCell: UITableViewCell, Reusable, NibType, UITextViewDelegate {
    
    // MARK: - Public Properties
    
    @IBOutlet public var valueField: UITextView!
    @IBOutlet public var titleLabel: UILabel!
    
    public weak var parentTableView: UITableView?
    
    public var isDisabled: Bool = false {
        didSet {
            valueField.textColor = (isDisabled ? .lightGray : .black)
            titleLabel.textColor = (isDisabled ? .lightGray : .black)
        }
    }
    
    // MARK: - Public Functions
    
    public func set(title: String, value: String) {
        valueField.text = value
        titleLabel.text = title
    }

    public static var nibBundle: Bundle {
        .module
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        valueField.delegate = self
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.isDisabled = false
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        guard let tableView = parentTableView else {
            return
        }
        
        UIView.setAnimationsEnabled(false)
        let newSize = textView.sizeThatFits(CGSize(width: contentView.frame.width, height: CGFloat.infinity))
        
        textView.constraints.first {
            $0.firstAttribute == .height
        }?.constant = newSize.height
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        UIView.setAnimationsEnabled(true)
    }
    
}
