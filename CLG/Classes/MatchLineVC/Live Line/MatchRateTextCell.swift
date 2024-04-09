//
//  MatchRateTextCell.swift
//  cricrate


import UIKit

class MatchRateTextCell: UITableViewCell {
    
    //MARK:-IBOutlets
    @IBOutlet weak var movingLbl: MarqueeLabel!
    @IBOutlet weak var lblDescription: UILabel!
    var textUrl : URL? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClicLabel(sender:)))
        tap.numberOfTapsRequired = 1
        self.lblDescription.isUserInteractionEnabled = true
        self.lblDescription.addGestureRecognizer(tap)
        let text = self.lblDescription.text
        let types: NSTextCheckingResult.CheckingType = .link
        
        do {
            let detector = try NSDataDetector(types: types.rawValue)
            let matches = detector.matches(in: text ?? "", options: .reportCompletion, range: NSMakeRange(0, text?.count ?? 0))
            if matches.count > 0 {
                let url = matches[0].url!
                print("Opening URL: \(url)")
                // UIApplication.sharedApplication.openURL(url)
                self.textUrl = matches[0].url!
                
            }
            
        } catch {
            // none found or some other issue
            print ("error in findAndOpenURL detector")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    // And that's the function :)
    @objc func onClicLabel(sender:UITapGestureRecognizer) {
        //openUrl(self.textUrl)
        if let texturl = self.textUrl {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(texturl, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(texturl)
            }
        }
    }
    
    
    func openUrl(url:URL) {
        //let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
