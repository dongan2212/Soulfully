import Alamofire
public typealias KSTApiResponse = (data: Data?, error: Error?, statusCode: Int)
public protocol KSTRequestable {
  associatedtype OutputType: KSTApiOutputable
  associatedtype InputType: KSTApiInputable
  var input: InputType { get }
  var output: OutputType { get set }
  func excute(with config: APIConfigable,
              and requester: RequesterProviable,
              complete: @escaping (KSTApiResponse) -> Void)
  func getOutput() -> OutputType?
}
extension KSTRequestable {
  public func excute(with config: APIConfigable,
                     and requester: RequesterProviable,
                     complete: @escaping (KSTApiResponse) -> Void) {
    let fullPathToApi = input.makeFullPathToApi(with: config)
    print("DEBUG - URL request: \(fullPathToApi)")
    print("DEBUG - Request Type: \(input.requestType)")
    self.logRequestInfo(with: fullPathToApi)
    if input.getBodyEncode() == .json {
      requester.makeRequest(path: fullPathToApi,
                            requestType: input.requestType,
                            headers: input.makeRequestableHeader(),
                            params: input.makeRequestableBody()) { response in
        self.updateResultForOutput(from: response)
        complete(response)
      }
    } else {
      requester.makeFormDataRequest(path: fullPathToApi,
                                    requestType: input.requestType,
                                    headers: input.makeRequestableHeader(),
                                    params: input.makeRequestableBody()) { response in
        self.updateResultForOutput(from: response)
        complete(response)
      }
    }
  }
}
extension KSTRequestable {
  private func updateResultForOutput(from response: KSTApiResponse) {
    if let data = response.data,
       let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
      KSTLogger.write(log: """
              \n----------------------RAW JSON----------------------
              \(json)
              ----------------------********----------------------
              """)
      print("""
              \n----------------------RAW JSON----------------------
              \(json)
              ----------------------********----------------------
              """)
    }
    
    if hasError(statusCode: response.statusCode) {
      self.output.convertError(from: response.data,
                               systemError: response.error)
    } else {
      self.output.convertData(from: response.data)
    }
  }
  
  private func hasError(statusCode: Int) -> Bool {
    return (statusCode < 200 || statusCode > 299)
  }
  
  private func logRequestInfo(with path: String) {
    KSTLogger.write(log: "API full api: \(path)", logLevel: .warning)
    KSTLogger.write(log: "[\(type(of: self.input))][Type]: HTTP.\(self.input.requestType)", logLevel: .verbose)
    KSTLogger.write(log: "[\(type(of: self.input))][Param]: \(self.input.makeRequestableBody())",
                    logLevel: .verbose)
    KSTLogger.write(log: "[\(type(of: self.input))][Encode]: \(input.getBodyEncode())",
                    logLevel: .verbose)
  }
}
