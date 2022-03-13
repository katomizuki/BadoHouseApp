import UIKit

final class BlockListDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    var viewModel: BlockListViewModel?
    
    func initViewModel(viewModel: BlockListViewModel) {
        self.viewModel = viewModel
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        viewModel.inputs.removeBlock(viewModel.outputs.blockListRelay.value[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "ブロック解除"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.outputs.blockListRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.id, for: indexPath) as? CustomCell else { fatalError() }
        guard let viewModel = viewModel else { return cell }
        cell.configure(user: viewModel.outputs.blockListRelay.value[indexPath.row])
        return cell
    }
}
