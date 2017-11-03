import UIKit

final class FeedViewController: UIViewController {
  @IBOutlet weak var feedTableView: UITableView!
  var posts: [Post]? {
    didSet {
      let range = NSMakeRange(0, feedTableView.numberOfSections)
      let sections = NSIndexSet(indexesIn: range)

      feedTableView.reloadSections(sections as IndexSet, with: .automatic)
    }
  }

  var productHuntNetworkRequest: ProductHuntNetworkRequest!
  var selectionColor: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    feedTableView.delegate = self
    feedTableView.dataSource = self

    productHuntNetworkRequest = ProductHuntNetworkRequest()

    updateFeed()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

//Mark: Tablivew datasource
extension FeedViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let posts = posts else { return 0 }

    return posts.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let postCell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
    guard let posts = posts else { return postCell }
    let post = posts[indexPath.row]

    postCell.title.text = post.name


    postCell.backgroundImage.getPostScreenshot(with: post.screenshot)


    return postCell
  }
}

// MARK: Tableview delegate
extension FeedViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200
  }
}

// MARK: Helper methods
private extension FeedViewController {
  func updateFeed() {
    let resource = ProductHuntResource.posts

    DispatchQueue.global(qos: .background).async { [weak self] in
      self?.productHuntNetworkRequest.getFeaturedPosts(resource: resource) { (res: Result<[Post]>) in
        switch res {
        case let .success(data):
          DispatchQueue.main.async {
            self?.posts = data
          }
        case let .failure(error):
          break
        }

      }
    }
  }
}

