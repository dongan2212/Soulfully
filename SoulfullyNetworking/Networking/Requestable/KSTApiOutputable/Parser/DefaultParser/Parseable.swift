public protocol Parseable {
  func parse<T>(_ data: Data) -> T?
}
public class CodeableParser<ParsingType: Decodable>: Parseable {
  public init() {}
  public func parse<T>(_ data: Data) -> T? {
    debugPrint("==>T:\(T.self)")
    do {
      return try JSONDecoder().decode(ParsingType.self, from: data) as? T
    } catch let DecodingError.dataCorrupted(context) {
      KSTLogger.write(log: "Coding Path: \(context.codingPath)", logLevel: .error)
      
      print("Coding Path: \(context.codingPath)")
    } catch let DecodingError.keyNotFound(key, context) {
      KSTLogger.write(log: "Key '\(key)' not found: \(context.debugDescription)", logLevel: .error)
      KSTLogger.write(log: "Coding Path: \(context.codingPath)", logLevel: .error)
      
      print("Key '\(key)' not found: \(context.debugDescription)")
      print("Coding Path: \(context.codingPath)")
    } catch let DecodingError.valueNotFound(value, context) {
      KSTLogger.write(log: "Value '\(value)' not found: \(context.debugDescription)", logLevel: .error)
      KSTLogger.write(log: "Coding Path: \(context.codingPath)", logLevel: .error)
      
      print("Value '\(value)' not found: \(context.debugDescription)")
      print("Coding Path: \(context.codingPath)")
    } catch let DecodingError.typeMismatch(type, context) {
      KSTLogger.write(log: "Type '\(type)' mismatch: \(context.debugDescription)", logLevel: .error)
      KSTLogger.write(log: "Coding Path: \(context.codingPath)", logLevel: .error)
      
      print("Type '\(type)' mismatch: \(context.debugDescription)")
      print("Coding Path: \(context.codingPath)")
    } catch {
      KSTLogger.write(log: "Decoding Error: \(error.localizedDescription)", logLevel: .error)
      
      print("Decoding Error: \(error.localizedDescription)")
    }
    return nil
  }
}
