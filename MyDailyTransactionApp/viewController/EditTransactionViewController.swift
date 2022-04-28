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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetForm()
        setUpElements()

    }
    
    func setUpElements() {
        
        CustomElements.styleTextField(transactionNameTextField)
        CustomElements.styleTextView(transactionDescriptionTextView)
        CustomElements.styleFilledButtonEdit(editTransactionButton)
    }
    
    func resetForm() {
        editTransactionButton.isEnabled = false
        
        validateTransactionName.isHidden = false
        validateTransactionDate.isHidden = true
            
        // empty text field
        transactionNameTextField.text = ""
        transactionDescriptionTextView.text = ""
        
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        self.transactionDateTextField.text = dateFormat.string(from: Date())
        transactionDateTextField.isEnabled = false

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
            
        }))
        
        self.present(alertControl, animated: true)
    }
    
}
