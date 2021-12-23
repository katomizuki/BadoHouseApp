import Foundation
import UIKit
protocol RuleControllerDelegate: AnyObject {
    func didTapBackButton(_ vc: RuleController)
}
final class RuleController: UIViewController {
    weak var delegate: RuleControllerDelegate?
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: Constants.ImageName.double), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    private let textview: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textColor = .label
        tv.isSelectable = false
        tv.isEditable = false
        tv.text = "利用規約\nこの利用規約（以下，「本規約」といいます。）は、このアプリの利用条件を定めるものです。\n登録ユーザーの皆さま（以下，「ユーザー」といいます。）には，本規約に従って，本サービスをご利用いただきます。\n第1条（適用）\n本規約は，ユーザーと当社との間の本サービスの利用に関わる一切の関係に適用されるものとします。当社は本サービスに関し，本規約のほか，ご利用にあたってのルール等，各種の定め（以下，「個別規定」といいます。）をすることがあります。これら個別規定はその名称のいかんに関わらず，本規約の一部を構成するものとします。本規約の規定が前条の個別規定の規定と矛盾する場合には，個別規定において特段の定めなき限り，個別規定の規定が優先されるものとします。\n第2条（利用登録）\n本サービスにおいては，登録希望者が本規約に同意の上，当社の定める方法によって利用登録を申請し，当社がこの承認を登録希望者に通知することによって，利用登録が完了するものとします。\n当社は，利用登録の申請者に以下の事由があると判断した場合，利用登録の申請を承認しないことがあり，その理由については一切の開示義務を負わないものとします。利用登録の申請に際して虚偽の事項を届け出た場合 本規約に違反したことがある者からの申請である場合 その他，当社が利用登録を相当でないと判断した場合 \n第3条（ユーザーIDおよびパスワードの管理）ユーザーは，自己の責任において，本サービスのユーザーIDおよびパスワードを適切に管理するものとします。\nユーザーは，いかなる場合にも，ユーザーIDおよびパスワードを第三者に譲渡または貸与し，もしくは第三者と共用することはできません。当社は，ユーザーIDとパスワードの組み合わせが登録情報と一致してログインされた場合には，そのユーザーIDを登録しているユーザー自身による利用とみなします。ユーザーID及びパスワードが第三者によって使用されたことによって生じた損害は，当社に故意又は重大な過失がある場合を除き，当社は一切の責任を負わないものとします。第4条（利用料金および支払方法）本サービスは無料で利用できるため本社からユーザーに料金を請求することは一切ありません。\n第5条（禁止事項）\nユーザーは，本サービスの利用にあたり，以下の行為をしてはなりません。\n法令または公序良俗に違反する行為犯罪行為に関連する行為 \n当社，本サービスの他のユーザー，または第三者のサーバーまたはネットワークの機能を破壊したり，妨害したりする行為 \n当社のサービスの運営を妨害するおそれのある行為 他のユーザーに関する個人情報等を収集または蓄積する行為 \n不正アクセスをし，またはこれを試みる行為 他のユーザーに成りすます行為 \n当社のサービスに関連して，反社会的勢力に対して直接または間接に利益を供与する行為 \n当社，本サービスの他のユーザーまたは第三者の知的財産権，肖像権，プライバシー，名誉その他の権利または利益を侵害する行為 以下の表現を含み，または含むと当社が判断する内容を本サービス上に投稿し，または送信する行為 過度に暴力的な表現 \n露骨な性的表現 人種，国籍，信条，性別，社会的身分，門地等による差別につながる表現 \n自殺，自傷行為，薬物乱用を誘引または助長する表現 その他反社会的な内容を含み他人に不快感を与える表現 \n以下を目的とし，または目的とすると当社が判断する行為 \n営業，宣伝，広告，勧誘，その他営利を目的とする行為（当社の認めたものを除きます。） \n性行為やわいせつな行為を目的とする行為 面識のない異性との出会いや交際を目的とする行為 \n他のユーザーに対する嫌がらせや誹謗中傷を目的とする行為 \n当社，本サービスの他のユーザー，または第三者に不利益，損害または不快感を与えることを目的とする行為 \nその他本サービスが予定している利用目的と異なる目的で本サービスを利用する行為 宗教活動または宗教団体への勧誘行為 その他，当社が不適切と判断する行為 \n第6条（本サービスの提供の停止等）\n 当社は，以下のいずれかの事由があると判断した場合，ユーザーに事前に通知することなく本サービスの全部または一部の提供を停止または中断することができるものとします。 \n本サービスにかかるコンピュータシステムの保守点検または更新を行う場合 \n地震，落雷，火災，停電または天災などの不可抗力により，本サービスの提供が困難となった場合 コンピュータまたは通信回線等が事故により停止した場合 その他，当社が本サービスの提供が困難と判断した場合 当社は，本サービスの提供の停止または中断により，ユーザーまたは第三者が被ったいかなる不利益または損害についても，一切の責任を負わないものとします。"
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textview)
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         paddingTop: 15,
                         paddingLeft: 15,
                         width: 35,
                         height: 35)
        textview.anchor(top: backButton.bottomAnchor,
                        bottom: view.bottomAnchor,
                        left: view.leftAnchor,
                        right: view.rightAnchor,
                        paddingTop: 20,
                        paddingBottom: 20,
                        paddingRight: 20,
                        paddingLeft: 20)
    }
    @objc private func back() {
        print(#function)
        self.delegate?.didTapBackButton(self)
    }
}
