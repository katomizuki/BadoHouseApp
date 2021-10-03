import UIKit

class TornamentController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let cellId = Utility.CellId.CellGroupId
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let nib = GroupCell.nib()
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension TornamentController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId,for: indexPath) as! GroupCell
        cell.cellImagevView.isHidden = true
        cell.label.text = "〇〇オープン大会"
        cell.timeLabel.isHidden = false
        cell.timeLabel.text = "at 神奈川県"
        cell.commentLabel.isHidden = false
        cell.commentLabel.numberOfLines = 2
        cell.commentLabel.text = "○月○日 開催"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TornamentDetailVC") as! TornamentDetailController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
