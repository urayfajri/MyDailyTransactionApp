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
    
    @IBOutlet weak var emptyTransactionTitleLabel: UILabel!
    @IBOutlet weak var emptyTransactionLabel: UILabel!
    private var transactions = [Transaction]()
    private var transactionCalendars = [Transaction]()
    private var selectedDate = Date()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllTransactions()
        
        //get transaction for today
        getTransactionByCalendar(selectedDate: selectedDate)
        
        calendar.delegate = self
        
        transactionCollectionView.delegate = self
        transactionCollectionView.dataSource = self
        
        let transactionLayout = UICollectionViewFlowLayout()
        transactionLayout.scrollDirection = .vertical
        transactionLayout.minimumLineSpacing = 10
        transactionLayout.minimumInteritemSpacing = 10
        transactionCollectionView.setCollectionViewLayout(transactionLayout, animated: true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllTransactions()
        
        transactionCalendars.removeAll()
        getTransactionByCalendar(selectedDate: selectedDate)
    }
    
    func getAllTransactions(){
        // fetch the data from core data in the table view
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        do
        {
            transactions = try context.fetch(fetchRequest)
                
        }
        catch
        {
            //error
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        transactionCalendars.removeAll()
        
        selectedDate = date
        getTransactionByCalendar(selectedDate: date)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width - lay.minimumInteritemSpacing
        return CGSize(width: widthPerItem, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transactionCalendars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "transaction_calendar_cell", for: indexPath) as! TransactionCalendarCell
        let transaction = transactionCalendars[indexPath.row]
        
        cell.backgroundColor = .systemGray6
        cell.layer.cornerRadius = 15
        
        cell.transactionCalendarName.text = transaction.transactionName
        
        let transactionBudgetNumberFormat = CustomElements.formatNumber(transaction.transactionBudget)
        cell.transactionCalendarBudget.text = "Rp. \(transactionBudgetNumberFormat)"
        
        if(transaction.transactionStatus == "Good") {
            cell.transactionCalendarBudget.textColor = .systemGreen
        } else {
            cell.transactionCalendarBudget.textColor = .systemRed
        }
        
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        
        cell.transactionCalendarDate.text = dateFormat.string(from: transaction.transactionDate!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let transaction = transactionCalendars[indexPath.row]
        let sheet = UIAlertController(title: "Action for Transaction", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "See Detail", style: .default, handler: {_ in

            let vc = self.storyboard?.instantiateViewController(withIdentifier: "transaction_detail") as! DetailTransactionViewController
            vc.transaction = transaction
            self.navigationController?.pushViewController(vc, animated: true)
            
        }))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: {_ in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "edit_transaction") as! EditTransactionViewController
            vc.transaction = transaction
            self.navigationController?.pushViewController(vc, animated: true)
            
        }))
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {[weak self]_ in
             self?.deleteTransaction(transaction: transaction)
        }))
        
        present(sheet, animated: true)
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
    
    func getTransactionByCalendar(selectedDate: Date) {
        if(transactions.isEmpty) {
            emptyTransactionTitleLabel.isHidden = false
            emptyTransactionLabel.isHidden = false
            transactionCollectionView.isHidden = true
        } else {
            let dateFormat = DateFormatter()
            dateFormat.dateStyle = .medium
            
            let dateCalendar = dateFormat.string(from: selectedDate)
            
            let todayDate = dateFormat.string(from: Date())
            
            for transaction in transactions {
                
                let transactionDate = dateFormat.string(from: transaction.transactionDate!)
                if(dateCalendar == transactionDate){
                    transactionCalendars.append(transaction)
                    break
                }
            }
            
            if(!transactionCalendars.isEmpty) {
                emptyTransactionTitleLabel.isHidden = true
                emptyTransactionLabel.isHidden = true
                transactionCollectionView.isHidden = false
            } else {
                emptyTransactionTitleLabel.isHidden = false
                emptyTransactionLabel.isHidden = false
                transactionCollectionView.isHidden = true
                
                if(todayDate == dateCalendar) {
                    emptyTransactionLabel.text = "for today"
                } else {
                    emptyTransactionLabel.text = "on \(dateCalendar)"
                }
            }
            transactionCollectionView.reloadData()
        }
    }
    
    func deleteTransaction(transaction: Transaction)
    {
        context.delete(transaction)
        
        do
        {
            try context.save()
            getAllTransactions()
            
            transactionCalendars.removeAll()
            getTransactionByCalendar(selectedDate: selectedDate)
        }
        catch
        {

        }
    }
}
