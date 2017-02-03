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
		
		progVw_Working.setProgress(Float(progress)!, animated: true);
	}
	
	private func runnable(delay: Double = 0.0, background: @escaping () -> (), completion: @escaping (PassGenUtils) -> (), arg: PassGenUtils) -> Void {
		
//		DispatchQueue.global(qos: .background).async {
//			os_log("Background queue running.", log: OSLog.default, type: .debug)
//			
//			if background != nil {
//				background!;
//			}
//		}


		
		
//		let dlt = DispatchTime.now() + delay;
//		DispatchQueue.main.asyncAfter(deadline: dlt, execute: {
//			
//			os_log("Main queue running.", log: OSLog.default, type: .debug)
//			
//			if completion != nil {
//				completion!;
//			}
//
//		})
		
		
		DispatchQueue.global(qos: .background).async {
			os_log("Background queue running.", log: OSLog.default, type: .debug)
			
			
				background();
		
			let dlt = DispatchTime.now() + delay;
			
			DispatchQueue.main.asyncAfter(deadline: dlt, execute: {
				
				os_log("Main queue running.", log: OSLog.default, type: .debug)
				
				
				completion(arg);
				
			});
			
		}
	

		
	}
	
	override func viewWillAppear(_ animated: Bool) {

		let pgu: PassGenUtils = PassGenUtils(args: valu)!;
		
		self.runnable(delay: 0, background: pgu.mainLoop, completion: self.upd, arg: pgu);

		
		updateDoneButton();
		updateAIV();
		
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		progVw_Working.setProgress(0, animated: true);
		// Do any additional setup after loading the view.
		let notif = Notification.Name(rawValue: "progressNotification");
		
		
		let nc = NotificationCenter.default;
		nc.addObserver(forName: notif, object: nil, queue: nil, using: catchProgress);
		
		updateDoneButton();
		updateAIV();
		
		guard !valu.isEmpty else {
			fatalError("Error valu is empty in GNPVC");
		}
		
		os_log("GNP pressed, GNPVC loaded", log: OSLog.default, type: .debug);
	

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func upd(pgu: PassGenUtils) -> Void {
		repeat {
			
			self.fin = (pgu.getFinalPassword());
			
			print(self.fin)
			
			updateDoneButton();
			updateAIV();
			
			//sleep(1);
			
		} while (fin.isEmpty);
		
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
					controller.txtVw_Password.text = self.fin;
				}
			}
			
			break;
		default:
			//os_log("Error: Unexpected entry", log: OSLog.default, type: .debug);
			fatalError("Error: Unexpected sender: (\(segue.identifier))");
			
			
		}
		
		
	}
	

	
	
	
	

}
