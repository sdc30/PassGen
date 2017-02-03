//
//  GNPViewController.swift
//  PassGen
//
//  Created by Stephen Cartwright on 2/2/17.
//  Copyright © 2017 Ōmagatoki. All rights reserved.
//

import UIKit
import os.log

class GNPViewController: UIViewController {

	var valu: [Int] = [Int]();
	var fin: String = "";
	var prog: Int = 0;
	
	
	@IBOutlet weak var lbl_Working: UILabel!
	@IBOutlet weak var aiv_Working: UIActivityIndicatorView!
	@IBOutlet weak var progVw_Working: UIProgressView!
	@IBOutlet weak var btn_Done: UIButton!

	
	private func updateDoneButton() -> Void {
		let e = fin.isEmpty;
		btn_Done.isEnabled = !e;
	}
	
	private func updateAIV() -> Void {
		let e = btn_Done.isEnabled;
		
		if e {
			aiv_Working.stopAnimating();

		} else {
			aiv_Working.startAnimating();
		}
	}
	
	private func catchProgress(notif: Notification) -> Void {
		guard let user = notif.userInfo
		, let progress = user["progress"] as? String
			else {
				print("No notificaitons");
				return
		}
		
		self.prog = Int(progress)!;
		
		progVw_Working.setProgress(Float(progress)!, animated: false);
	}
	
	private func catchPassword(notif: Notification) -> Void {
		guard let user = notif.userInfo
			, let password = user["password"] as? String
			else {
				print("No notificaitons");
				return
		}
//		print("done");
//		print("password " + password);
		
		self.fin = password;
		
		
		if !self.fin.isEmpty {
			DispatchQueue.global(qos: .background).async {
				DispatchQueue.main.async {
					self.updateDoneButton();
					self.updateAIV();
				}
			}
		}
	
	}
	
//	private func runnable(delay: Double = 0.0, background: @escaping () -> (), completion: @escaping (PassGenUtils) -> (), arg: PassGenUtils) -> Void {
	private func runnable(delay: Double = 0.0, background: @escaping () -> ()) -> Void {
		
		DispatchQueue.global(qos: .background).async {
			os_log("Background queue running.", log: OSLog.default, type: .debug)
			
				background();
				// completion(arg);
		}
		
//		let dlt = DispatchTime.now() + delay;
		
		
//		DispatchQueue.main.asyncAfter(deadline: dlt, execute: {
//			
//			os_log("Main queue running.", log: OSLog.default, type: .debug)
//			
//			
//			
//			
//		});

	

		
	}
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		os_log("GNP pressed, GNPVC loaded", log: OSLog.default, type: .debug);

		progVw_Working.setProgress(0, animated: true);
		
		updateDoneButton();
		updateAIV();
		
		
		guard !valu.isEmpty else {
			fatalError("Error valu is empty in GNPVC");
		}
		
		let pgu: PassGenUtils = PassGenUtils(args: valu)!;
		
		// self.runnable(delay: 0, background: pgu.mainLoop, completion: self.upd, arg: pgu);
		self.runnable(delay: 0.0, background: pgu.mainLoop)
		let progNotif = Notification.Name(rawValue: "progressNotification");
		let passNotif = Notification.Name(rawValue: "passwordNotification");
		
		
		let ncProg = NotificationCenter.default;
		ncProg.addObserver(forName: progNotif, object: nil, queue: nil, using: catchProgress);
		
		let ncPass = NotificationCenter.default;
		ncPass.addObserver(forName: passNotif, object: nil, queue: nil, using: catchPassword);

	

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		
		switch segue.identifier ?? "" {

		case "gnpvcDone":
			os_log("Unwinded to pgvc from gnpvc", log: OSLog.default, type: .debug);
			
			
			if let controller = segue.destination as? PassGenViewController {
				var greenlight = true;
				
				guard let xbutton = sender as? UIButton, xbutton === btn_Done else {
					os_log("Done not pressed", log: OSLog.default, type: .debug);
					greenlight = false;
					return
				}
				
				if greenlight {
					
					
					let name = controller.txtFld_Name.text ?? "";
					let password = self.fin;
					let accessed = Date().description(with: Locale.current);
					
					controller.entry = PassGenEntry(name: name, password: password, accessed: accessed)

				}
			}
			
			break;
		default:
			//os_log("Error: Unexpected entry", log: OSLog.default, type: .debug);
			fatalError("Error: Unexpected sender: (\(segue.identifier))");
			
			
		}
		
		
	}
	

	
	
	
	

}
