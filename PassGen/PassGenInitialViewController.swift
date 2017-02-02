//
//  PassGenInitialViewController.swift
//  PassGen
//
//  Created by Stephen Cartwright on 1/24/17.
//  Copyright © 2017 Ōmagatoki. All rights reserved.
//

import UIKit

class PassGenInitialViewController: UIViewController {
	
	@IBOutlet weak var lbl_AppUse: UILabel!
	@IBOutlet weak var txtVw_AppUse: UITextView!
	@IBOutlet weak var lbl_AppReminders: UILabel!
	@IBOutlet weak var txtVw_AppReminders: UITextView!

    override func viewDidLoad() {
		
        super.viewDidLoad()
	
		txtVw_AppUse.text = "Close this initial page to find your list. Using the add button to render a new password input form. You can either 1. input your own password or 2. Generate a new one. In 1. you may save by hitting save after entering a name for the password and the password itself. In 2. hitting the 'Options' item will bring up an input for the number of [RANDOMLY GENERATED] lower/upper/digit/special case characters, clicking 'Done' after you're finished, and then 'Generate New Password' to update your password. Finally 'Save'."
		
		
		txtVw_AppReminders.text = "First, this app is not infallible nor is human nature. Keep all information to yourself and do not leave app open under prolonged circumstances without your consent and/or in public view. Change passwords often, and keep them reasonable length in case you forget them or for the rare reason they're deleted on here."
		
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
