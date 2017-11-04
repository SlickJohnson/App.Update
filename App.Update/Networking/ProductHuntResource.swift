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
  case comments

  func getHTTPMethod() -> HTTPMethod {
    switch self {
    case .posts, .comments:
      return .get
    }
  }

  func getHeaders(token: String) -> [String: String] {
    switch self {
    case .posts, .comments:
      return [
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer 1314a6c0bc682dd5f0689452aefa2c8b03fdd852a21a00fae33c7d648678a726", // TODO: \(token)
        "Host": "api.producthunt.com"
      ]
    }
  }

  func getParams(postID: Int? = nil) -> [String: String] {
    switch self {
    case .posts:
      return [
        "sort_by": "votes_count",
        "order": "desc",
        "per_page": "20",

        "search[featured]": "true"
      ]

    case .comments:
      guard let postID = postID else { return [:] }

      return [
        "sort_by": "votes",
        "order": "asc",
        "per_page": "20",

        "search[post_id]": "\(postID)"
      ]
    }
  }

  func stringFrom(_ parameters: [String: String]) -> String {

    let parameterArray = parameters.map { key, value in
      return "\(key)=\(value)"
    }

    return parameterArray.joined(separator: "&")
  }

  func getPath() -> String {
    switch self {
    case .posts:
      return "posts/all"
      
    case .comments:
      return "comments"
    }
  }

}
