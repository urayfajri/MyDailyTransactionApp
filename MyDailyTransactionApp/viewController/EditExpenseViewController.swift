//
//  EditExpenseViewController.swift
//  MyDailyTransactionApp
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 29/04/22.
//

import UIKit

class EditExpenseViewController: UIViewController {
    
    
    @IBOutlet weak var expenseNameTextField: UITextField!
    @IBOutlet weak var expenseAmountTextField: UITextField!
    @IBOutlet weak var expenseNeedsTextField: UITextField!
    @IBOutlet weak var expenseDescriptionTextView: UITextView!
    
    @IBOutlet weak var validateExpenseName: UILabel!
    @IBOutlet weak var validateExpenseAmount: UILabel!
    @IBOutlet weak var validateExpenseNeeds: UILabel!
    
    @IBOutlet weak var editExpenseButton: UIButton!
    
    var expense: Expense?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchEditedExpense()
        updateForm()
        setUpElements()
    }
    
    func setUpElements() {
        
        CustomElements.styleTextField(expenseNameTextField)
        CustomElements.styleTextField(expenseAmountTextField)
        CustomElements.styleTextField(expenseNeedsTextField)
        CustomElements.styleTextView(expenseDescriptionTextView)
        CustomElements.styleFilledButtonEdit(editExpenseButton)
    }
    
    func updateForm() {
        if let expenseName = expenseNameTextField.text
        {
            if let errorMessage = invalidExpenseName(expenseName)
            {
                validateExpenseName.text = errorMessage
                validateExpenseName.isHidden = false
            } else
            {
                validateExpenseName.isHidden = true
            }
        }
        
        if let expenseAmount = expenseAmountTextField.text
        {
            if let errorMessage = invalidExpenseAmount(expenseAmount)
            {
                validateExpenseAmount.text = errorMessage
                validateExpenseAmount.isHidden = false
            } else
            {
                validateExpenseAmount.isHidden = true
            }
        }
        
        if let expenseNeeds = expenseNeedsTextField.text
        {
            if let errorMessage = invalidExpenseNeeds(expenseNeeds)
            {
                validateExpenseNeeds.text = errorMessage
                validateExpenseNeeds.isHidden = false
            } else
            {
                validateExpenseNeeds.isHidden = true
            }
        }
        
        checkValidForm()
    }
    

    @IBAction func expenseNameChanged(_ sender: Any) {
        if let expenseName = expenseNameTextField.text
        {
            if let errorMessage = invalidExpenseName(expenseName)
            {
                validateExpenseName.text = errorMessage
                validateExpenseName.isHidden = false
            } else
            {
                validateExpenseName.isHidden = true
            }
        }
        checkValidForm()
    }
    
    @IBAction func expenseAmountChanged(_ sender: Any) {
        if let expenseAmount = expenseAmountTextField.text
        {
            if let errorMessage = invalidExpenseAmount(expenseAmount)
            {
                validateExpenseAmount.text = errorMessage
                validateExpenseAmount.isHidden = false
            } else
            {
                validateExpenseAmount.isHidden = true
            }
        }
        checkValidForm()
    }
    
    @IBAction func expenseNeedsChanged(_ sender: Any) {
        if let expenseNeeds = expenseNeedsTextField.text
        {
            if let errorMessage = invalidExpenseNeeds(expenseNeeds)
            {
                validateExpenseNeeds.text = errorMessage
                validateExpenseNeeds.isHidden = false
            } else
            {
                validateExpenseNeeds.isHidden = true
            }
        }
        checkValidForm()
    }
    
    @IBAction func editExpenseTapped(_ sender: Any) {
        let alertControl = UIAlertController(title: "Edit Expense", message: "Are you sure want to edit this expense?", preferredStyle: .alert)
        alertControl.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
            alertControl.dismiss(animated: true, completion: nil)
        }))
        alertControl.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self]_ in
            
            if expenseDescriptionTextView.text.isEmpty
            {
                expenseDescriptionTextView.text = ""
            }
            
            updateExpense(item: expense!)
        }))
        
        self.present(alertControl, animated: true)
    }
    
    func updateExpense(item: Expense) {
        item.expenseName = expenseNameTextField.text
        item.expenseAmount = Double(expenseAmountTextField.text ?? "0") ?? 0.0
        item.expenseNeeds = expenseNeedsTextField.text
        item.expenseDescription = expenseDescriptionTextView.text
        
        do{
            
            try context.save()
            
            self.navigationController?.popViewController(animated: true)
        }
        catch
        {
            
        }
    }
    
    func invalidExpenseName(_ value: String) -> String? {
        
        if value.isEmpty
        {
            return "Expense Name is Required"
        }
        return nil
    }
    
    func invalidExpenseAmount(_ value: String) -> String? {
        
        let set = CharacterSet(charactersIn: value)
        if !CharacterSet.decimalDigits.isSuperset(of: set)
        {
            return "Expense Amount only contain numbers"
        }
        if value.isEmpty
        {
            return "Expense Amount is Required"
        }
        return nil
    }
    
    func invalidExpenseNeeds(_ value: String) -> String? {
        
        if value.isEmpty
        {
            return "Expense Needs is Required"
        }
        return nil
    }
    
    func checkValidForm() {
        if(validateExpenseName.isHidden && validateExpenseAmount.isHidden && validateExpenseNeeds.isHidden)
        {
            editExpenseButton.isEnabled = true
        }
        else
        {
            editExpenseButton.isEnabled = false
        }
    }
    
    func fetchEditedExpense()
    {
        expenseNameTextField.text = expense?.expenseName
        expenseNeedsTextField.text = expense?.expenseNeeds
        expenseDescriptionTextView.text = expense?.expenseDescription

        let amountMoneyTxt = "\(Int(expense?.expenseAmount ?? 0))"
        expenseAmountTextField.text = amountMoneyTxt

    }
}
