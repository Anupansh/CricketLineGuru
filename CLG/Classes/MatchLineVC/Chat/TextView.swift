//
//  TextView.swift
//  CLG
//
//  Created by Sani Kumar on 27/05/19.
//  Copyright © 2019 Anuj Naruka. All rights reserved.
//

import UIKit

class TextView: UITextView {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) ||
            action == #selector(cut(_:)) ||
            action == #selector(copy(_:)) ||
            action == #selector(select(_:)) ||
            action == #selector(selectAll(_:)) ||
            action == #selector(delete(_:)) ||
            action == #selector(makeTextWritingDirectionLeftToRight(_:)) ||
            action == #selector(makeTextWritingDirectionRightToLeft(_:)) ||
            action == #selector(toggleBoldface(_:)) ||
            action == #selector(toggleItalics(_:)) ||
            action == #selector(toggleUnderline(_:)) ||
            action == Selector(("_lookup:")) ||
            action == Selector(("_share:")) ||
            action == Selector(("_define:"))
            {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }


}
