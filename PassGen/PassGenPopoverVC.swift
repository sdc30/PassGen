//
//  PassGenPopoverVC.swift
//  PassGen
//
//  Created by Stephen Cartwright on 1/24/17.
//  Copyright © 2017 Ōmagatoki. All rights reserved.
//

import UIKit

class PassGenPopoverVC: UIViewController {
	var valu = [Int]();
	
	
	
	
	@IBOutlet weak var lbl_UpperCase: UILabel!
	@IBOutlet weak var lbl_LowerCase: UILabel!
	@IBOutlet weak var lbl_DigitCase: UILabel!
	@IBOutlet weak var lbl_SpecialCase: UILabel!
	@IBOutlet weak var txtFld_LC: UITextField!
	@IBOutlet weak var txtFld_UC: UITextField!
	@IBOutlet weak var txtFld_DC: UITextField!
	@IBOutlet weak var txtFld_SC: UITextField!

	@IBAction func stpr_LC(_ sender: Any) {
		txtFld_LC.text = Int((sender as! UIStepper).value).description;
	}
	@IBAction func stpr_UC(_ sender: Any) {
		txtFld_UC.text = Int((sender as! UIStepper).value).description;

	}
	@IBAction func stpr_DC(_ sender: Any) {
		txtFld_DC.text = Int((sender as! UIStepper).value).description;

	}
	@IBAction func stpr_SC(_ sender: Any) {
		txtFld_SC.text = Int((sender as! UIStepper).value).description;

	}
	
	@IBAction func btn_Done(_ sender: UIButton) {
		collectValues();

		self.performSegue(withIdentifier: "unwindToPGVC", sender: self);
		
	}
	
	func collectValues() -> Void {

		if txtFld_LC.text != "" {
			valu.append(Int(txtFld_LC.text!)!);
			//print(txtFld_LC.text!);
		} else {
			valu.append(0);
		}
		
		if txtFld_UC.text != "" {
			valu.append(Int(txtFld_UC.text!)!);
			//print(txtFld_UC.text!);
		} else {
			valu.append(0);
		}
		
		if txtFld_DC.text != "" {
			valu.append(Int(txtFld_DC.text!)!);
			//print(txtFld_DC.text!);
		} else {
			valu.append(0);
		}
		
		if txtFld_SC.text != "" {
			valu.append(Int(txtFld_SC.text!)!);
			//print(txtFld_SC.text!);
		} else {
			valu.append(0);
		}


		
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "unwindToPGVC" {
			if let controller = segue.destination as? PassGenViewController {
				controller.valu = self.valu;
			}
		}
	}
	
/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
*/
	

	


}
