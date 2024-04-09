//
//  LatestNewsCell.swift
//  cricrate
//


import UIKit

class LatestNewsCell: UITableViewCell
{
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var youtubeImgVw: UIImageView!
    @IBOutlet weak var latestNewsImage: UIImageView!
    @IBOutlet weak var lastestNewsHeadline: UILabel!
    @IBOutlet weak var CardView: UIView!
    @IBOutlet weak var latestNewsDate: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    //MARK:- View LifeCycle
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.CardView.layer.cornerRadius = 6.0
        self.CardView.clipsToBounds = true
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        youtubeImgVw.isHidden = true
    }
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(newsData:CLGHomeResponseDataNewsV3,newsPath:String){
        self.CardView.layer.borderColor = UIColor.clear.cgColor
        self.lastestNewsHeadline?.text = ""
        
        if let created = newsData.created{
            let createdDate = AppHelper.stringToGmtDate(strDate: created, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, MMMM dd - h:mm a"
            self.latestNewsDate.text = dateFormatter.string(from: createdDate!)
        }
        else{
            self.latestNewsDate.text = "N/A"
        }
        
        if let title = newsData.title{
            self.titleLbl?.text = title
        }
        else{
            self.titleLbl?.text = "N/A"
        }
        
        /*if let thumbUrl = newsData.image{
            self.latestNewsImage.af_setImage(withURL: URL(string: (newsPath+thumbUrl).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        }
        else{
            self.latestNewsImage.image = UIImage(named: "news_placeholder")
        }*/
        
        if let image = newsData.image, image != ""{
            if let url = URL(string: (newsPath+image))
            {
                self.latestNewsImage.af_setImage(withURL: url)
            }
        }
        
        if(newsData.is_link == true)
        {
            self.youtubeImgVw.isHidden = false
            
        }
        else{
            
            self.youtubeImgVw.isHidden = true
            
        }
    }
}
