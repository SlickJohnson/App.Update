import UIKit

class PostTableViewCell: UITableViewCell {
  
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var containerView: UIView!

  override func awakeFromNib() {
    super.awakeFromNib()

    containerView?.layer.cornerRadius = 8
    containerView?.clipsToBounds = true

    let selectionColor = UIView()
    selectionColor.backgroundColor = UIColor.black
    selectedBackgroundView = selectionColor
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
