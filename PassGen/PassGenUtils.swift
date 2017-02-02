//
//  PassGenUtils.swift
//  PassGen
//
//  Created by Stephen Cartwright on 1/31/17.
//  Copyright © 2017 Ōmagatoki. All rights reserved.
//

import Foundation
import os.log

extension Character {
	func unicodeScalarCodePoint() -> Int {
		
		let charString = String(self);
		let scalars = charString.unicodeScalars;
		
		
		return Int(scalars[scalars.startIndex].value)
	}
}

class PassGenUtils {

	
	private var lowerCount: Int = 0, upperCount: Int = 0, digitCount: Int = 0, specialCount: Int = 0;
	
	private var progress: Int = 0;
	
	private var needLower: Int = 0, needUpper: Int = 0, needDigit: Int = 0, needSpecial: Int = 0;
	
	private var passLen: Int = 0, totalLen: Int = 0, lenNeeded: Int = 0;
	
	private var tempPass: [Character], password: [Character];
	
	init?(args: [Int]) {
		os_log("PGU init called.", log: OSLog.default, type: .debug);
		
		
		guard args.count == 5 else {
			fatalError("Error: PGU args.count expected 5, got \(args.count)");
		}
		
		var tot: Int = 0;
		for index in 0 ..< args.count-1 {
			tot += args[index];
		}
		
		print("[init] totalLen \(tot), low \(args[0]), up \(args[1]), dig \(args[2]), spec \(args[3])");

		
		guard args[4] >= tot else {
			fatalError("Error: PGU args != length, got \(args[4]) and total \(tot) ");
		}
		
		self.needLower = args[0];
		self.needUpper = args[1];
		self.needDigit = args[2];
		self.needSpecial = args[3];
		
		self.passLen = args[4];
		self.totalLen = tot;
		
		self.lenNeeded = self.passLen - self.totalLen;
		
		print("passLen \(self.passLen), lenNeeded \(self.lenNeeded)");
		
		self.tempPass = [Character]();
		self.password = [Character]();
		

		
		if self.lenNeeded > 0 {
			self.fixInputCount();
		}
		

		
		if self.lenNeeded != 0 {
			fatalError("Fix the input");
		}
		
		for _ in 0 ..< self.passLen {
			tempPass.append(" ");
		}
		
		
		print("lenNeeded \(self.lenNeeded)");
		print("[init] totalLen \(self.passLen), needlow \(self.needLower), needup \(self.needUpper), needdig \(self.needDigit), needspec \(self.needSpecial)");

		
	}
	
	func setPass() -> Void {
		
		for index in 0..<self.tempPass.count {
			self.password.append(tempPass[index]);
		}
		
	}
	
	func getFinalPassword() -> String {
		return String(self.password);
	}
	
	func mainLoop() -> Void {
		os_log("mainLoop running...", log: OSLog.default, type: .debug);
		repeat {
			
			genPass();
			self.totalLen = self.needLower + self.needUpper + self.needDigit + self.needSpecial;
			os_log("mainLoop sleeping...", log: OSLog.default, type: .debug);
			print("Progress: \(self.progress)");

			// sleep(3);
			
			
		} while(self.progress < 100);
		
		self.setPass();
		//return self.getFinalPassword();
	}
	
	
	func fixInputCount() -> Void {
		var n: Int = self.lenNeeded;
		var rand: Int = -99, randChar: Int = -99;
		
		repeat {
			randChar = self.gen(min: 1, max: 4);
			rand = self.gen(min: 1, max: n);
			
			switch randChar {
				case 1:
					self.needLower += rand;
					break
				case 2:
					self.needUpper += rand;
					break
				case 3:
					self.needDigit += rand;
					break
				case 4:
					self.needSpecial += rand;
					break
				default:
					break;
					
					
			}
			
			n -= rand;
			
		} while(n > 0)
		
		self.lenNeeded = n
		
		self.totalLen = self.needLower + self.needUpper + self.needDigit + self.needSpecial;
		print("totalLen fix'd \(self.totalLen)");
		print("[fix'd] totalLen \(self.totalLen), needlow \(self.needLower), needup \(self.needUpper), needdig \(self.needDigit), needspec \(self.needSpecial)");

		
	}
	
	func getProgress() -> Int {
		
		let i = self.getLowerCount() + self.getUpperCount() + self.getDigitCount() + self.getSpecialCount();
		let tot = Int(100 * (Float(i) / Float(self.passLen)));
		self.progress = tot;
		
		print("progress \(tot), passLen \(self.passLen), lowcount \(self.lowerCount), upcount \(self.upperCount), digcount \(self.digitCount), speccount \(self.specialCount)");

		
		return tot;
	}
	
	func genPass() -> Bool {
		var done: Bool = false;
		var c: Character = Character(UnicodeScalar(300)!);

		
		switch self.gen(min: 1, max: 4) {
		case 1:
			if self.needSpecial > 0 {
				
				switch self.gen(min: 1, max: 4)  {
				case 1:
					c = self.genSpecial(spec: self.gen(min: 33, max: 47))
					self.tempPass[self.getNextEmpty()] = c;
					
					break;
				case 2:
					c = self.genSpecial(spec: self.gen(min: 58, max: 64))
					self.tempPass[self.getNextEmpty()] = c;
					
					break;
				case 3:
					c = self.genSpecial(spec: self.gen(min: 91, max: 96))
					self.tempPass[self.getNextEmpty()] = c;
					
					break;
					
				case 4:
					c = self.genSpecial(spec: self.gen(min: 123, max: 126))
					self.tempPass[self.getNextEmpty()] = c;
					
					break;
				default:
					break;
				}
				
				self.decSpecialNCount();
			}

			break;
		case 2:
			if self.needDigit > 0 {
				c = self.genDigit(dig: self.gen(min: 48, max: 57))
				self.tempPass[self.getNextEmpty()] = c;
				self.decDigitNCount()
			}
			break;
		case 3:
			if self.needUpper > 0 {
				c = self.genUpper(up: self.gen(min: 65, max: 90))
				self.tempPass[self.getNextEmpty()] = c;
				self.decUpperNCount()
			}
			break;
		case 4:
			if self.needLower > 0 {
				c = self.genLower(low: self.gen(min: 97, max: 122))
				self.tempPass[self.getNextEmpty()] = c;
				self.decLowerNCount()
			}
			break;
		default:
			break;
		}
		
		self.getProgress();
		
		if self.needLower == 0 &&  self.needUpper == 0 && self.needDigit == 0 && self.needSpecial == 0 {
			done = true;
		}
		
		
		return done;
	}
	
	func gen(min: Int, max: Int) -> Int {
		var done: Bool = false;
		var r: UInt32 = 300;
		var ri: Int = -99;
		
		repeat {
			r = arc4random_uniform(UInt32(max)) + UInt32(min);
			ri = Int(r);
			
			if ri >= min && ri <= max {
				done = true;
			}
		} while (!done);
		
		
		return ri;
	}
	
	func getNextEmpty() -> Int {
		
		var done: Bool = false;
		
		let count: Int = 10 * self.passLen;
		var i: Int = 0;
		var got: Int = -99;
		
		
		repeat {
			
			let generated = self.gen(min: 0, max: self.passLen - 1);
			let pos = self.tempPass[generated];
			
			//let ascii = pos.unicodeScalarCodePoint();
			
			if pos == " " {
				got = generated;
				done = true;
			}
			if i >= count {
				got = 0;
				done = true;
			}
			
			i += 1;
			
		} while (!done);
		
		
		return got;
	}
	
	
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
		
		if dig >= 48 && dig <= 57 {
			c = Character(UnicodeScalar(dig)!);
		}
		
		self.incDigitCount();
		return c;	}
	
	func genSpecial(spec: Int) -> Character {
		var c: Character = "x";
		
		if (spec >= 33 && spec <= 47) || (spec >= 58 && spec <= 64) || (spec >= 91 && spec <= 96) || (spec >= 123 && spec <= 127) {
			
			c = Character(UnicodeScalar(spec)!);
		}
		
		self.incSpecialCount();
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
	
	func decLowerNCount() -> Void {
		self.needLower -= 1;
	}
	
	func decUpperNCount() -> Void {
		self.needUpper -= 1;
	}
	
	func decDigitNCount() -> Void {
		self.needDigit -= 1;
	}
	
	func decSpecialNCount() -> Void {
		self.needSpecial -= 1;
	}
	
	
}
