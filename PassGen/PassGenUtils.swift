//
//  PassGenUtils.swift
//  PassGen
//
//  Created by Stephen Cartwright on 1/31/17.
//  Copyright © 2017 Ōmagatoki. All rights reserved.
//

import Foundation
import os.log

class PassGenUtils {

	private var lowerCount: Int = 0, upperCount: Int = 0, digitCount: Int = 0, specialCount: Int = 0;
	
	private var progress: Int = 0;
	
	private var needLower: Int = 0, needUpper: Int = 0, needDigit: Int = 0, needSpecial: Int = 0;
	
	private var passLen: Int = 0, totalLen: Int = 0, lenNeeded: Int = 0;
	
	private var tempPass: [Character], password: [Character];
	
	init?(args: [Int]) {
		os_log("PGU init called.", log: OSLog.default, type: .debug);
		
		guard args.count == 4 else {
			fatalError("Error: PGU args.count expected 4, got \(args.count)");
		}
		
		for index in 0 ..< args.count {
			self.totalLen += args[index];
		}
		
		self.lenNeeded = self.passLen - self.totalLen;
		
		self.tempPass = [Character]();
		self.password = [Character]();
		
		if self.lenNeeded > 0{
			self.fixInputCount();
		}
		

		
		self.needLower = args[0];
		self.needUpper = args[1];
		self.needDigit = args[2];
		self.needSpecial = args[3];
		
		
		
	}
	
	func runnable(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) -> Void {
		DispatchQueue.global(qos: .background).async {
			os_log("Background queue running.", log: OSLog.default, type: .debug)
			
						if background != nil {
							background!();
			

						}
			
			
			let dlt = DispatchTime.now() + .seconds(3);
			DispatchQueue.main.asyncAfter(deadline: dlt, execute: {
				
				os_log("Main queue running.", log: OSLog.default, type: .debug)

				
								if completion != nil {
									completion!();
								}
			})
			
			
		}
	}
	
	func fixInputCount() -> Void {
		
	}
	
	func getProgress() -> Void {
		
	}
	
	func genPass() -> Void {
		
	}
	
	func gen(min: Int, max: Int) -> Int {
		let r = arc4random_uniform(UInt32(max)) + UInt32(min);
		return Int(r);
	}
	
	func getNextEmpty() -> Int {
		
		var done: Bool = false;
		
		var count: Int = 10 * self.passLen;
		var i: Int = 0;
		var got: Int = -99;
		
		
		repeat {
			
			var generated = self.gen(min: 0, max: self.passLen - 1);
			let c = self.tempPass[generated];
			//let d = Int(c);
			
			
//			if d == 0 {
//				got = generated;
//				done = true;
//			}
			if i >= count {
				got = 0;
				done = true;
			}
			
			i += 1;
			
		} while (!done);
		
		
		return got;
	}
	
	
	/*
		if let ch = first(singleChar.unicodeScalars) where char.isASCII() {
				let ascii = char.value;
		}
	*/
	
	func genLower(low: Int) -> Character {
		var c: Character = "x";
		
		if low >= 97 && low <= 122 {
			c = Character(UnicodeScalar(low)!);
		}
		
		self.incLowerCount();
		return c;
	}
	
	func genUpper(up: Int) -> Character {
		var c: Character = "x";
		
		if up >= 65 && up <= 90 {
			c = Character(UnicodeScalar(up)!);
		}
		
		self.incUpperCount();
		return c;
	}
	
	func genDigit(dig: Int) -> Character {
		var c: Character = "x";
		
		if dig >= 65 && dig <= 90 {
			c = Character(UnicodeScalar(dig)!);
		}
		
		self.incDigitCount();
		return c;	}
	
	func genSpecial(spec: Int) -> Character {
		var c: Character = "x";
		
		if (spec >= 33 && spec <= 47) || (spec >= 58 && spec <= 64) || (spec >= 91 && spec <= 96) || (spec >= 123 && spec <= 127) {
			
			c = Character(UnicodeScalar(spec)!);
		}
		
		self.incUpperCount();
		return c;
	
	}
	
	func getLowerCount() -> Int {
		return self.lowerCount;
	}
	
	func getUpperCount() -> Int {
		return self.upperCount;
	}
	
	func getDigitCount() -> Int {
		return self.digitCount;
	}
	
	func getSpecialCount() -> Int {
		return self.specialCount;
	}
	
	func incLowerCount() -> Void {
		self.lowerCount += 1;
	}
	
	func incUpperCount() -> Void {
		self.upperCount += 1;
	}
	
	func incDigitCount() -> Void {
		self.digitCount += 1;
	}
	
	func incSpecialCount() -> Void {
		self.specialCount += 1;
	}
	
	
}
