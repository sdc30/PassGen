//
//  PassGenViewController.swift
//  PassGen
//
//  Created by Stephen Cartwright on 1/24/17.
//  Copyright © 2017 Ōmagatoki. All rights reserved.
//

import UIKit
import os.log

class PassGenViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UITabBarControllerDelegate {
	
	var entry: PassGenEntry?;
	var valu = [Int]();
	
	@IBOutlet weak var txtFld_Name: UITextField!
	
	@IBOutlet weak var btn_Save: UIBarButtonItem!

	@IBOutlet var txtVw_Password: UITextView!

	@IBOutlet var prgVw_Progress: UIProgressView!
	
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
	
//	func gnp(sender: Any?) {
//		guard let button = sender as? UIBarButtonItem, button === btn_GenNewPass else {
//			os_log("GNP not pressed", log: OSLog.default, type: .debug);
//			return
//		}
//		
//			let pgu = PassGenUtils(args: valu);
//			pgu?.runnable();
//		
//	}
	
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
		
		if let entry = entry {
			navigationItem.title = entry.getName();
			txtFld_Name.text = entry.getName();
			txtVw_Password.text = entry.getPass();
		}
		
		
//		if !valu.isEmpty && valu.count == 4 {
//			txtVw_Password.text = "\(valu[0]) + \(valu[1]) + \(valu[2]) + \(valu[3])"
//			
//		}
		
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

					if(greenlight) {
						os_log("GNP pressed", log: OSLog.default, type: .debug);
						let pgu = PassGenUtils(args: valu);
						pgu?.runnable();
					}
					
					controller.shouldPerformSegue(withIdentifier: segue.identifier!, sender: sender)
				}
				
			case "unwindToPassList":
				os_log("Unwinded to Pass List", log: OSLog.default, type: .debug);
				

				guard let button = sender as? UIBarButtonItem, button === btn_Save else {
					os_log("Save button not pressed", log: OSLog.default, type: .debug);
					return
				}
				
				os_log("Passed save", log: OSLog.default, type: .debug);
				
				
				let name = txtFld_Name.text ?? "";
				let password = txtVw_Password.text ?? "password not created";
				let accessed = "today"
				
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

