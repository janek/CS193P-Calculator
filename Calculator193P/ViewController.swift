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
            if newValue != nil {
                display.text! = "\(newValue!)"
                userIsInTheMiddleOfTypingANumber = false
            }
        }
        
    }
    
    //
    var displayResult : (Double?, String?) {
        get {
            return (displayValue, nil)
        }
        set {
            //set DisplayValue or set the text directly
            print("1 is\(newValue.0) 2 is \(newValue.1)")
            if let error = newValue.1 {
                displayValue = nil
                display.text = error
            } else {
                displayValue = newValue.0
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
        
        //if there is a recognizable value on the display
        if let val = displayValue {
            if brain.pushOperand(val) != nil {
                displayResult = brain.evaluateAndReportErrors()
//                displayValue = result
            } else {
                displayValue = nil
                
            }
        }
    }
    
    @IBAction func saveVariable(sender: UIButton) {
        brain.variableValues["ℳ"] = displayValue
        userIsInTheMiddleOfTypingANumber = false
//        displayValue = brain.evaluate()
        displayResult = brain.evaluateAndReportErrors()
    }
    
    @IBAction func pushVariable(sender: UIButton) {
        //if user was typing a number, he isn't now - because he pressed an operation button
        if (userIsInTheMiddleOfTypingANumber) {
            enter()
        }
        brain.pushOperand("ℳ")
        displayResult = brain.evaluateAndReportErrors()
    }
    
    @IBAction func operate(sender: UIButton) {
        
        //if user was typing a number, he isn't now - because he pressed an operation button
        if (userIsInTheMiddleOfTypingANumber) {
            enter()
        }
        
        if let operation = sender.currentTitle {
//            if brain.performOperation(operation) != nil {
////                displayValue = result
//                displayResult = brain.evaluateAndReportErrors()
//            } else {
//                displayValue = nil
//            }
            brain.performOperation(operation)
            displayResult = brain.evaluateAndReportErrors()
        }
        
        history.text! = brain.description + "="
    }
    
    
    @IBAction func clearAll() {
        history.text = " "
        display.text = "0"
        brain.clearOpStack()
        brain.variableValues.removeAll()
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func undo() {
        if userIsInTheMiddleOfTypingANumber {
            //work as "backspace"
            if display.text!.characters.count > 1 {
                display.text! = String(display.text!.characters.dropLast(1))
            } else {
                display.text! = "0"
                userIsInTheMiddleOfTypingANumber = false
            }
        } else {
            //the user is not in the middle of typing
            //either he just opened the app or he just performed an operation
            //undo the last operation that was done in calculatorBrain
            brain.undoOp()
            
            displayValue = brain.evaluate()
            displayResult = brain.evaluateAndReportErrors()
            
            history.text! = brain.description + "="
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

