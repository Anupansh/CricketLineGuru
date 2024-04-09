//
//  DisclemerView.swift
//  cricrate
//


import UIKit

class DisclemerView: UIView, UITextViewDelegate {
    
    //MARK:-IBoutlets
    
    @IBOutlet weak var disclemerTextView: UITextView!
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var titleImgView: UIImageView!
    @IBOutlet weak var NoInfoLbl: UILabel!
    @IBOutlet weak var btnOkay: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:-VAriables and Constants
    
    let tipesText = [" Participate in polls to get rewards and win cash prizes."," Every time you participate and win the poll, we will reward you with 10 CLG points."," Users with the highest number of points will be listed amongst Top 20 CLG pollers."," Enter your Paytm number to get Paytm cash and enjoy shopping at your favourite merchants."]
    //Methods
    
    class func instansiateFromNib() -> DisclemerView
    {
        return Bundle.main.loadNibNamed("DisclemerView", owner: self, options: nil)! [0] as! DisclemerView
    }
    override func layoutSubviews()
    {
        self.disclemerTextView.contentOffset = CGPoint.zero
    }
    //MARK:-Display disclemer text
    func add(stringList: [String],
             font: UIFont,
             bullet: String = "\u{2022}",
             indentation: CGFloat = 20,
             lineSpacing: CGFloat = 2,
             paragraphSpacing: CGFloat = 12,
             textColor: UIColor = .gray,
             bulletColor: UIColor = .gray) -> NSAttributedString {
        
        let textAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: textColor]
        let bulletAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: bulletColor]
        
        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        //paragraphStyle.firstLineHeadIndent = 0
        //paragraphStyle.headIndent = 20
        //paragraphStyle.tailIndent = 1
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation
        
        let bulletList = NSMutableAttributedString()
        for string in stringList {
            let formattedString = "\(bullet)\t\(string)\n"
            let attributedString = NSMutableAttributedString(string: formattedString)
            
            attributedString.addAttributes(
                [NSAttributedStringKey.paragraphStyle : paragraphStyle],
                range: NSMakeRange(0, attributedString.length))
            
            attributedString.addAttributes(
                textAttributes,
                range: NSMakeRange(0, attributedString.length))
            
            let string:NSString = NSString(string: formattedString)
            let rangeForBullet:NSRange = string.range(of: bullet)
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            bulletList.append(attributedString)
        }
        
        return bulletList
    }
    func customUI(isTips:Bool)
    {
        disclemerTextView.delegate = self
        let cornerRadius : CGFloat = 10.0
        self.MainView.layer.cornerRadius = cornerRadius
        self.MainView.layer.masksToBounds = true
        btnOkay.applyGradient(colours: [UIColor.init(red: 59.0/255.0, green: 70.0/255.0, blue: 113.0/255.0, alpha: 1.0),UIColor.init(red: 78.0/255.0, green: 29.0/255.0, blue: 98.0/255.0, alpha: 1.0)])
        if isTips
        {
            NoInfoLbl.isHidden = true
            self.disclemerTextView.attributedText = self.add(stringList: tipesText, font: self.disclemerTextView.font!, bullet: "•")
            titleImgView.image = #imageLiteral(resourceName: "bulb")
            self.lblTitle.text = "Polls Tips"
        }
        else
        {
            if AppHelper.appDelegate().disclamer.isBlank
            {
                NoInfoLbl.isHidden = false
            }
            else
            {
                NoInfoLbl.isHidden = true
            }
            titleImgView.image = #imageLiteral(resourceName: "disclaimerYellow")
            self.disclemerTextView.text = "\(AppHelper.appDelegate().disclamer)"
            self.lblTitle.text = "DISCLAIMER"
        }
        
    }
    
    //MARK:-IBactions
    @IBAction func OkayBtnAct(_ sender: Any)
    {
         self.removeFromSuperview()
    }
}
