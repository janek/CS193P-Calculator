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
        if !numberHasSeparator && userIsInTheMiddleOfTypingANumber {
            let separator = sender.currentTitle!
            display.text! += separator
            numberHasSeparator = true
        }
    }
    
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
//        history.text = history.text! + display.text! + " "
        println("operandStack = \(operandStack)")
        numberHasSeparator = false
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
        
//        history.text = history.text! + operation + " "
        
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

