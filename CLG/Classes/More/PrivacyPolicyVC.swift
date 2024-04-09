//
//  PrivacyPolicyVC.swift
//  CLG
//
//  Created by Sani Kumar on 14/05/19.
//  Copyright © 2019 Anuj Naruka. All rights reserved.
//

import UIKit

class PrivacyPolicyVC: BaseViewController {

    @IBOutlet weak var privacyLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let privacyString = "<html>\n" +
            "<body>\n" +
            "<h3><br>Privacy Policy</h3>\n" +
            "\n" +
            "Our extensive knowledge about the system and corresponding analysis enables us to provide an approximate of the match winning chances. Cricket Line Guru by no means supports betting and we are not responsible for any unlawful action taken on the part of the user. The app is meant purely for entertainment purposes. The user is solely responsible for any illegal activates done by them.\n" +
            "\n" +
            "<h3><br>User Information:</h3>\n" +
            "\n" +
            "The information provided by the users enables us to improve our application and provide you the most user-friendly experience. All required information is service dependent and we may use the above-said user information to, maintain, protect and improve services and for developing new services\n" +
            "\n" +
            "<h3><br>Information security:</h3>\n" +
            "\n" +
            "All the information gathered on our App is securely stored within our controlled database. The database is stored on the servers is password protected and is strictly limited. However, as effective as our security measures are, no security system is impenetrable. We cannot guarantee the security of our database, nor can we guarantee that information provided by you will not be intercepted while being transmitted to us over the internet. We may change our privacy policy from time to time to incorporate necessary future changes.\n" +
            "\n" +
            "</body>\n" +
        "</html>"
        self.privacyLbl.attributedText = privacyString.html2AttributedString
        self.setupNavigationBarTitle("PRIVACY POLICY", navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [])
        self.hideNavigationBar(false)
    }

}
