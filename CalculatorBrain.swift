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
    enum Op {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case ConstantOperation(String, Double)
    }
    
    
    
    var opStack = [Op]()
    
    
    //    var knownOps = Dictionary<String, Op>()
    var knownOps = [String:Op]()
    
    init() {
        knownOps["×"] = Op.BinaryOperation("×") { $0 * $1 }
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["−"] = Op.BinaryOperation("−") { $0 + $1 }
        knownOps["+"] = Op.BinaryOperation("+") { $1 - $0 }
        knownOps["√"] = Op.UnaryOperation("√") { sqrt($0) }
        knownOps["sin"] = Op.UnaryOperation("sin") { sin($0) }
        knownOps["cos"] = Op.UnaryOperation("cos") { cos($0) }
        knownOps["+/−"] = Op.UnaryOperation("+/−") { -$0 }
        knownOps["+/−"] = Op.UnaryOperation("+/−") { -$0 }
    }
    
    
    func pushOperand(operand: Double) {
        opStack.append(Op.Operand(operand))
    }
    
    func performOperation(symbol: String) {
        
    }
    
    
}