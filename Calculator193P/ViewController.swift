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
    
    var operandStack = Array<Double>()
    
    var displayValue : Double {
        get {
            let formatter = NSNumberFormatter()
            formatter.decimalSeparator = "."
            return formatter.numberFromString(display.text!)!.doubleValue
        }
        
        set {
            display.text! = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
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
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if !(history.text!.hasSuffix("= ")) {
            history.text! += "= "
        }
        
        
        //if user was typing a number, he isn't now - because he pressed an operation button
        if (userIsInTheMiddleOfTypingANumber) {
            enter()
        }
        
        
        switch operation {
        
        //binary operations
        case "×": performOperation {$0 * $1}
        case "÷": performOperation {$1 / $0}
        case "+": performOperation {$0 + $1}
        case "−": performOperation {$1 - $0}
            
        //unary operations
        case "sin": performOperation {sin($0)}
        case "cos": performOperation {cos($0)}
        case "√": performOperation {sqrt($0)}
        case "+/−": performOperation() {-$0}
            
            
        //0-operand operations (eg. constants)
        case "π": performOperation(M_PI)
            
            
        default: break
        }
        
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        history.text! += sender.currentTitle! + " "
    }
    
    @IBAction func clearAll() {
        history.text = " "
        display.text = "0"
        operandStack.removeAll(keepCapacity: false)
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func backspace() {
        if userIsInTheMiddleOfTypingANumber {
            if countElements(display.text!) > 1 {
                display.text! = dropLast(display.text!)
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
    
    
    
    //for binary operations
    func performOperation(operation: (Double, Double) ->Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    //for unary operations
    func performOperation(operation: (Double) ->Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    //for 0-operand operations (eg. constants)
    func performOperation(constant: Double) {
        operandStack.append(M_PI)
        displayValue = M_PI
    }
    
}

