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
   
    var userIsInTheMiddleOfTypingANumber = false
    
    var numberHasSeparator = false
    
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        println("digit = \(digit)")

        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }


    @IBAction func appendSeparator(sender: UIButton) {
        if !numberHasSeparator {
            let separator = sender.currentTitle!
            display.text! += separator
            numberHasSeparator = true
        } else {
            println("this number already has a separator")
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
            case "√": performOperation {sqrt($0)}
            default: break
        }
        
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

