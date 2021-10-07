import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore
import FirebaseStorage
import SDWebImage
import FirebaseAuth
import CDAlertView

class UserViewController: UIViewController, UIPopoverPresentationControllerDelegate{
    
    //Mark: properties
    var user:User?
    private let cellId = Utility.CellId.userCellId
    private let diposeBag = DisposeBag()
    private var hasChangedImage = false
    private var name = ""
    private var email = ""
    private let logoutButton:UIButton = {
        let button = UIButton(type: .system).createProfileTopButton(title: "ログアウト")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14,weight: .bold)
        return button
    }()
    
    var level:String = "" {
        didSet {
            userTableView.reloadData()
        }
    }
    var gender = "" {
        didSet {
            userTableView.reloadData()
        }
    }
    var place = "" {
        didSet {
            userTableView.reloadData()
        }
    }
    var age = "" {
        didSet {
            userTableView.reloadData()
        }
    }
    var badmintonTime = "" {
        didSet {
            userTableView.reloadData()
        }
    }
    
    private var introduction = ""
    private let backButton = UIButton(type: .system).createProfileTopButton(title: "もどる")
    private let saveButton = UIButton(type: .system).createProfileTopButton(title: "保存する")
    private let profileImageView:UIImageView = {
        let iv = ProfileImageView()
        iv.contentMode = .scaleAspectFill
        iv.toCorner(num: 90)
        iv.tintColor = Utility.AppColor.OriginalBlue
        return iv
    }()
    private let nameLabel:UILabel = {
        let label = ProfileLabel()
        label.textColor = Utility.AppColor.OriginalBlue
        return label
    }()
    private let profileEditButton = UIButton(type: .system).createProfileEditButton()
    private let dismissButton = UIButton(type: .system).createAuthButton(text: "もどる")
    lazy var InfoCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        return collectionView
    }()
    private let userTableView = UITableView()
    var cellTitleArray = Utility.Data.userSection
    @IBOutlet private weak var scrollView: UIView!
    
    //Mark: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupLayout()
        setupBinding()
        setupUserTableView()
    }
    
    //Mark: setupMethod
    private func setupUserTableView() {
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        userTableView.separatorColor = Utility.AppColor.OriginalBlue
        userTableView.backgroundColor = UIColor(named: Utility.AppColor.darkColor)
    }
    
    private func setupLayout() {
        setupAddSubView()
        setupAnchor()
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        updateUI()
    }
    
    private func updateUI() {
        //Mark: textFieldUPdate
        nameLabel.text = user?.name
        if let url = URL(string: user?.profileImageUrl ?? "") {
            profileImageView.sd_setImage(with: url, completed: nil)
        }
        level = user?.level ?? "レベル1"
        gender = user?.gender ?? "未設定"
        badmintonTime = user?.badmintonTime ?? "未設定"
        place = user?.place ?? "未設定"
        age = user?.age ?? "未設定"
    }
    
    private func setupAddSubView() {
        //Mark addSubView
        scrollView.addSubview(backButton)
        scrollView.addSubview(saveButton)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(profileEditButton)
        scrollView.addSubview(InfoCollectionView)
        scrollView.addSubview(userTableView)
        scrollView.addSubview(logoutButton)
    }
    private func setupAnchor() {
        //Mark: Anchor
        backButton.anchor(top: scrollView.topAnchor, left: view.leftAnchor, paddingTop: 50, paddingLeft:15,width: 80)
        saveButton.anchor(top: scrollView.topAnchor, right: view.rightAnchor, paddingTop: 50, paddingRight: 15,width: 80)
        profileImageView.anchor(top: scrollView.topAnchor, paddingTop: 60, centerX: view.centerXAnchor, width: 180, height: 180)
        nameLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 10, centerX: view.centerXAnchor)
        profileEditButton.anchor(top: profileImageView.topAnchor, right: profileImageView.rightAnchor,  width: 70, height: 60)
        userTableView.anchor(top:nameLabel.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 5,paddingRight: 20, paddingLeft: 20,height: 220)
        InfoCollectionView.anchor(top: userTableView.bottomAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10,paddingRight: 20, paddingLeft: 20)
        logoutButton.anchor(top:saveButton.bottomAnchor,right: view.rightAnchor,paddingTop: 40,paddingRight: 15,width:80)
    }
    private func setupBinding() {
        print(#function)
        saveButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                let dic = [
                    "name":self.name,
                    "email":self.email,
                    "level":self.level,
                    "introduction":self.introduction,
                    "uid":Auth.getUserId(),
                    "gender":self.gender,
                    "place":self.place,
                    "badmintonTime":self.badmintonTime,
                    "age":self.age
                ]
                if self.hasChangedImage {
                    guard let image = self.profileImageView.image else { return }
                    Storage.addProfileImageToStorage(image: image, dic: dic) {
                        print("Image Save Success")
                        self.hasChangedImage = false
                    }
                } else {
                    Firestore.updateUserInfo(dic: dic)
                }
                self.setupCDAlert(title: "ユーザー情報を保存しました", message: "", action: "OK", alertType: .success)
            }.disposed(by:diposeBag)
    }
    
    //Mark: Selector
    @objc private func back() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleLogout() {
        print(#function)
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        }  catch {
            print(error)
        }
    }
}

//Mark: CollectionDelegate, Datasource
extension UserViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InfoCollectionViewCell
        cell.user = self.user
        bindingsCell(cell: cell)
        return cell
    }
    
    //Mark Binding
    private func bindingsCell(cell:InfoCollectionViewCell) {
        cell.nameTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.name = text ?? ""
            }
            .disposed(by: diposeBag)
        
        
        cell.emailTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.email = text ?? ""
            }
            .disposed(by: diposeBag)
        
        cell.introductionTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.introduction = text ?? ""
            }
            .disposed(by: diposeBag)
        
        profileEditButton.rx.tap
            .asDriver()
            .drive {  _ in
                let pickerView = UIImagePickerController()
                pickerView.delegate = self
                self.present(pickerView, animated: true, completion: nil)
            }
            .disposed(by: diposeBag)
    }
}


//Mark UIPickerDelegate,UINavigationControllerDelegate
extension UserViewController:UIPickerViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image.withRenderingMode(.alwaysOriginal)
        }
        hasChangedImage = true
        self.dismiss(animated: true, completion: nil)
    }
    
}

//Mark tableViewDelegate,popoverDelegate
extension UserViewController:UITableViewDelegate,UITableViewDataSource,UIPopoverControllerDelegate ,UIAdaptivePresentationControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cellId")
        cell.textLabel?.text = cellTitleArray[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(named: Utility.AppColor.darkColor)
        cell.accessoryType = .disclosureIndicator
        let title = cellTitleArray[indexPath.row]
        cell.detailTextLabel?.text = ""
        
        switch title {
        case UserInfo.level.rawValue:
            cell.detailTextLabel?.text = level
        case UserInfo.gender.rawValue:
            cell.detailTextLabel?.text = gender
        case UserInfo.badmintonTime.rawValue:
            cell.detailTextLabel?.text = badmintonTime
        case UserInfo.place.rawValue:
            cell.detailTextLabel?.text = place
        case UserInfo.age.rawValue:
            cell.detailTextLabel?.text = age
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cellTitleArray[indexPath.row] == UserInfo.level.rawValue {
            performSegue(withIdentifier: Utility.Segue.gotoLevel, sender: nil)
        }
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        let viewController = PopViewController() //popoverで表示するViewController
        viewController.modalPresentationStyle = .popover
        viewController.preferredContentSize = CGSize(width: 200, height: 150)
        
        let presentationController = viewController.popoverPresentationController
        presentationController?.delegate = self
        presentationController?.permittedArrowDirections = .up
        presentationController?.sourceView = cell
        presentationController?.sourceRect = cell.bounds
        viewController.keyword = cellTitleArray[indexPath.row]
        viewController.presentationController?.delegate = self
        present(viewController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        
        userTableView.reloadData()
    }
    //Mark segueMethod
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Utility.Segue.gotoLevel {
            let vc = segue.destination as! LevelViewController
            vc.selectedLevel = self.level
        }
    }
}


//Mark Enum UserInfo
enum UserInfo:String {
    case level = "レベル"
    case gender = "性別"
    case badmintonTime = "バドミントン歴"
    case place = "居住地"
    case age = "年代"
}
