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

public class FlagsBrowserDefaultCell: UITableViewCell, Reusable, NibType {
    
    // MARK: - IBOutlets
    
    @IBOutlet public var subtitleLabel: UILabel!
    @IBOutlet public var titlelabel: UILabel!
    @IBOutlet public var valueLabel: UILabel!
    @IBOutlet public var iconView: UIImageView!
    @IBOutlet public var stackView: UIStackView!
    @IBOutlet public var labelsStackView: UIStackView!
    
    public var isDisabled: Bool = false {
        didSet {
            titlelabel.textColor = (isDisabled ? .lightGray : .black)
            valueLabel.textColor = (isDisabled ? .red : .tintColor)
            subtitleLabel.textColor = (isDisabled ? .lightGray : .darkGray)
            print(isDisabled)
        }
    }

    public static var nibBundle: Bundle {
        .module
    }
    
    // MARK: - Public Functions

    public func set(title: String? = nil, subtitle: String? = nil, value: String? = nil, image: UIImage? = nil) {
        iconView.image = image
        iconView.isHidden = (image == nil)
        
        titlelabel.text = title
        subtitleLabel.text = subtitle
        valueLabel.text = value
        
        titlelabel.isHidden = title?.isEmpty ?? true
        subtitleLabel.isHidden = subtitle?.isEmpty ?? true
        valueLabel.isHidden = value?.isEmpty ?? true
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.isDisabled = false
    }
    
}

extension UIColor {
    static var tintColor: UIColor {
        get {
            UIApplication.shared.windows.first?.rootViewController?.view.tintColor ?? .blue
        }
    }
}
