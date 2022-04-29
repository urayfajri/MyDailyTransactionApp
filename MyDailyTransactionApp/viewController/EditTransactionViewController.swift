//
//  EditTransactionViewController.swift
//  MyDailyTransactionApp
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 28/04/22.
//

import UIKit

class EditTransactionViewController: UIViewController {

    @IBOutlet weak var transactionNameTextField: UITextField!
    @IBOutlet weak var transactionDateTextField: UITextField!
    @IBOutlet weak var transactionDescriptionTextView: UITextView!
    
    @IBOutlet weak var validateTransactionName: UILabel!
    @IBOutlet weak var validateTransactionDate: UILabel!
    
    @IBOutlet weak var editTransactionButton: UIButton!
    
    var transaction: Transaction?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEditedTransaction()
        updateForm()
        setUpElements()

    }
    
    func setUpElements() {
        
        CustomElements.styleTextField(transactionNameTextField)
        CustomElements.styleTextView(transactionDescriptionTextView)
        CustomElements.styleFilledButtonEdit(editTransactionButton)
    }
    
    func updateForm() {
        if let transactionName = transactionNameTextField.text
        {
            if let errorMessage = invalidTransactionName(transactionName)
            {
                validateTransactionName.text = errorMessage
                validateTransactionName.isHidden = false
            } else
            {
                validateTransactionName.isHidden = true
            }
        }
        checkValidForm()

    }

    @IBAction func transactionNameChanged(_ sender: Any) {
        if let transactionName = transactionNameTextField.text
        {
            if let errorMessage = invalidTransactionName(transactionName)
            {
                validateTransactionName.text = errorMessage
                validateTransactionName.isHidden = false
            } else
            {
                validateTransactionName.isHidden = true
            }
        }
        checkValidForm()
    }
    
    func invalidTransactionName(_ value: String) -> String? {
        
        if value.isEmpty
        {
            return "Transaction Name is Required"
        }
        return nil
    }
    
    func checkValidForm() {
        if(validateTransactionName.isHidden &&  validateTransactionDate.isHidden)
        {
            editTransactionButton.isEnabled = true
        }
        else
        {
            editTransactionButton.isEnabled = false
        }
    }
    
    @IBAction func editTransactionTapped(_ sender: Any) {
        
        let alertControl = UIAlertController(title: "Edit Transaction", message: "Are you sure want to edit this transaction", preferredStyle: .alert)
        alertControl.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
            alertControl.dismiss(animated: true, completion: nil)
        }))
        alertControl.addAction(UIAlertAction(title: "yes", style: .destructive, handler: { [self]_ in
            
            if transactionDescriptionTextView.text.isEmpty
            {
                transactionDescriptionTextView.text = ""
            }
            
            updateTransaction(item: transaction!)
        }))
        
        self.present(alertControl, animated: true)
    }
    
    func updateTransaction(item: Transaction) {
        item.transactionName = transactionNameTextField.text
        item.transactionDescription = transactionDescriptionTextView.text
        
        do{
            
            try context.save()
            
            self.navigationController?.popViewController(animated: true)
        }
        catch
        {
            
        }
    }
    
    func fetchEditedTransaction()
    {
        transactionNameTextField.text = transaction?.transactionName
        transactionDescriptionTextView.text = transaction?.transactionDescription

        // fetch transaction date
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        transactionDateTextField.text = dateFormat.string(from: (transaction?.transactionDate)!)
        transactionDateTextField.isEnabled = false
        validateTransactionDate.isHidden = true

    }
    
}
