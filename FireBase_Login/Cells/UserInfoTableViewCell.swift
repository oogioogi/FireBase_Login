//
//  UserInfoTableViewCell.swift
//  FireBase_Login
//
//  Created by 이용석 on 2021/01/10.
//

import UIKit
import Firebase

class UserInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    var user: User? {
        didSet{
            self.emailLabel.text = user?.email
            self.nameLabel.text = user?.name
            guard let time = user?.creatAt.dateValue() else { return }
            self.timeStampLabel.text = dateformatterForDateLabel(date: time)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    private func dateformatterForDateLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "Ko-Kr")
        return formatter.string(from: date)
    }
}
