//
//  PassGenViewController.swift
//  PassGen
//
//  Created by Stephen Cartwright on 1/24/17.
//  Copyright © 2017 Ōmagatoki. All rights reserved.
//

import UIKit
import os.log

class PassGenViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {
	
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
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		updateSaveButtonState();
		navigationItem.title = textField.text;
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		btn_Save.isEnabled = false;
		
	}
	
	@IBOutlet var btn_GenNewPass: UIBarButtonItem!
	
	override func viewDidLoad() {

		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		txtFld_Name.delegate = self;
		
		updateSaveButtonState();

		
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
		
		guard let button = sender as? UIBarButtonItem, button === btn_Save else {
			os_log("Save button not pressed", log: OSLog.default, type: .debug);
			return
		}
		
		let name = txtFld_Name.text ?? "";
		let password = txtVw_Password.text ?? "password not created";
		let accessed = "today"
		
		entry = PassGenEntry(name: name, password: password, accessed: accessed)
		
		if segue.identifier == "optionsPopover" {
			if let controller = segue.destination as? PassGenPopoverVC {
				controller.popoverPresentationController!.delegate = self
				controller.preferredContentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
				
			}
		}
	}

	@IBAction func unwindToPassGenVC(segue: UIStoryboardSegue) {
		viewDidLoad();
	}
	


}

