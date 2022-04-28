//
//  ViewController.swift
//  MyDailyTransactionApp
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 26/04/22.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
       
    @IBOutlet weak var transactionTableView: UITableView!
    var emptyList: UITextView!
    
    private var transactions = [Transaction]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        
        emptyList = UITextView()
        dummyData()
        getAllTransactions()
        
        if(transactions.isEmpty)
        {
            emptyList.text = "You haven’t create any transaction\nStart create one now!"
            emptyList.textColor = .gray
            emptyList.textAlignment = .center
            emptyList.frame = CGRect(x: 0, y: view.frame.size.height / 2, width: view.frame.size.width, height: 100)
            view.addSubview(emptyList)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: "transaction_cell", for: indexPath) as? transactionCell)!
        // get transaction from Array(transactions)
        let transaction = self.transactions[indexPath.row]
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        
        cell.transactionName.text = transaction.transactionName
        cell.transactionDate.text = dateFormat.string(from: transaction.transactionDate!)
        cell.transactionBudget.text = "Rp. \(transaction.transactionBudget)"
        cell.transactionBudget.textColor = .systemGreen
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "transaction_detail") as! transactionDetailViewController
//        vc.transaction = transactions[indexPath.row]
//
//        self.navigationController?.pushViewController(vc, animated: true)
    }

    func getAllTransactions(){
        // fetch the data from core data in the table view
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        do
        {
            transactions = try context.fetch(fetchRequest)
            
            
            DispatchQueue.main.async
            {
                self.transactionTableView.reloadData()
            }
        }
        catch
        {
            //error
        }
    }
    
    func dummyData()
    {
        let transaction1 = Transaction(context: self.context)
        transaction1.transactionName = "Transaksi baru hari ini"
        transaction1.transactionBudget = 40000
        transaction1.transactionDescription = "ini deksripsi transaksi"
        transaction1.transactionDate = Date()
        transaction1.createdAt = Date()
        
        let transaction2 = Transaction(context: self.context)
        transaction2.transactionName = "Transaksi lagi"
        transaction2.transactionBudget = 5000
        transaction2.transactionDescription = "ini deksripsi transaksi baru"

        var dateComp = DateComponents()
        dateComp.year = 2022
        dateComp.month = 4
        dateComp.day = 27
        dateComp.timeZone = TimeZone(abbreviation: "GMT")
        dateComp.hour = 12
        dateComp.minute = 34

        let userCalendar = Calendar(identifier: .gregorian)
        transaction2.transactionDate = userCalendar.date(from: dateComp)
        transaction2.createdAt = userCalendar.date(from: dateComp)

        let income1 = Income(context: context)
        income1.incomeName = "ini income"
        income1.incomeAmount = 10000
        income1.incomeSource = "dari orang tua"
        income1.incomeDescription = "ini contoh income"
        income1.createdAt = Date()

        let income2 = Income(context: context)
        income2.incomeName = "ini income 2"
        income2.incomeAmount = 10000
        income2.incomeSource = "dari orang tua"
        income2.incomeDescription = "ini contoh income"
        income2.createdAt = Date()

        let expense1 = Expense(context: context)
        expense1.expenseName = "ini expense 1"
        expense1.expenseAmount = 5000
        expense1.expenseNeeds = "makan siang"
        expense1.expenseDescription = "ini deksripsi expense"
        expense1.createdAt = Date()
        
        transaction1.addToIncomes(income1)
        transaction1.addToIncomes(income2)
        transaction1.addToExpenses(expense1)


    }

}

