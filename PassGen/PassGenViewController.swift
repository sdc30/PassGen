//
//  PassGenViewController.swift
//  PassGen
//
//  Created by Stephen Cartwright on 1/24/17.
//  Copyright © 2017 Ōmagatoki. All rights reserved.
//

import UIKit

class PassGenViewController: UIViewController, UIPopoverPresentationControllerDelegate {
	
    @IBAction func btn_Edit(_ sender: Any) {
    }
	@IBAction func btn_Save(_ sender: Any) {
	}
	@IBOutlet var txtVw_Password: UITextView!

	@IBOutlet var prgVw_Progress: UIProgressView!
	
	@IBAction func btn_Options(_ sender: UIButton) {
		
	}
	
	@IBOutlet var btn_GenNewPass: UIBarButtonItem!
	
	override func viewDidLoad() {

		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return .none;
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "optionsPopover" {
			if let controller = segue.destination as? UIViewController {
				controller.popoverPresentationController!.delegate = self
				controller.preferredContentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
			}
		}
	}

}

