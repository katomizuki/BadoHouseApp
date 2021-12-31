//
//  ProblemInformationController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/31.
//

import UIKit

final class ProblemInformationController: UIViewController {

    @IBOutlet private weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "不具合報告"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "報告", style: .done, target: self, action: #selector(didTapRightButton))
    }
    @objc private func didTapRightButton() {
        let id = Ref.BlockRef.document().documentID
        guard let text = textView.text else { return }
        Ref.BlockRef.document(id).setData(["problem":text])
    }


}
