//
//  TermsOfUseVC.swift
//  CLG
//
//  Created by Sani Kumar on 14/05/19.
//  Copyright © 2019 Anuj Naruka. All rights reserved.
//

import UIKit

class TermsOfUseVC: BaseViewController {

    @IBOutlet weak var termsOfUseLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let termsofuseString = "<html>\n" +
        "<body>\n" +
        "<h3><br>Terms of use</h3>\n" +
        "\n" +
        "This page states the terms and conditions under which you (Visitor) may visit this application. Please read this page carefully.\n" +
        "\n" +
        "Cricket Line guru is the cricket score and news application the odds and session displayed are based in our experience and analysis of system. We do not support or promote betting, gambling, legal or illegal. We are not responsible if betting is not legal in your country/state and you use Cricket Line Guru for any kind of illegal activity. The app is not for betting or supporting, this is meant for fun and entertainment purpose.\n" +
        "\n" +
        "<h3><br>Use of content:</h3>\n" +
        "The use of properties of the app like app logo, app name, except as provided in these terms and conditions or in the app content, is strictly prohibited. You not sell or modify the content of this application or reproduce, display, publicly perform, distribute, or otherwise use the materials in any way for any public or commercial purpose without the respective organisations’s or entity’s written permission.\n" +
        "\n" +
        "<h3><br>Disclaimer of consequential damage:</h3>\n" +
        "\n" +
        "The provider is not responsible for any loss or damage, direct or indirect, that the user might have suffered as result of using the app. The provider is not responsible for winnings made or loosed suffered with the third party which result from the use of information displayed on the mobile app. \n" +
        "</body>\n" +
        "</html>"
        self.termsOfUseLbl.attributedText = termsofuseString.html2AttributedString
        
        self.setupNavigationBarTitle("TERMS OF USE", navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [])
        self.hideNavigationBar(false)
    }
    
}

