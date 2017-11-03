import Foundation

/* Needed for a request
 1. HTTPMethod
 2. Params
 3. Headers
 4. Base URL
 5. Path
 */

enum ProductHuntResource {
  case posts

  func getHTTPMethod() -> HTTPMethod {
    switch self {
    case .posts:
      return .get
    }
  }

  func getHeaders(token: String) -> [String: String] {
    switch self {
    case .posts:
      return [
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer 1314a6c0bc682dd5f0689452aefa2c8b03fdd852a21a00fae33c7d648678a726", // TODO: \(token)
        "Host": "api.producthunt.com"
      ]
    }
  }

  func getParams() -> [String: String] {
    switch self {
    case .posts:
      return [
        "search[featured]": "true",
        "per_page": "2",
        "created_at": String(describing: Date())
      ]
    }
  }

  func getPath() -> String {
    switch self {
    case .posts:
      return "posts/all"
    }
  }

}
