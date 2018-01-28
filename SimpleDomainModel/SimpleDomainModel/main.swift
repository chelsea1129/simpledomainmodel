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
  
  public func convert(_ to: String) -> Money {
    if currency == "USD" {
        switch to {
        case "GBP":
            return Money(amount: Int(Double(amount) * 0.5), currency: "GBP")
        case "EUR":
            return Money(amount: Int(Double(amount) * 1.5), currency: "EUR")
        case "CAN":
            return Money(amount: Int(Double(amount) * 1.25), currency: "CAN")
        default:
            return self
        }
    } else if currency == "GBP" {
        switch to {
        case "USD":
            return Money(amount: amount * 2, currency: "USD")
        case "EUR":
            return Money(amount: amount * 3, currency: "EUR")
        case"CAN":
            return Money(amount: Int(Double(amount) * 2.5), currency: "CAN")
        default:
            return self
        }
    } else if currency == "EUR" {
        switch to {
        case "GBP":
            return Money(amount: Int(Double(amount) * 1/3), currency: "GBP")
        case "USD":
            return Money(amount: Int(Double(amount) * 2/3), currency: "USD")
        case "CAN":
            return Money(amount: Int(Double(amount) * 5/6), currency: "CAN")
        default:
            return self
        }
    } else { // "CAN"
        switch to {
        case "USD":
            return Money(amount: Int(Double(amount) * 4/5), currency: "USD")
        case "EUR":
            return Money(amount: Int(Double(amount) * 6/5), currency: "EUR")
        case "GBP":
            return Money(amount: Int(Double(amount) * 2/5), currency: "GBP")
        default:
            return self
        }
    }
  }
  
  public func add(_ to: Money) -> Money {
    if self.currency == to.currency {
        return Money(amount: self.amount + to.amount, currency: self.currency)
    } else {
        let newMoney = self.convert(to.currency)
        return Money(amount: newMoney.amount + to.amount, currency: to.currency)
    }
  }
  public func subtract(_ from: Money) -> Money {
    if self.currency == from.currency{
        return Money(amount: from.amount - self.amount, currency: self.currency)
    } else {
        let newMoney = from.convert(self.currency)
        return Money(amount: newMoney.amount - self.amount, currency: self.currency)
    }
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
    switch self.type{
    case .Hourly(let h):
        return Int(h * Double(hours))
    case .Salary(let s):
        return s
    }
  }

  open func raise(_ amt : Double) {
    switch self.type {
    case .Hourly(let h):
        self.type = .Hourly(h + amt)
    case .Salary(let s):
        self.type = .Salary(s + Int(amt))
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
    get {
        return self._job
    }
    set(value) {
        if self.age < 16 {
            self._job = nil
        } else {
            self._job = value
        }
    }
  }

  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {
        return self._spouse
    }
    set(value) {
        if self.age < 21 {
            self._spouse = nil
        } else {
            self._spouse = value
        }
    }
  }

  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }

  open func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job as Job?) spouse:\(self.spouse as Person?)]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []

  public init(spouse1: Person, spouse2: Person) {
    self.members.append(spouse1)
    self.members.append(spouse2)
    spouse1._spouse = spouse2
    spouse2._spouse = spouse1
  }

  open func haveChild(_ child: Person) -> Bool {
    for member in self.members{
        if member.age > 21 && member._spouse != nil{
            self.members.append(child)
            return true
        }
    }
    return false
  }

  open func householdIncome() -> Int {
    var income: Int = 0
    for member in self.members{
        if member.job != nil{
            income += (member.job?.calculateIncome(2000))!
        }
    }
    return income
  }
}





