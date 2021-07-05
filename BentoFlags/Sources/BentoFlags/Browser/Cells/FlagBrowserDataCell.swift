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

public class FlagBrowserDataCell: UITableViewCell, Reusable, NibType, UITextViewDelegate {
    
    // MARK: - Public Properties
    
    @IBOutlet public var valueField: UITextView!
    @IBOutlet public var titleLabel: UILabel!
    @IBOutlet public var saveButton: UIButton!
    
    public weak var parentTableView: UITableView?
    public var onTapSaveStringData: ((String) -> Void)?
    
    public var isDisabled: Bool = false {
        didSet {
            valueField.textColor = (isDisabled ? .lightGray : .black)
            titleLabel.textColor = (isDisabled ? .lightGray : .black)
            saveButton.isHidden = isDisabled
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
        print("\(newSize)")
    }
    
    @IBAction public func didTapSave(_ sender: UIButton) {
        onTapSaveStringData?(valueField.text)
    }
    
}
