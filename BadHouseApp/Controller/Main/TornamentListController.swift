import UIKit

class TornamentListController: UIViewController {
    //Mark properties
    @IBOutlet private weak var tableView: UITableView!
    private let cellId = Constants.CellId.CellGroupId
    //Mark lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    //Mark IBAction
    @IBAction private func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //Mark helperMethod
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = GroupCell.nib()
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
}
//Mark TableViewDelegate
extension TornamentListController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.TornamentDetailVC) as! TornamentDetailController
        navigationController?.pushViewController(vc, animated: true)
    } 
}

extension TornamentListController:UITableViewDataSource {
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
}
