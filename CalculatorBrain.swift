//
//  CalculatorBrain.swift
//  Calculator193P
//
//  Created by Janek Szynal on 04.04.2015.
//  Copyright (c) 2015 PJM. All rights reserved.
//

import Foundation


class CalculatorBrain: CustomStringConvertible
{
    private enum Op : CustomStringConvertible {
        case Operand(Double)
        case ConstantOperation(String, Double)
        case VariableOperation(String) //verify if the distinction between the two is necessary
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)

        
        var description : String {
            get {
                switch self {
                case .Operand(let number):
                    return "\(number)"
                case .ConstantOperation(let symbol, _):
                    return symbol
                case .VariableOperation(let symbol):
                    return symbol
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    var description: String {
        get {
            //start with the full stack and save it
            //evaluate in a loop
            //each complete expression should be followed by a comma
            var stackToDescribe = opStack
            var descriptionHistory = [String]()
            
            while stackToDescribe.count > 0 {
                let (operationDescription, remainingOpStack) = describe(stackToDescribe)
                if let desc = operationDescription {
                    descriptionHistory.append(desc)
                } else {
                    descriptionHistory.append("Err!")
                }
                stackToDescribe = remainingOpStack
            }
            
            return descriptionHistory.reverse().joinWithSeparator(", ")
        }
    }
    
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    private var variableValues = [String:Double]()
    
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
    
    var program: AnyObject {
        get {
            return opStack.map {$0.description}
        }
        set {
            if let opSymbols = newValue as? [String] {
                var newSymbols = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newSymbols.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newSymbols.append(Op.Operand(operand))
                    }
                }
                opStack = newSymbols
            }
        }
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double?{ //for variables
        opStack.append(Op.VariableOperation(symbol))
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
    
    private func describe(ops: [Op]) -> (description: String?, remainingOps: [Op]) {
        if !ops.isEmpty {
            //the argument ops is immutable (pass-by-value, implicit let); so we need to get a new var to operate on
            var remainingOps = ops
            //take an op from the top of the stack
            let op = remainingOps.removeLast()
            //see what it is:
            switch op {
                
            case .Operand(let operand): //if it's an operand, return it as string
                return ("\(operand)", remainingOps)
            case .ConstantOperation(let symbol, _): //similarly in a case of a constant
                return (symbol, remainingOps)
            case .VariableOperation(let symbol): //if it's a var, return the symbol
                return (symbol, remainingOps)
            case .UnaryOperation(let symbol, _): // if it's a unary operation - use one next operand and return them together, e.g cos(10)
                let nextOperand = describe(remainingOps)
                let operand = nextOperand.description ?? "?" //if an operand is misssing, replace with ?
                let desc = "\(symbol)(\(operand))"

                return (desc, nextOperand.remainingOps)
            case .BinaryOperation(let symbol, _): // if it's a binary operation - we need two operands. we use infix, e.g. 5 + 3
                let operand1Evaluation = describe(remainingOps)
                //TODO: refactor below to be clearer and more concise, use ?? syntax and factor out common parts
                if let operand1 = operand1Evaluation.description {
                    let operand2Evaluation = describe(operand1Evaluation.remainingOps)
                    if let operand2 = operand2Evaluation.description {
                        return (operand2+symbol+operand1, operand2Evaluation.remainingOps)
                    } else {
                        return ("?"+symbol+operand1, operand2Evaluation.remainingOps)
                    }
                } else {
                    return ("?"+symbol+"?", operand1Evaluation.remainingOps)
                }
            }
            
        }
        
        //if something went wrong along the way, the result should be nil and the remaining ops should be the ops we started with
        return (nil, ops)
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
            case .VariableOperation(let variable): //if it's a var, return it's value if you have it, return nil if you don't
                return (variableValues[variable], remainingOps)
            case .UnaryOperation(_, let operation): // if it's a unary operation - we need one operand
                let nextOperandEvaluation = evaluate(remainingOps)
                if let operand = nextOperandEvaluation.result {
                    return (operation(operand), nextOperandEvaluation.remainingOps)
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
        print("\(opStack) = \(result) with eval remainder \(remainder) left over. Full stack \(opStack)")
        print("Desc: \(description)")
        
        return result
    }

    
}