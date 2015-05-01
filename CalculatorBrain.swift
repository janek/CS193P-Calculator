//
//  CalculatorBrain.swift
//  Calculator193P
//
//  Created by Janek Szynal on 04.04.2015.
//  Copyright (c) 2015 PJM. All rights reserved.
//

import Foundation


class CalculatorBrain
{
    private enum Op {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case ConstantOperation(String, Double)
    }
    
    
    
    private var opStack = [Op]()
    
    
    //    var knownOps = Dictionary<String, Op>()
    private var knownOps = [String:Op]()
    
    init() {
        knownOps["×"] = Op.BinaryOperation("×") { $0 * $1 }
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["−"] = Op.BinaryOperation("−") { $0 + $1 }
        knownOps["+"] = Op.BinaryOperation("+") { $1 - $0 }
       
        knownOps["sin"] = Op.UnaryOperation("sin") { sin($0) }
        knownOps["cos"] = Op.UnaryOperation("cos") { cos($0) }
        knownOps["√"]   = Op.UnaryOperation("√")   { sqrt($0) }
        knownOps["+/−"] = Op.UnaryOperation("+/−") { -$0 }
        
        knownOps["π"] = Op.ConstantOperation("π", M_PI)
    }
    
    
    func pushOperand(operand: Double) {
        opStack.append(Op.Operand(operand))
    }
    
    func performOperation(symbol: String) {
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
    }
    
    
    //recursive evaluate function
    func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        
        if !ops.isEmpty {
            //the argument ops is immutable (pass-by-value, implicit let); so we need to get a new var to operate on
            var remainingOps = ops
            //take an op from the top of the stack
            let op = remainingOps.removeLast()
            //see what it is:
            switch op {
                
            case .Operand(let operand): //if it's an operand - just get it, no recursive call
                return (operand, remainingOps)
                
            case .UnaryOperation(_, let operation): // if it's a unary operation -
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                
            }
            
            
        }
        
        
        //if something goes wrong along the way, the result should be nil and the remaining ops should be the ops we started with
        return (nil, ops)
    }
    
    
    func evaluate() -> Double? {
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
}