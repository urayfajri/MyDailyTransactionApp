//
//  DetailIncomeViewController.swift
//  MyDailyTransactionApp
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 28/04/22.
//

import UIKit

class DetailIncomeViewController: UIViewController {

    @IBOutlet weak var incomeNameLabel: UILabel!
    @IBOutlet weak var incomeAmountLabel: UILabel!
    @IBOutlet weak var incomeSourceLabel: UILabel!
    @IBOutlet weak var incomeDescriptionTextView: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var income: Income?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initIncome()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initIncome()
    }
    
    func initIncome() {
        incomeNameLabel.text = income?.incomeName
        
        let incomeAmountTxt = income?.incomeAmount ?? 0.0
        incomeAmountLabel.text = "Rp. \(incomeAmountTxt)"
        incomeSourceLabel.text = income?.incomeSource
        incomeDescriptionTextView.text = income?.incomeDescription
        incomeDescriptionTextView.isEditable = false
        

    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "edit_income") as! EditIncomeViewController
        vc.income = income
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func trashButtonTapped(_ sender: Any) {
        let alertControl = UIAlertController(title: "Delete", message: "Are you sure want to delete this Income?", preferredStyle: .alert)
        alertControl.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
            alertControl.dismiss(animated: true, completion: nil)
        }))
        alertControl.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self]_ in
            self.deleteItem(item: income!)
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alertControl, animated: true)
    }
    
    
    func deleteItem(item: Income)
    {
        context.delete(item)
        
        do
        {
            try context.save()
        }
        catch
        {

        }
    }
}
