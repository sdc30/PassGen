//
//  PassGenTableViewController.swift
//  PassGen
//
//  Created by Stephen Cartwright on 1/24/17.
//  Copyright © 2017 Ōmagatoki. All rights reserved.
//

import UIKit
import os.log

class PassGenTableViewController: UITableViewController {
	
	//MARK: Constants
	let cellId: String = "pgvce";
	let segueId: String = "showEntry";
	
	//MARK: Properties
	var entries = [PassGenEntry]();
	
	
	//MARK: Private Methods
	private func loadEntries() -> [PassGenEntry]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: PassGenEntry.ArchiveURL.path) as? [PassGenEntry];
	}

	private func saveEntries() -> Void {
		
		let success = NSKeyedArchiver.archiveRootObject(entries, toFile: PassGenEntry.ArchiveURL.path);
		
		if success {
			os_log("Entries successfully saved.", log: OSLog.default, type: .debug)

		} else {
			os_log("Entires save unsuccessful.", log: OSLog.default, type: .error)

		}
	}
	
	func loadEntrySamples() -> Void {
		entries.append(PassGenEntry(name: "Facebook", password: "ABC123", accessed: "today")!);
	}
	
    override func viewDidLoad() {
		super.viewDidLoad();
		
		if let savedEntries = loadEntries() {
			entries += savedEntries;
		} else {
			loadEntrySamples()
		}
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return entries.count;
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? PassGenTableViewCell else {
			fatalError("Error: Dequeued cell is not an instance of \(cellId)");
		}
		
		let entry = entries[indexPath.row];
		
		cell.lbl_Name.text = entry.getName();
		cell.lbl_Accessed.text = entry.getAccessed();
		
        // Configure the cell...

        return cell
    }
	

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


	
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
			entries.remove(at: indexPath.row);
			saveEntries();
            tableView.deleteRows(at: [indexPath], with: .fade)
			
			
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		
		
		super.prepare(for: segue, sender: sender);
		
		
		switch segue.identifier ?? "" {
			case "addEntry":
				os_log("Adding entry", log: OSLog.default, type: .debug);
			case "editEntry":
				os_log("Editing entry", log: OSLog.default, type: .debug);
			case "showEntry":
				guard let pgvc = segue.destination as? PassGenViewController else {
					fatalError("Error: Unexpected destination (\(segue.destination))");
				}
				
				guard let selectedPassGenTableViewCell = sender as? PassGenTableViewCell else {
					fatalError("Error: Unexpected sender: (\(sender))");
				}
				
				guard let indexPath = tableView.indexPath(for: selectedPassGenTableViewCell) else {
					fatalError("Error: Selected cell is not being displayed for table");
				}
				
				let selectedEntry = entries[indexPath.row]
				pgvc.entry = selectedEntry;
				
			default:
				//os_log("Error: Unexpected entry", log: OSLog.default, type: .debug);
				fatalError("Error: Unexpected sender: (\(segue.identifier))");


		}
    }
	
	
	@IBAction func unwindToPassList(segue: UIStoryboardSegue) {
		if let sourceVC = segue.source as? PassGenViewController, let entry = sourceVC.entry {
			
			if let selectedIndexPath = tableView.indexPathForSelectedRow {
				// Update
				
				entries[selectedIndexPath.row] = entry;
				tableView.reloadRows(at: [selectedIndexPath], with: .none)
			} else {
			
				let newIndexPath = IndexPath(row: entries.count, section: 0);
				entries.append(entry);
				tableView.insertRows(at: [newIndexPath], with: .automatic)
			}
			
			saveEntries();
		}
	}
	
	

}
