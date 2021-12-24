//
//  ScheduleController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/24.
//

import UIKit
import FSCalendar
final class ScheduleController: UIViewController {

    @IBOutlet private weak var calendarView: FSCalendar!
    @IBOutlet private weak var practiceTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
    }
    private func setupTableView() {
        practiceTableView.delegate = self
        practiceTableView.dataSource = self
        practiceTableView.register(SchduleCell.nib(), forCellReuseIdentifier: SchduleCell.id)
        practiceTableView.showsVerticalScrollIndicator = false
        practiceTableView.rowHeight = 60
    }
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapLeftBarButton))
    }
    @objc private func didTapLeftBarButton() {
        dismiss(animated: true)
    }
}
// MARK: - UITableViewDelegate
extension ScheduleController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
}
// MARK: - UITableViewDataSource
extension ScheduleController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SchduleCell.id, for: indexPath) as? SchduleCell else { fatalError() }
        cell.delegate = self
        return cell
    }
}
// MARK: - SchduleCellDelegate
extension ScheduleController: SchduleCellDelegate {
    func onTapTrashButton(_ cell: SchduleCell) {
        print(#function)
    }
}
