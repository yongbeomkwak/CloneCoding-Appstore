import Foundation

public final class NetworkClient<E: Endpoint>: Requestable {
  private let session: URLSession

  init(session: URLSession = URLSession.shared) {
    self.session = session
  }

  func request(_ endpoint: E) async throws -> Data {
    var request = try configureURLRequest(endpoint)
    try encodeBodyWithJSON(endpoint, into: &request)
    try encodeQuery(endpoint, into: &request)
    return try await performRequest(request: request, from: endpoint)
  }
}

private extension NetworkClient {
  // URL, httpMethod, TimeOut 설정
  private func configureURLRequest(_ endpoint: E) throws -> URLRequest {
    let requestURL = try URL(from: endpoint)
    var request = URLRequest(url: requestURL, timeoutInterval: endpoint.timeout)
    request.httpMethod = endpoint.method.description
    return request
  }
  // body 설정
  private func encodeBodyWithJSON(_ endpoint: E, into request: inout URLRequest) throws {
    do {
      if let body = endpoint.body {
        let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      }
    } catch {
      throw NetworkError.encodingFailed
    }
  }
  // query. 설정
  private func encodeQuery(_ endpoint: E, into request: inout URLRequest) throws {
    guard let url = request.url,
          var component = URLComponents(url: url, resolvingAgainstBaseURL: false),
          let paramenter = endpoint.query
    else { throw NetworkError.invalidURL }

    component.queryItems = paramenter.map {
      URLQueryItem(name: $0.key, value: "\($0.value)".urlQueryAllowed)
    }

    request.url = component.url
  }
  // response 요청
  private func performRequest(request: URLRequest, from endpoint: E) async throws -> Data {
    let (data, urlResponse) = try await session.data(for: request)
    guard let httpResponse = urlResponse as? HTTPURLResponse else { throw NetworkError.invalidResponse }

    let statusCode = httpResponse.statusCode

    debugResponse(data, urlResponse, from: endpoint)
    if !(endpoint.validationCode ~= statusCode) {
      throw HTTPError(statuscode: statusCode)
    }

    return data
  }

  private func debugResponse(_ data: Data, _ response: URLResponse, from endpoint: Endpoint) {
    guard let url = response.url, let httpResponse = response as? HTTPURLResponse else { return }
    let statusCode = httpResponse.statusCode
    let isSuccess = statusCode >= 200 && statusCode < 300
    let emoji = isSuccess ? "✅" : "❌"
    let successText = isSuccess ? "Success" : "Fail"

    print("------------------- Network connection: \(successText) -------------------")
    print("\n[\(emoji) Status Code: \(statusCode)] \(url)\n----------------------------------------------------\n")
    print("------------------- Body -------------------\n")
//    if let resDataString = String(bytes:data, encoding: String.Encoding.utf8) {
//      print("\(resDataString)\n")
//    }
    print("------------------- Body END -------------------\n")

    print("------------------- END HTTP-------------------\n")
  }
}
