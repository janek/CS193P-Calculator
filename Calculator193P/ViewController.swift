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
    
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
    
        
        //if the "digit" is in fact a separator, make sure the number doesn't already have one before appending it
        if (digit != ".") || (digit == "." && display.text!.rangeOfString(".") == nil) {
            if (userIsInTheMiddleOfTypingANumber) {
                display.text = display.text! + digit //append
            } else {
                display.text = digit //number wasnt started, start with the digit
                userIsInTheMiddleOfTypingANumber = true
            }

        }
        
    }


    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
    }
    

    var displayValue : Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set {
            display.text! = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
        
    }
    
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if (userIsInTheMiddleOfTypingANumber) {
            enter()
        }
        switch operation {
            case "×": performOperation {$0 * $1}
            case "÷": performOperation {$1 / $0}
            case "+": performOperation {$0 + $1}
            case "−": performOperation {$1 - $0}
            case "sin": performOperation {sin($0)}
            case "cos": performOperation {cos($0)}
            case "π": operandStack.append(M_PI)
            case "√": performOperation {sqrt($0)}
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
    
    func performOperation(operation: (Double, Double) ->Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    
    func performOperation(operation: (Double) ->Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    
}

