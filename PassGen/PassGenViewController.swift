//
//  PassGenViewController.swift
//  PassGen
//
//  Created by Stephen Cartwright on 1/24/17.
//  Copyright © 2017 Ōmagatoki. All rights reserved.
//

import UIKit
import os.log


extension UIViewController {
	
	func hideKeyboard() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PassGenViewController.dismissAll));
		
		self.view.addGestureRecognizer(tap);
	}
	
	
	@objc private func dismissAll() -> Void {
		
		let view = self.view;
		view?.endEditing(true);
		
	}
}

class PassGenViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UITabBarControllerDelegate {
	
	var entry: PassGenEntry?;
	var valu = [Int]();
	
	@IBOutlet weak var txtFld_Name: UITextField!
	
	@IBOutlet weak var btn_Save: UIBarButtonItem!

	@IBOutlet var txtVw_Password: UITextView!
	
	@IBAction func btn_Options(_ sender: UIButton) {
		
	}
	
	private func updateSaveButtonState() -> Void {
		
		let text = txtFld_Name.text ?? ""
		btn_Save.isEnabled = !text.isEmpty;
	}

	private func updateGNP() -> Void {
		
		let e = valu.isEmpty;
		btn_GenNewPass.isEnabled = !e;
	
	}
	

	
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		updateSaveButtonState();
		navigationItem.title = textField.text;
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		updateSaveButtonState();
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		btn_Save.isEnabled = false;
	}
	

	@IBOutlet weak var btn_GenNewPass: UIBarButtonItem!
		

	
	override func viewDidLoad() {

		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		txtFld_Name.delegate = self;

		updateSaveButtonState();
		updateGNP();
		self.hideKeyboard();
		
		if let entry = entry {
			navigationItem.title = entry.getName();
			txtFld_Name.text = entry.getName();
			txtVw_Password.text = entry.getPass();
		}
		
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
		
		
		
	}

	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return .none;
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		
		switch segue.identifier ?? "" {
			case "optionsPopover":
				os_log("Options Popover Entered", log: OSLog.default, type: .debug);
				
				if let controller = segue.destination as? PassGenPopoverVC {
					controller.popoverPresentationController!.delegate = self
					controller.preferredContentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
					
				}
				
			case "gnpView":
				os_log("GNP View Entered", log: OSLog.default, type: .debug);
				

				
				if let controller = segue.destination as? GNPViewController {
					var greenlight = true;

					guard let xbutton = sender as? UIBarButtonItem, xbutton === btn_GenNewPass else {
						os_log("GNP not pressed", log: OSLog.default, type: .debug);
						greenlight = false;
						return
					}

					if greenlight {
						controller.valu = self.valu;
						controller.shouldPerformSegue(withIdentifier: segue.identifier!, sender: sender)
					}
				}
				
			case "unwindToPassList":
				os_log("Unwinded to Pass List from pgvc", log: OSLog.default, type: .debug);
				

				guard let button = sender as? UIBarButtonItem, button === btn_Save else {
					os_log("Save button not pressed", log: OSLog.default, type: .debug);
					return
				}
				
				os_log("Passed save", log: OSLog.default, type: .debug);
				
				
				let name = txtFld_Name.text ?? "";
				let password = txtVw_Password.text ?? "password not created";
				let accessed = Date().description;
				
				entry = PassGenEntry(name: name, password: password, accessed: accessed)

				
			default:
				//os_log("Error: Unexpected entry", log: OSLog.default, type: .debug);
				fatalError("Error: Unexpected sender: (\(segue.identifier))");
				
				
		}
	
		
	}
	

	@IBAction func unwindToPassGenVC(segue: UIStoryboardSegue) {
		viewDidLoad();
	}
	


}

