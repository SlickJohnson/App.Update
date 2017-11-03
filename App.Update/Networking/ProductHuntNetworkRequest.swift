import Foundation

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
}

enum Result<T> {
  case success(T)
  case failure(Error)
}

enum PostError: Error {
  case couldNotParse
  case noData
  case noPosts
}

class ProductHuntNetworkRequest {
  let urlSession = URLSession.shared
  let baseURL = "https://api.producthunt.com/v1/"

  func getFeaturedPosts(resource: ProductHuntResource, completion: @escaping (Result<[Post]>) -> Void) {
    let fullURL = URL(string: baseURL.appending(resource.getPath()))!

    var request = URLRequest(url: fullURL)
    request.httpMethod = resource.getHTTPMethod().rawValue
    request.allHTTPHeaderFields = resource.getHeaders(token: "tbi")

    urlSession.dataTask(with: request) { data, response, error in
      if let error = error {
        return completion(Result.failure(error))
      }

      guard let data = data else {
        return completion(Result.failure(PostError.noData))
      }

      guard let result = try? JSONDecoder().decode(PostList.self, from: data) else {
        return completion(Result.failure(PostError.couldNotParse))
      }

      guard let posts = result.posts else {
        return completion(Result.failure(PostError.noPosts))
      }

      return completion(Result.success(posts))
    }.resume()
  }
}
