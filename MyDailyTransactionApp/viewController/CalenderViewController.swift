//
//  CalenderViewController.swift
//  MyDailyTransactionApp
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 27/04/22.
//

import FSCalendar
import UIKit
import CoreData

class CalenderViewController: UIViewController, FSCalendarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var transactionCollectionView: UICollectionView!
    @IBOutlet weak var emptyTransactionLabel: UILabel!
    
    private var transactions = [Transaction]()
    private var transactionCalendars = [Transaction]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllTransactions()
        
        calendar.delegate = self
        
        transactionCollectionView.delegate = self
        transactionCollectionView.dataSource = self
        
        let transactionLayout = UICollectionViewFlowLayout()
        transactionLayout.scrollDirection = .vertical
        transactionLayout.minimumLineSpacing = 10
        transactionLayout.minimumInteritemSpacing = 10
        transactionCollectionView.setCollectionViewLayout(transactionLayout, animated: true)

    }
    
    func getAllTransactions(){
        // fetch the data from core data in the table view
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        do
        {
            transactions = try context.fetch(fetchRequest)
                    
            if(transactions.isEmpty)
            {
//                hintLabel.isHidden = true
//                emptyList.isHidden = false
//                emptyList.text = "You haven’t create any transaction\nStart create one now!"
//                emptyList.textColor = .gray
//                emptyList.textAlignment = .center
//                emptyList.frame = CGRect(x: 0, y: view.frame.size.height / 2, width: view.frame.size.width, height: 100)
//                view.addSubview(emptyList)
            }
        }
        catch
        {
            //error
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        
        let selectedDate = dateFormat.string(from: date)
        
        print("\(selectedDate)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width - lay.minimumInteritemSpacing
        return CGSize(width: widthPerItem, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "transaction_calendar_cell", for: indexPath) as! TransactionCalendarCell
        let transaction = transactions[indexPath.row]
        
        cell.backgroundColor = .systemGray6
        cell.layer.cornerRadius = 15
        
        cell.transactionCalendarName.text = transaction.transactionName
        cell.transactionCalendarBudget.text = transaction.transactionDescription
        cell.transactionCalendarDate.text = transaction.transactionStatus
        
        return cell
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
