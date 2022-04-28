//
//  transactionCell.swift
//  MyDailyTransactionApp
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 28/04/22.
//

import UIKit

class transactionCell: UITableViewCell {

    @IBOutlet weak var transactionView: UIView!
    @IBOutlet weak var transactionName: UILabel!
    @IBOutlet weak var transactionDate: UILabel!
    @IBOutlet weak var transactionBudget: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
