import Foundation

struct Post {
  let id: Int
  let name: String
  let tagline: String
  var screenshotURL: URL
  let votesCount: Int
  let commentsCount: Int
}

struct PostList: Decodable {
  let posts: [Post]?
}

// MARK: Decodable
extension Post: Decodable {
  init(from decoder: Decoder) throws {
    let postsContainer = try decoder.container(keyedBy: PostsKeys.self)

    let id = try postsContainer.decode(Int.self, forKey: .id)
    let name = try postsContainer.decode(String.self, forKey: .name)
    let tagline = try postsContainer.decode(String.self, forKey: .tagline)
    let votesCount = try postsContainer.decode(Int.self, forKey: .votesCount)
    let commentsCount = try postsContainer.decode(Int.self, forKey: .commentsCount)

    let screenshotURLContainer = try postsContainer.nestedContainer(keyedBy: ScreenshotURLKeys.self, forKey: .screenshotURL)

    let screenshotURL = try screenshotURLContainer.decode(URL.self, forKey: .screenshotURL)
    let screenshotImageView = screenshotURL

    self.init(id: id, name: name, tagline: tagline, screenshotURL: screenshotImageView, votesCount: votesCount, commentsCount: commentsCount)
  }
}

// MARK: CodingKeys
private extension Post {
  enum PostsKeys: String, CodingKey {
    case id
    case name
    case tagline
    case screenshotURL = "screenshot_url"
    case votesCount = "votes_count"
    case commentsCount = "comments_count"
  }

  enum ScreenshotURLKeys: String, CodingKey {
    case screenshotURL = "850px"
  }
}

