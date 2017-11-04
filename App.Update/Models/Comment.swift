import Foundation

struct Comment {
  let id: Int
  let body: String
}

struct CommentList: Decodable {
  let comments: [Comment]?
}

// MARK: Decodable
extension Comment: Decodable {
  init(from decoder: Decoder) throws {
    let commentsContainer = try decoder.container(keyedBy: CommentsKeys.self)

    let id = try commentsContainer.decode(Int.self, forKey: .id)
    let body = try commentsContainer.decode(String.self, forKey: .body)

    self.init(id: id, body: body)
  }
}

// MARK: CodingKeys
private extension Comment {
  enum CommentsKeys: CodingKey {
    case id
    case body
  }
}


