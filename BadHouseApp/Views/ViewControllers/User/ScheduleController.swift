import UIKit
import FSCalendar
import RxSwift
import RxCocoa

protocol ScheduleFlow {
    func toDetail(_ practice: Practice)
}

final class ScheduleController: UIViewController, UIScrollViewDelegate {

    @IBOutlet private weak var calendarView: FSCalendar!
    @IBOutlet private weak var practiceTableView: UITableView!
    private let disposeBag = DisposeBag()
    private let viewModel: ScheduleViewModel
    var coordinator: ScheduleFlow?
    
    init(viewModel: ScheduleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        setupBinding()
        setupCalendarView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.willAppear()
    }
    
    private func setupCalendarView() {
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    private func setupTableView() {
        practiceTableView.register(SchduleCell.nib(), forCellReuseIdentifier: SchduleCell.id)
        practiceTableView.showsVerticalScrollIndicator = false
        practiceTableView.rowHeight = 60
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapLeftBarButton))
    }
    
    private func setupBinding() {
        
        practiceTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.practiceTableView.reloadData()
            self?.calendarView.reloadData()
        }.disposed(by: disposeBag)
        
        viewModel.outputs.isError.subscribe { [weak self] _ in
            self?.showCDAlert(title: "通信エラーです", message: "", action: "OK", alertType: .warning)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.practiceList.bind(to: practiceTableView.rx.items(cellIdentifier: SchduleCell.id, cellType: SchduleCell.self)) { _, item, cell in
            cell.configure(item)
        }.disposed(by: disposeBag)
        
        practiceTableView.rx.itemSelected.bind { [weak self] indexPath in
            guard let self = self else { return }
            self.coordinator?.toDetail(self.viewModel.outputs.practiceList.value[indexPath.row])
        }.disposed(by: disposeBag)
    }
    
    @objc private func didTapLeftBarButton() {
        dismiss(animated: true)
    }
}

extension ScheduleController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        return viewModel.outputs.practiceList.value.filter {
            let dateString = DateUtils.stringFromDate(date: date, format: "yyyy/MM/dd")
            return DateUtils.stringFromDate(date: $0.start.dateValue(), format: "yyyy/MM/dd") == dateString
        }.count
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        var color: UIColor?
        viewModel.outputs.practiceList.value.forEach {
            if DateUtils.stringFromDate(date: $0.start.dateValue(), format: "yyyy/MM/dd") == DateUtils.stringFromDate(date: date, format: "yyyy/MM/dd") {
                color = .systemBlue
            }
        }
        return color
    }
}
