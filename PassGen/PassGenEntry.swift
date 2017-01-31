//
//  PassGenEntry.swift
//  PassGen
//
//  Created by Stephen Cartwright on 1/31/17.
//  Copyright © 2017 Ōmagatoki. All rights reserved.
//

import Foundation
import os.log

class PassGenEntry: NSObject, NSCoding {
	
	var name: String = "", password: String = "", accessed: String = "";

	
	//MARK: Types
	
	
	struct PropertyKey {
		static let entryName: String = "name";
		static let password: String = "password";
		static let accessed: String = "accessed";
	}
	
	//MARK: NSCoding
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(name, forKey: PropertyKey.entryName);
		aCoder.encode(password, forKey: PropertyKey.password);
		aCoder.encode(accessed, forKey: PropertyKey.accessed);
		


	}
	
	init?(name: String, password: String, accessed: String) {
		self.name = name;
		self.password = password;
		self.accessed = accessed;
	}
	
	required convenience init?(coder aDecorder: NSCoder) {
		guard let name = aDecorder.decodeObject(forKey: PropertyKey.entryName) as? String else {
			os_log("Unable to decode name for PassGen Object.", log: OSLog.default, type: .debug);
			return nil;
	
		}
		
		let password = aDecorder.decodeObject(forKey: PropertyKey.password) as! String;
		let accessed = aDecorder.decodeObject(forKey: PropertyKey.accessed) as! String;
		
		self.init(name: name, password: password, accessed: accessed);
	}
	
	
	//MARK: Archiving Paths
	
	static let DocumentDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
	
	static let ArchiveURL = DocumentDir.appendingPathComponent("entries");
	
	
	//MARK: Functions
	
	
	
	func getName() -> String {
		return self.name;
	}
	
	func getPass() -> String {
		return self.password;
	}
	
	func getAccessed() -> String {
		return self.accessed;
	}

	
}






























