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
    private enum Op : CustomStringConvertible {
        case Operand(Double)
        case ConstantOperation(String, Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)

        
        var description : String {
            get {
                switch self {
                case .Operand(let number):
                    return "\(number)"
                case  .ConstantOperation(let symbol, _):
                    return symbol
                case  .UnaryOperation(let symbol, _):
                    return symbol
                case  .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    init() {
        
        //functions can be put inside functions, it just limits the scope of from where they can be called
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("+") { $0 + $1 })
        learnOp(Op.BinaryOperation("-") { $1 - $0 })
        learnOp(Op.BinaryOperation("×") { $0 * $1 })
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        
        learnOp(Op.UnaryOperation("sin") { sin($0) })
        learnOp(Op.UnaryOperation("cos") { cos($0) })
        learnOp(Op.UnaryOperation("√")   { sqrt($0) })
        learnOp(Op.UnaryOperation("+/−") { -$0 })
        
        learnOp(Op.ConstantOperation("π", M_PI))

    }
    
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clearOpStack() {
        opStack.removeAll()
    }
    
    //recursive evaluate function
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        
        if !ops.isEmpty {
            //the argument ops is immutable (pass-by-value, implicit let); so we need to get a new var to operate on
            var remainingOps = ops
            //take an op from the top of the stack
            let op = remainingOps.removeLast()
            //see what it is:
            switch op {
                
            case .Operand(let operand): //if it's an operand - great, just return it, no recursive call
                return (operand, remainingOps)
                
            case .ConstantOperation(_, let constant): //similarly in a case of a constant
                return (constant, remainingOps)
                
            case .UnaryOperation(_, let operation): // if it's a unary operation - we need one operand
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            
            case .BinaryOperation(_, let operation): // if it's a binary operation - we need two operands
                let operand1Evaluation = evaluate(remainingOps)
                if let operand1 = operand1Evaluation.result {
                    let operand2Evaluation = evaluate(operand1Evaluation.remainingOps)
                    if let operand2 = operand2Evaluation.result {
                        return (operation(operand1,operand2), operand2Evaluation.remainingOps)
                    }
                }
                
    
            }
            
        }
        
        //if something went wrong along the way, the result should be nil and the remaining ops should be the ops we started with
        return (nil, ops)
    }
    
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    

    
    
    
}