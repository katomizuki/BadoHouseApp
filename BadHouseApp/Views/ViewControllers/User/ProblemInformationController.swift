import UIKit
import FirebaseFirestore
import FirebaseStorage

final class ProblemInformationController: UIViewController {

    @IBOutlet private weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        navigationItem.title = R.navTitle.problem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: R.buttonTitle.report, style: .done, target: self, action: #selector(didTapRightButton))
    }
    
    @objc private func didTapRightButton() {
        let id = Ref.ReportRef.document().documentID
        guard let text = textView.text else { return }
        textView.text = ""
        Ref.ReportRef.document(id).setData(["problem": text])
        self.showAlert(title: R.alertMessage.thankYou,
                         message: "",
                         action: R.alertMessage.ok)
    }
}

struct Ref {
    static let UsersRef = Firestore.firestore().collection(R.Collection.Users)
    static let StorageUserImageRef =  Storage.storage().reference().child("User/Image")
    static let CircleRef = Firestore.firestore().collection("Teams")
    static let StorageTeamImageRef = Storage.storage().reference().child("Team/Image")
    static let StorageEventImageRef = Storage.storage().reference().child("Event/Image")
    static let ReportRef = Firestore.firestore().collection("Report")
    static let ApplyRef = Firestore.firestore().collection("Apply")
    static let ApplyedRef = Firestore.firestore().collection("Applyed")
    static let MatchRef = Firestore.firestore().collection("Match")
    static let PracticeRef = Firestore.firestore().collection(R.Collection.Practice)
    static let ChatRef = Firestore.firestore().collection("Chat")
    static let PreJoinRef = Firestore.firestore().collection(R.Collection.PreJoin)
    static let PreJoinedRef = Firestore.firestore().collection(R.Collection.PreJoined)
    static let JoinRef = Firestore.firestore().collection("Join")
    static let NotificationRef = Firestore.firestore().collection("Notification")
    
}
