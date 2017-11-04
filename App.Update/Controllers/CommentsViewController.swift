import UIKit

final class CommentsViewController: UIViewController {

  @IBOutlet weak var commentsTableView: UITableView!
  @IBOutlet weak var postScreenshot: UIImageView!

  var productHuntNetworkRequest: ProductHuntNetworkRequest!
  var postCell: PostTableViewCell?

  var comments: [Comment]? {
    didSet {
      let range = NSMakeRange(0, commentsTableView.numberOfSections)
      let sections = NSIndexSet(indexesIn: range)

      commentsTableView.reloadSections(sections as IndexSet, with: .automatic)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    commentsTableView.delegate = self
    commentsTableView.dataSource = self

    productHuntNetworkRequest = ProductHuntNetworkRequest()

    postScreenshot.image = postCell?.backgroundImage.image
    postScreenshot.contentMode = .scaleAspectFill
    postScreenshot.layer.cornerRadius = 5
    postScreenshot.clipsToBounds = true

    updateComments()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

//Mark: Tablivew datasource
extension CommentsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let comments = comments else { return 0 }

    return comments.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let commentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
    guard let comments = comments else { return commentCell }
    let comment = comments[indexPath.row]

    commentCell.body.text = comment.body

    return commentCell
  }
}

// MARK: Tableview delegate
extension CommentsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 124
  }
}

// MARK: Helper methods
private extension CommentsViewController {
  func updateComments() {
    guard let postID = postCell?.postID else { return }

    let resource = ProductHuntResource.comments

    DispatchQueue.global(qos: .background).async { [weak self] in
      self?.productHuntNetworkRequest.getComments(resource, forPost: postID) { res in
        switch res {
        case let .success(data):
          DispatchQueue.main.async {
            self?.comments = data
          }

        case let .failure(error):
          dump(error)
        }
      }
    }
  }
}


