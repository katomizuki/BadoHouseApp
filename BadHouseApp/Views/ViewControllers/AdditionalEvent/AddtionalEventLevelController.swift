import UIKit
import RxSwift
import RxCocoa

final class AddtionalEventLevelController: UIViewController {
    
    @IBOutlet private weak var maxLabel: UILabel!
    @IBOutlet private weak var maxSlider: UISlider!
    @IBOutlet private weak var minLabel: UILabel!
    @IBOutlet private weak var circleTableView: UITableView!
    @IBOutlet private weak var minSlider: UISlider!

    private let viewModel: MakeEventSecondViewModel
    private let disposeBag = DisposeBag()
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: R.buttonTitle.next,
                                     style: .done,
                                     target: self,
                                     action: #selector(didTapNextButton))
        return button
    }()

    var coordinator: AddtionalEventLevelFlow?
    
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
        setupUI()
    }

    private func setupUI() {
        setupTableView()
        setupSlider()
        setupNavigationItem()
    }

    private func setupSlider() {
        minSlider.value = 0.0
        maxSlider.value = 1.0
    }

    private func setupNavigationItem() {
        navigationItem.title = R.navTitle.two
        navigationItem.rightBarButtonItem = rightButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.willAppear.accept(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.willDisAppear.accept(())
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
        viewModel.inputs.minLevelInput.onNext(sender.value)
    }
    
    @IBAction private func maxLevelSliderChanged(_ sender: UISlider) {
        viewModel.inputs.maxLevelInput.onNext(sender.value)
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
