//
//  AddTransactionViewController.swift
//  MyDailyTransactionApp
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 27/04/22.
//

import UIKit

class AddTransactionViewController: UIViewController {

    
    @IBOutlet weak var transactionNameTextField: UITextField!
    @IBOutlet weak var transactionDateTextField: UITextField!
    @IBOutlet weak var transactionDescriptionTextView: UITextView!
    @IBOutlet weak var validateTransactionName: UILabel!
    @IBOutlet weak var validateTransactionDate: UILabel!
    
    @IBOutlet weak var addTransactionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resetForm()
        setUpElements()
    }

    func setUpElements() {
        
        CustomElements.styleTextField(transactionNameTextField)
        CustomElements.styleTextView(transactionDescriptionTextView)
        CustomElements.styleFilledButtonAdd(addTransactionButton)
    }
    
    func resetForm() {
        addTransactionButton.isEnabled = false
        
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
            addTransactionButton.isEnabled = true
        }
        else
        {
            addTransactionButton.isEnabled = false
        }
    }
    @IBAction func AddTransactionTapped(_ sender: Any) {
        let alertControl = UIAlertController(title: "Add Transaction", message: "Are you sure want to add this transaction", preferredStyle: .alert)
        alertControl.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
            alertControl.dismiss(animated: true, completion: nil)
        }))
        alertControl.addAction(UIAlertAction(title: "yes", style: .destructive, handler: { [self]_ in
            
            if transactionDescriptionTextView.text.isEmpty
            {
                transactionDescriptionTextView.text = ""
            }
            
        }))
    }
}
