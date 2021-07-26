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

public class FlagsBrowserDefaultCell: UITableViewCell, Reusable, NibType {
    
    // MARK: - IBOutlets
    
    @IBOutlet public var subtitleLabel: UILabel!
    @IBOutlet public var titlelabel: UILabel!
    @IBOutlet public var valueLabel: UILabel!
    @IBOutlet public var iconView: UIImageView!
    @IBOutlet public var iconContainerView: UIView!
    @IBOutlet public var stackView: UIStackView!
    @IBOutlet public var labelsStackView: UIStackView!
    
    public var isDisabled: Bool = false {
        didSet {
            titlelabel.textColor = (isDisabled ? .lightGray : .black)
            valueLabel.textColor = (isDisabled ? .red : .tintColor)
            subtitleLabel.textColor = (isDisabled ? .lightGray : .darkGray)
        }
    }

    public static var nibBundle: Bundle {
        .libraryBundle
    }
    
    // MARK: - Public Functions

    public func set(title: String? = nil, subtitle: String? = nil, value: String? = nil, image: UIImage? = nil) {
        iconView.image = image
        iconContainerView.isHidden = (image == nil)
        
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

// MARK: - UIColor Extension

extension UIColor {
    
    static var tintColor: UIColor {
        UIApplication.shared.windows.first?.rootViewController?.view.tintColor ?? .blue
    }
    
}
