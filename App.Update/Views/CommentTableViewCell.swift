import UIKit

final class CommentTableViewCell: UITableViewCell {
  
  @IBOutlet weak var body: UITextView!

  override func awakeFromNib() {
    super.awakeFromNib()

    body.layer.cornerRadius = 8
    body.clipsToBounds = true

    let selectionColor = UIView()
    selectionColor.backgroundColor = UIColor.black
    selectedBackgroundView = selectionColor
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}

