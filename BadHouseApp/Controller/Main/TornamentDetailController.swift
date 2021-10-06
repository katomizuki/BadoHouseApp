import UIKit

class TornamentDetailController: UIViewController {

    private let tornamentLabel = ProfileLabel(title: "〇〇大会", num: 20)
    private let detailTextView:UITextView = {
        let tv = UITextView()
        return tv
    }()
    private let startDayLabel = ProfileLabel(title: "応募開始日　20〇〇年〇月〇日",num: 14)
    private let deadLineLabel = ProfileLabel(title: "締め切り日　20〇〇年〇月〇日",num: 14)
    private let holdDayLabel = ProfileLabel(title: "開催日　20〇〇年〇月〇〇日", num: 14)
    private let moneyLabel = ProfileLabel(title: "     シングルス〇〇円,ダブルス〇〇円")
    private let placeLabel = ProfileLabel(title: "開催場所　〇〇スポーツセンター", num: 14)
    private let addressLabel = ProfileLabel(title: "〇〇〇-〇〇〇〇 〇〇県〇〇市〇丁目〇番",num:14)
    private let inquiryLabel = ProfileLabel(title: "受付担当　加藤瑞樹,katobad.0405@gmail.com", num: 14)
    private let shuttleLabel = ProfileLabel(title: "使用予定シャトル【LI-NING FA+500 】", num: 14)
    private let scheduletv:UITextView = {
        let tv = UITextView()
        return tv
    }()
    private let competitionMethodLabel = ProfileLabel(title: "予選トーナメント形式", num: 14)
    private let urlLabel = ProfileLabel(title: "大会URL　https://www.facebook.com/", num: 14)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavAccessory()
    }
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [tornamentLabel, holdDayLabel,startDayLabel,deadLineLabel,placeLabel,addressLabel,moneyLabel,inquiryLabel,shuttleLabel,competitionMethodLabel,urlLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        view.addSubview(detailTextView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,paddingTop: 20,centerX: view.centerXAnchor,height: 400)
        detailTextView.anchor(top:stackView.bottomAnchor,bottom:view.safeAreaLayoutGuide.bottomAnchor,left:view.leftAnchor,right: view.rightAnchor,paddingTop:20, paddingBottom:20, paddingRight:20, paddingLeft: 20)
    }
    
    
    


}
