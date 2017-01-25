//
//  PassGenPopoverVC.swift
//  PassGen
//
//  Created by Stephen Cartwright on 1/24/17.
//  Copyright © 2017 Ōmagatoki. All rights reserved.
//

import UIKit

class PassGenPopoverVC: UIViewController {
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
