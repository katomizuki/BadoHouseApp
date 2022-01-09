import UIKit
protocol PracticeDataSourceDelegateProtocol:AnyObject {
    func presentVC(_ vc: SearchSelectionController)
}
class PracticeDataSourceDelegate:NSObject,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate, SearchSelectionControllerDelegate {
    
    weak var delegate: PracticeDataSourceDelegateProtocol?
    var viewModel:PracticeSearchViewModel?
    func initViewModel(viewModel:PracticeSearchViewModel) {
        self.viewModel = viewModel
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return }
        if indexPath.row != 2 {
            let viewController = SearchSelectionController()
            viewController.modalPresentationStyle = .popover
            viewController.preferredContentSize = CGSize(width: 200, height: 150)
            viewController.delegate = self
            let presentationController = viewController.popoverPresentationController
            presentationController?.delegate = self
            presentationController?.permittedArrowDirections = .up
            presentationController?.sourceView = cell
            presentationController?.sourceRect = cell.bounds
            viewController.keyWord = SearchSelection(rawValue: indexPath.row) ?? .level
            viewController.presentationController?.delegate = self
            self.delegate?.presentVC(viewController)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchSelection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        guard let viewModel = viewModel else { return cell }
        configuration.text = SearchSelection(rawValue: indexPath.row)?.description
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            configuration.secondaryText = viewModel.outputs.selectedPlace
        } else if indexPath.row == 1 {
            configuration.secondaryText = viewModel.outputs.selectedLevel
        }
        cell.contentConfiguration = configuration
        return cell
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    func searchSelectionControllerDismiss(vc: SearchSelectionController, selection: SearchSelection, text: String) {
        guard let viewModel = viewModel else { return }
        vc.dismiss(animated: true)
        viewModel.inputs.changeSelection(selection, text: text)
    }
}
