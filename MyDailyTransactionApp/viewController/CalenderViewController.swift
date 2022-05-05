//
//  CalenderViewController.swift
//  MyDailyTransactionApp
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 27/04/22.
//

import FSCalendar
import UIKit

class CalenderViewController: UIViewController, FSCalendarDelegate {
    
    
    @IBOutlet weak var calendar: FSCalendar!
    
    private var transactions = [Transaction]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate = self

    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        
        let selectedDate = dateFormat.string(from: date)
        
        print("\(selectedDate)")
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if (transactions.isEmpty) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "add_transaction") as! AddTransactionViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let dateFormat = DateFormatter()
            dateFormat.dateStyle = .medium
            
            let dateToday = dateFormat.string(from: Date())
            
            var alreadyMade = false
            
            for transaction in transactions {
                
                let transactionDate = dateFormat.string(from: transaction.transactionDate!)
                if(dateToday == transactionDate){
                    alreadyMade = true
                    break
                }
            }
            
            if(alreadyMade==true) {
                let alertControl = UIAlertController(title: "Action Canceled", message: "A transaction is already made for today", preferredStyle: .alert)
                alertControl.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {_ in
                    alertControl.dismiss(animated: true, completion: nil)
                }))
                self.present(alertControl, animated: true)
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "add_transaction") as! AddTransactionViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
