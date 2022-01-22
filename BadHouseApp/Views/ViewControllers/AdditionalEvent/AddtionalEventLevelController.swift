import UIKit
import RxSwift
import RxCocoa

protocol AddtionalEventLevelFlow {
    func toNext(image: UIImage,
                dic: [String: Any],
                circle: Circle,
                user: User)
}

final class AddtionalEventLevelController: UIViewController {
    
    private let disposeBag = DisposeBag()
    @IBOutlet private weak var maxLabel: UILabel!
    @IBOutlet private weak var maxSlider: UISlider!
    @IBOutlet private weak var minLabel: UILabel!
    @IBOutlet private weak var circleTableView: UITableView!
    @IBOutlet private weak var minSlider: UISlider!
    private let viewModel: MakeEventSecondViewModel
    var coordinator: AddtionalEventLevelFlow?
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: R.buttonTitle.next,
                                     style: .done,
                                     target: self,
                                     action: #selector(didTapNextButton))
        return button
    }()
    
    init(viewModel: MakeEventSecondViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        minSlider.value = 0.0
        maxSlider.value = 1.0
        setupTableView()
        navigationItem.title = R.navTitle.two
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setupTableView() {
        circleTableView.register(UITableViewCell.self, forCellReuseIdentifier: R.cellId)
        circleTableView.separatorColor = .darkGray
        circleTableView.allowsMultipleSelection = false
    }
    
    private func setupBinding() {
        
        viewModel.outputs.minLevelText.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.minLabel.text = "\(text)から"
        }).disposed(by: disposeBag)
        
        viewModel.outputs.maxLevelText.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.maxLabel.text = text
        }).disposed(by: disposeBag)
        
        viewModel.outputs.circleRelay.bind(to: circleTableView.rx.items(cellIdentifier: R.cellId, cellType: UITableViewCell.self)) { _, item, cell in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = item.name
            cell.selectionStyle = .none
            cell.contentConfiguration = configuration
        }.disposed(by: disposeBag)
        
        circleTableView.rx.itemSelected.asDriver().drive(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            guard let cell = self.circleTableView.cellForRow(at: indexPath) else { return }
            cell.accessoryType = .checkmark
            self.viewModel.circle = self.viewModel.circleRelay.value[indexPath.row]
            self.rightButton.isEnabled = true
        }).disposed(by: disposeBag)
        
        circleTableView.rx.itemDeselected.asDriver().drive(onNext: { indexPath in
            guard let cell = self.circleTableView.cellForRow(at: indexPath) else { return }
            cell.accessoryType = .none
        }).disposed(by: disposeBag)
    }
    
    // MARK: - IBAction
    @IBAction private func minLevelSliderChanged(_ sender: UISlider) {
        viewModel.inputs.minLevel.onNext(sender.value)
    }
    
    @IBAction private func maxLevelSliderChanged(_ sender: UISlider) {
        viewModel.inputs.maxLevel.onNext(sender.value)
    }
    
    @IBAction private func didTapLevelDetailButton(_ sender: Any) {
        let controller = LevelDetailController.init(nibName: R.nib.levelDetailController.name, bundle: nil)
        present(controller, animated: true)
    }
    
    @objc private func didTapNextButton() {
        guard let circle = self.viewModel.circle else { return }
        guard let user = self.viewModel.user else { return }
        self.viewModel.dic["minLevel"] = self.viewModel.minLevelText.value
        self.viewModel.dic["maxLevel"] = self.viewModel.maxLevelText.value
        self.coordinator?.toNext(image: self.viewModel.image,
                                 dic: self.viewModel.dic,
                                 circle: circle, user: user)
    }
}
