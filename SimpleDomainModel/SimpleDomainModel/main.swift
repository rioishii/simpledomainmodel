//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
//  private var exchangeRate : [String: [String: Double]] = [
//        "USD": ["GBP": 0.5, "EUR": 1.5, "CAN": 1.25],
//        "GBP": ["USD": 2.0, "EUR": 3.0, "CAN": 2.5],
//        "EUR": ["USD": 0.67, "GBP": 0.33, "CAN": 0.83],
//        "CAN": ["USD": 0.8, "GBP": 0.4, "EUR": 1.2]
//  ]
    
  init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
  
  public func convert(_ to: String) -> Money {
    var newCurr : Money = Money(amount: self.amount, currency: to)
    if to == "USD" {
        switch self.currency {
        case "GBP":
            newCurr.amount = Int(Double(self.amount) * 2)
        case "EUR":
            newCurr.amount = Int(Double(self.amount) / 1.5)
        case "CAN":
            newCurr.amount = Int(Double(self.amount) / 1.25)
        default:
            newCurr.amount = self.amount
        }
    } else if to == "GBP" {
        switch self.currency {
        case "USD":
            newCurr.amount = Int(Double(self.amount) / 2)
        case "EUR":
            newCurr.amount = Int(Double(self.amount) / 3)
        case "CAN":
            newCurr.amount = Int(Double(self.amount) / 2.5)
        default:
            newCurr.amount = self.amount
        }
    } else if to == "EUR" {
        switch self.currency {
        case "USD":
            newCurr.amount = Int(Double(self.amount) * 1.5)
        case "GBP":
            newCurr.amount = Int(Double(self.amount) / 3)
        case "CAN":
            newCurr.amount = Int(Double(self.amount) * 1.2)
        default:
            newCurr.amount = self.amount
        }
    } else {
        switch self.currency {
        case "USD":
            newCurr.amount = Int(Double(self.amount) * 1.25)
        case "GBP":
            newCurr.amount = Int(Double(self.amount) * 2.5)
        case "EUR":
            newCurr.amount = Int(Double(self.amount) * 0.83)
        default:
            newCurr.amount = self.amount
        }
    }
    return newCurr
  }
  
  public func add(_ to: Money) -> Money {
    let converted = self.convert(to.currency)
    let newAmount = converted.amount + to.amount
    return Money(amount: newAmount, currency: to.currency)
  }
  public func subtract(_ from: Money) -> Money {
    let converted = self.convert(from.currency)
    let newAmount = from.amount - converted.amount
    return Money(amount: newAmount, currency: from.currency)
  }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
    case .Hourly(let hourly):
        return Int(hourly * Double(hours))
    case .Salary(let salary):
        return salary
    }
  }
  
  open func raise(_ amt : Double) {
    switch self.type {
    case .Hourly(let hourly):
        self.type = JobType.Hourly(hourly + amt)
    case .Salary(let salary):
        self.type = JobType.Salary(salary + Int(amt))
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return _job }
    set(value) {
        if self.age >= 18 {
            _job = value
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return _spouse }
    set(value) {
        if self.age >= 18 {
            _spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(_job?.type) spouse:\(_spouse?.firstName)]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if spouse1.spouse == nil && spouse2.spouse == nil {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        members.append(spouse1)
        members.append(spouse2)
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    if members[0].age >= 21 || members[1].age >= 21 {
        members.append(child)
        return true
    }
    return false
  }
  
  open func householdIncome() -> Int {
    var income = 0
    for person in members {
        if person.job != nil {
            income += (person.job?.calculateIncome(2000))!
        }
    }
    return income
  }
}





