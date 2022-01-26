//
//  Validation.swift
//  ServicePlatform
//

//
import Foundation

// swiftlint:disable type_name
public struct Validation {
  
  public static func phoneNumberValidation(phone: String) -> Bool {
    let phoneRegex = "^[0-9]{6,14}$"
    return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
  }

  public static func usernameValidation(username: String) -> Bool {
    // Username:
    // Valid Characters: letters, numbers, - &  _
    // Length: 3-16 characters
    let userNameRegEx = "^[a-zA-Z0-9-_]{3,16}$"
    let userNameTest = NSPredicate(format: "SELF MATCHES %@", userNameRegEx)
    return userNameTest.evaluate(with: username)
  }
  
  public static func numberValidation(number: String) -> Bool {
    //  - Numbers{0-9}
    let numberRegEx = "\\A[0-9]{1,20}\\z"
    let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
    return numberTest.evaluate(with: number)
  }

  public static func emailValidation(email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
  }

  // using for validate first and last name
  public static func nameValidation(name: String) -> Bool {
    // Name:
    // Valid Characters: everything except @
    // Length: 3-50 characters
    let userNameRegEx = "^[^@]{1,50}$"
    let userNameTest = NSPredicate(format: "SELF MATCHES %@", userNameRegEx)
    return userNameTest.evaluate(with: name)
  }

  public static func socialNameValidation(socialName: String) -> Bool {
    //  - Lowercase characters {a-z}
    //  - Uppercase characters {A-Z} - Digits {0-9}
    //  - Period {.}
    let userNameRegEx = "\\A[a-zA-Z0-9.]{1,}\\z"
    let userNameTest = NSPredicate(format: "SELF MATCHES %@", userNameRegEx)
    return userNameTest.evaluate(with: socialName)
  }
  
  public static func passwordValidation(password: String) -> Bool {
    // Password should be at least 8 characters long
    let lengthResult = password.count >= 8
    
    // Password should contain at least one uppercase latter
    let capsRegEx  = ".*[A-Z]+.*"
    let capsTest = NSPredicate(format: "SELF MATCHES %@", capsRegEx)
    let capsResult = capsTest.evaluate(with: password)
    
    // at least one lowercase latter
    let lowerRegEx  = ".*[a-z]+.*"
    let lowerTest = NSPredicate(format: "SELF MATCHES %@", lowerRegEx)
    let lowerResult = lowerTest.evaluate(with: password)
    
    // at least one numnber
    let numberRegEx  = ".*[0-9]+.*"
    let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
    let numberResult = numberTest.evaluate(with: password)
    
    // and at least one special character
    let specialChars  = CharacterSet(charactersIn: "^$*.[]{}()?-\"!@#%&/\\,><\':;|_~`")
    let specialResult = password.rangeOfCharacter(from: specialChars).notNil
    
    return lengthResult && capsResult && lowerResult && numberResult && specialResult
  }
  
  public static func confirmCodeValidation(_ text: String, _ codeRegex: String) -> Bool {
    let codeTest = NSPredicate(format: "SELF MATCHES %@", codeRegex)
    return codeTest.evaluate(with: text)
  }
  
  public static func nonEmpty(_ text: String) -> Bool {
    return !text.isEmpty
  }
  
  typealias T = CreditCardType
  public static func creditCardValidation(type: String, creditCardNumber: String) -> Bool {
    var typeRegEx = ""
    switch type {
    case T.visa: // Example: 4111111111111111
      typeRegEx = "^4[0-9]{12}(?:[0-9]{3})?$"
    case T.masterCard:  // Example: 5538383883833838
      typeRegEx = "^5[1-5][0-9]{14}$"
    case T.americanExpress: // Example: 347000000000000
      typeRegEx = "^3[47][0-9]{13}$"
    case T.discover:  // Example: 6550000000000000
      typeRegEx = "^6(?:011|5[0-9]{2})[0-9]{12}$"
    case T.other:
      typeRegEx = ""
    default:
      break
    }
    let typeTest = NSPredicate(format: "SELF MATCHES %@", typeRegEx)
    return typeTest.evaluate(with: creditCardNumber)
  }
}
