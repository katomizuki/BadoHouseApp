import UIKit
import RxSwift

final class CircleChatController: UIViewController, UIScrollViewDelegate {
    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    private lazy var customInputView: CustomInputAccessoryView = {
        let ci = CustomInputAccessoryView(frame: CGRect(x: 0,
                                                        y: 0,
                                                        width: view.frame.width,
                                                        height: 50))
        ci.delegate = self
        return ci
    }()
    var coordinator: ChatCoordinator?
    private let viewModel: ChatViewModel
    private let disposeBag = DisposeBag()
    
    override var inputAccessoryView: UIView? {
        return customInputView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputs.didLoad()
        setupTableView()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.willAppear.accept(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.willDisAppear.accept(())
    }
    
    // MARK: - SetupMethod
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(ChatCell.nib(), forCellReuseIdentifier: ChatCell.id)
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupBinding() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.outputs.chatsList.bind(to: tableView.rx.items(cellIdentifier: ChatCell.id, cellType: ChatCell.self)) { _, item, cell in
            cell.configure(chat: item,
                           user: self.viewModel.user ,
                           myData: self.viewModel.myData)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
    }
}
// MARK: - InputDelegate
extension CircleChatController: InputDelegate {
    func inputView(inputView: CustomInputAccessoryView, message: String) {
        guard let text: String = inputView.messageInputTextView.text else { return }
        viewModel.inputs.sendText(text)
        if text == "" { return }
        inputView.messageInputTextView.text = ""
    }
}
