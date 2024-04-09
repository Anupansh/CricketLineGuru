//
//  LanguageCell.swift
//  CLG
//
//  Created by Anuj Naruka on 8/28/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class LanguageCell: UITableViewCell {
    @IBOutlet weak var btnHinLang: UIButton!
    @IBOutlet weak var btnEngLang: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        btnHinLang.layer.cornerRadius = 3.0
        btnEngLang.layer.cornerRadius = 3.0
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
