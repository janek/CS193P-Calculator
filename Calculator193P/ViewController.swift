//
//  ViewController.swift
//  Calculator193P
//
//  Created by Janek Szynal on 02.04.2015.
//  Copyright (c) 2015 PJM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    //the model
    var brain = CalculatorBrain()
    
    var displayValue : Double? {
        get {
            let formatter = NSNumberFormatter()
            formatter.decimalSeparator = "."
            //this will return nil if the displayed text cannot be interpreted as a number
            return formatter.numberFromString(display.text!)?.doubleValue
        }
        
        set {
            if newValue == nil {
                display.text = " "
            } else {
                display.text! = "\(newValue!)"
                userIsInTheMiddleOfTypingANumber = false
            }
        }
        
    }
    
    
    //appends digits and/or the decimal separator
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if (digit != ".") || (digit == "." && display.text!.rangeOfString(".") == nil) {
            //if the "digit" is actually a decimal separator, ^ make sure the number doesn't already have one before appending it
            if (userIsInTheMiddleOfTypingANumber) {
                display.text = display.text! + digit
            } else {
                display.text = digit
                userIsInTheMiddleOfTypingANumber = true
            }
            
        }
        
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        
        if let val = displayValue {
            if let result = brain.pushOperand(val) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }

        
        
    }
    
    @IBAction func operate(sender: UIButton) {
        
        //if user was typing a number, he isn't now - because he pressed an operation button
        if (userIsInTheMiddleOfTypingANumber) {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
        
        
        history.text! = brain.description + "="
        
//        if !(history.text!.hasSuffix("= ")) {
//            history.text! += "= "
//        }

        
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
//        history.text! += sender.currentTitle! + " "
    }
    
    @IBAction func clearAll() {
        history.text = " "
        display.text = "0"
        brain.clearOpStack() 
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func backspace() {
        if userIsInTheMiddleOfTypingANumber {
            if display.text!.characters.count > 1 {
                display.text! = String(display.text!.characters.dropLast(1))
            } else {
                display.text! = "0"
                userIsInTheMiddleOfTypingANumber = false
            }
        }
    }
    
    @IBAction func changeSign(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            if display.text!.hasPrefix("-") {
                display.text!.removeAtIndex(display.text!.startIndex)
            } else {
                display.text! = "-"+display.text!
            }
            
        } else {
            operate(sender)
        }
        
    }
    
}

