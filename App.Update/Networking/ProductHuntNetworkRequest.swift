import Foundation

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
}

enum Result<T> {
  case success(T)
  case failure(Error)
}

enum ResourceError: Error {
  case couldNotParse
  case noData
  case noPosts
}

class ProductHuntNetworkRequest {
  let urlSession = URLSession.shared
  let baseURL = "https://api.producthunt.com/v1/"

  func getPosts(_ resource: ProductHuntResource, completion: @escaping (Result<[Post]>) -> Void) {

    urlSession.dataTask(with: getURLRequest(for: resource)) { data, response, error in
      if let error = error {
        return completion(Result.failure(error))
      }

      guard let data = data else {
        return completion(Result.failure(ResourceError.noData))
      }

      guard let result = try? JSONDecoder().decode(PostList.self, from: data) else {
        return completion(Result.failure(ResourceError.couldNotParse))
      }

      guard let posts = result.posts else {
        return completion(Result.failure(ResourceError.noPosts))
      }

      return completion(Result.success(posts))
    }.resume()
  }

  func getComments(_ resource: ProductHuntResource, forPost id: Int, completion: @escaping (Result<[Comment]>) -> Void) {

    urlSession.dataTask(with: getURLRequest(for: resource, withID: id)) { data, response, error in
      if let error = error {
        return completion(Result.failure(error))
      }

      guard let data = data else {
        return completion(Result.failure(ResourceError.noData))
      }

      guard let result = try? JSONDecoder().decode(CommentList.self, from: data) else {
        return completion(Result.failure(ResourceError.couldNotParse))
      }

      guard let comments = result.comments else {
        return completion(Result.failure(ResourceError.noPosts))
      }

      return completion(Result.success(comments))
      }.resume()
  }

  func getURLRequest(for resource: ProductHuntResource, withID id: Int? = nil) -> URLRequest {

    let params = resource.getParams(postID: id)
    print("\(resource.getPath())?\(resource.stringFrom(params))")
    let fullURL = URL(string: baseURL.appending("\(resource.getPath())?\(resource.stringFrom(params))"))!

    var request = URLRequest(url: fullURL)
    request.httpMethod = resource.getHTTPMethod().rawValue
    request.allHTTPHeaderFields = resource.getHeaders(token: "tbi")

    return request
  }
}
