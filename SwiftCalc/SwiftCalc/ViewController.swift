//
//  ViewController.swift
//  SwiftCalc
//
//  Created by Zach Zeleznick on 9/20/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

struct Stack<Element> {
    var items = [String]()
    mutating func push(_ item: String) {
        items.append(item)
    }
    mutating func pop() -> String {
        return items.removeLast()
    }
    
    var topItem: String? {
        return items.isEmpty ? nil : items[items.count-1]
    }
    
    mutating func removeAll() {
        items = [String] ()
    }
    
    mutating func all() -> String {
        let stringRepresentation = items.joined(separator: "")
        return stringRepresentation
    }
    
    var size: Int {
        return items.count
    }
}

struct Queue<Element> {
    var items = [String]()
    mutating func enqueue(_ item: String) {
        items.append(item)
    }
    mutating func dequeue() -> String {
        return items.removeFirst()
    }
    
    var frontItem: String? {
        return items.isEmpty ? "" : items[0]
    }
    
    var lastItem: String? {
        return items.isEmpty ? "" : items[items.count-1]
    }
    
    mutating func removeAll() {
        items = [String] ()
    }
    
    mutating func all() -> String {
        let stringRepresentation = items.joined(separator: "")
        return stringRepresentation
    }
    
    var size: Int {
        return items.count
    }
}

class ViewController: UIViewController {
    // MARK: Width and Height of Screen for Layout
    var w: CGFloat!
    var h: CGFloat!
    

    // IMPORTANT: Do NOT modify the name or class of resultLabel.
    //            We will be using the result label to run autograded tests.
    // MARK: The label to display our calculations
    var resultLabel = UILabel()
    
    // TODO: This looks like a good place to add some data structures.
    //       One data structure is initialized below for reference.
    var numberStack = Stack<String>()
    var operatorQueue = Queue<String>()
    var currNumber = ""
    var displayString = ""
    var everythingQueue = Queue<String>()
    var mathOperators: [String] = ["+", "-","/","*"]
    
    let numberCharacters = NSCharacterSet.decimalDigits


    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        w = view.bounds.size.width
        h = view.bounds.size.height
        navigationItem.title = "Calculator"
        // IMPORTANT: Do NOT modify the accessibilityValue of resultLabel.
        //            We will be using the result label to run autograded tests.
        resultLabel.accessibilityValue = "resultLabel"
        makeButtons()
        // Do any additional setup here.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: A method to update your data structure(s) would be nice.
    //       Modify this one or create your own.
    func updateSomeDataStructure(_ content: String) {
        print("Update me like one of those PCs")
    }
    
    // TODO: Ensure that resultLabel gets updated.
    //       Modify this one or create your own.
    func updateResultLabel(_ content: String) {
        print("Updated result label to be " + String(content))
        let numChars = content.characters.count
        if numChars <= 7 {
            resultLabel.text = content
        }
    }
    
    
    // TODO: A calculate method with no parameters, scary!
    //       Modify this one or create your own.
    func calculate() -> String {
        return "0"
    }
    
    // TODO: A simple calculate method for integers.
    //       Modify this one or create your own.
    func intCalculate(a: Int, b:Int, operation: String) -> Int {
        print("Calculation requested for \(a) \(operation) \(b)")
        var result = Int()
        if operation == "+" {
            result = a + b
        } else if operation == "-" {
            result = a - b
        } else if operation == "/" {
            result = a / b
        } else if operation == "*" {
            result = a * b
        }
        return result
    }
    
    // TODO: A general calculate method for doubles
    //       Modify this one or create your own.
    func doubleCalculate(a: Double, b:Double, operation: String) -> Double {
        print("Calculation requested for \(a) \(operation) \(b)")
        var result = Double()
        if operation == "+" {
            result = a + b
        } else if operation == "-" {
            result = a - b
        } else if operation == "/" {
            result = a / b
        } else if operation == "*" {
            result = a * b
        }
        return result
    }
    
    // REQUIRED: The responder to a number button being pressed.
    func numberPressed(_ sender: CustomButton) {
        let content = sender.content
        guard Int(content) != nil else { return }
        if displayString.characters.count < 7 {
            print (operatorQueue, displayString, currNumber, numberStack)
            if (displayString == "0" || mathOperators.contains(everythingQueue.lastItem!) || currNumber == ""){
                print("The number \(content) was pressed creating a new currNumber")
                displayString = content
                currNumber = content
            } else {
                print("The number \(content) was pressed and added to currNumber")
                displayString += content
                currNumber += content
            }
            everythingQueue.enqueue(content)
            updateResultLabel(displayString)
        }
    }
    
    func conversions(content : String) -> String {
        var result = ""
        if operatorQueue.size > 0 {
            numberStack.push(currNumber)
            if content != "=" {
                operatorQueue.enqueue(content)
            }
            
            let op2: String = numberStack.pop()
            let op1: String = numberStack.pop()
            let operation: String = operatorQueue.dequeue()
            if op2.contains(".") || op1.contains(".") {
                let operand2: Double = Double(op2)!
                let operand1: Double = Double(op1)!
                let tmp = String(doubleCalculate(a: operand1, b: operand2, operation: operation))
                result = tmp
            } else {
                let operand2: Int = Int(op2)!
                let operand1: Int = Int(op1)!
                if operand1 % operand2 != 0 {
                    let tmp = String(doubleCalculate(a: Double(operand1), b: Double(operand2), operation: operation))
                    result = tmp
                } else {
                    let tmp = String(intCalculate(a: operand1, b: operand2, operation: operation))
                    result = tmp
                }
            }
        }
        print(result, numberStack)
        return result
    }
    
    // REQUIRED: The responder to an operator button being pressed.
    func operatorPressed(_ sender: CustomButton) {
        // Fill me in!
        if sender.content == "C" {
            numberStack.removeAll()
            displayString = "0"
            currNumber = "0"
        } else if sender.content == "+/-" && currNumber.characters.count <= 7 {
            let numberStr: String = currNumber
            let numberInt: Int = Int(numberStr)! * -1
            let displayNumber:String = String(numberInt)
            currNumber = String(numberInt)
            displayString = displayNumber
        } else if sender.content == "=" {
            if operatorQueue.size > 0 {
                let result: String = conversions(content: sender.content)
                currNumber = result
                numberStack.push(currNumber)
            } else {
                numberStack.push(currNumber)
            }
            displayString = currNumber
            everythingQueue.removeAll()
        } else if mathOperators.contains(sender.content) { // +,-,/,* case
            everythingQueue.enqueue(currNumber)
            if operatorQueue.size > 0 {
                let result: String = conversions(content: sender.content)
                currNumber =  result
                numberStack.push(result)
                displayString = result
            } else {
                numberStack.push(currNumber)
                operatorQueue.enqueue(sender.content)
                currNumber = ""
                displayString = ""
            }
        }
        everythingQueue.enqueue(sender.content)
        updateResultLabel(displayString)
    }
    
    // REQUIRED: The responder to a number or operator button being pressed.
    func buttonPressed(_ sender: CustomButton) {
       // Fill me in!
        let content = sender.content
        if content == "0" {
            if (everythingQueue.lastItem!.rangeOfCharacter(from: numberCharacters) != nil) {
                currNumber += "0"
                displayString += "0"
            } else {
                currNumber = "0"
                displayString = "0"                
            }
        } else if content == "." {
            if displayString == "0" {
                currNumber = "0."
                displayString = "0."
            } else {
                currNumber += "."
                displayString = currNumber
            }
        }
        updateResultLabel(displayString)
    }
    
    // IMPORTANT: Do NOT change any of the code below.
    //            We will be using these buttons to run autograded tests.
    
    func makeButtons() {
        // MARK: Adds buttons
        let digits = (1..<10).map({
            return String($0)
        })
        let operators = ["/", "*", "-", "+", "="]
        let others = ["C", "+/-", "%"]
        let special = ["0", "."]
        
        let displayContainer = UIView()
        view.addUIElement(displayContainer, frame: CGRect(x: 0, y: 0, width: w, height: 160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }
        displayContainer.addUIElement(resultLabel, text: "0", frame: CGRect(x: 70, y: 70, width: w-70, height: 90)) {
            element in
            guard let label = element as? UILabel else { return }
            label.textColor = UIColor.white
            label.font = UIFont(name: label.font.fontName, size: 60)
            label.textAlignment = NSTextAlignment.right
        }
        
        let calcContainer = UIView()
        view.addUIElement(calcContainer, frame: CGRect(x: 0, y: 160, width: w, height: h-160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }

        let margin: CGFloat = 1.0
        let buttonWidth: CGFloat = w / 4.0
        let buttonHeight: CGFloat = 100.0
        
        // MARK: Top Row
        for (i, el) in others.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Second Row 3x3
        for (i, digit) in digits.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: digit), text: digit,
            frame: CGRect(x: x, y: y+101.0, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
            }
        }
        // MARK: Vertical Column of Operators
        for (i, el) in operators.enumerated() {
            let x = (CGFloat(3) + 1.0) * margin + (CGFloat(3) * buttonWidth)
            let y = (CGFloat(i) + 1.0) * margin + (CGFloat(i) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.backgroundColor = UIColor.orange
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Last Row for big 0 and .
        for (i, el) in special.enumerated() {
            let myWidth = buttonWidth * (CGFloat((i+1)%2) + 1.0) + margin * (CGFloat((i+1)%2))
            let x = (CGFloat(2*i) + 1.0) * margin + buttonWidth * (CGFloat(i*2))
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: 405, width: myWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            }
        }
    }

}

