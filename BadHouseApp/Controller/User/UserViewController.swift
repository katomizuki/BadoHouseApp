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
    private let cellId = "cellId"
    private let diposeBag = DisposeBag()
    private var hasChangedImage = false
    private var name = ""
    private var email = ""
    var level:String = "" {
        didSet {
        orangeView.reloadData()
    }
}
    var gender = "" {
        didSet {
            orangeView.reloadData()
        }
    }
    var place = "" {
        didSet {
            orangeView.reloadData()
        }
    }
    var age = "" {
        didSet {
            orangeView.reloadData()
        }
    }
    var badmintonTime = "" {
        didSet {
            orangeView.reloadData()
        }
    }
    
    private var introduction = ""
    private let saveButton = UIButton(type: .system).createProfileTopButton(title: "もどる")
    private let logoutButton = UIButton(type: .system).createProfileTopButton(title: "保存する")
    private let profileImageView = ProfileImageView()
    private let nameLabel = ProfileLabel()
    private let profileEditButton = UIButton(type: .system).createProfileEditButton()
    private let dismissButton = UIButton(type: .system).createAuthButton(text: "もどる")
    lazy var InfoCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        return collectionView
    }()
    private let orangeView = UITableView()
    var cellTitleArray = ["居住地","性別","年代","バドミントン歴","レベル"]
    @IBOutlet weak var scrollView: UIView!
    
    
    //Mark: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupLayout()
        setupBinding()
        orangeView.delegate = self
        orangeView.dataSource = self
        orangeView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        orangeView.separatorColor = Utility.AppColor.OriginalBlue
    }

    //Mark: setupMethod
    private func setupLayout() {
       
        //Mark: UpdateUI
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 90
        profileImageView.layer.masksToBounds = true
        InfoCollectionView.isScrollEnabled = false
        nameLabel.textColor = Utility.AppColor.OriginalBlue
        
        //Mark addSubView
        scrollView.addSubview(saveButton)
        scrollView.addSubview(logoutButton)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(profileEditButton)
        scrollView.addSubview(InfoCollectionView)
        scrollView.addSubview(orangeView)

        //Mark: Anchor
        saveButton.anchor(top: scrollView.topAnchor, left: view.leftAnchor, paddingTop: 50, paddingLeft:15,width: 80)
        logoutButton.anchor(top: scrollView.topAnchor, right: view.rightAnchor, paddingTop: 50, paddingRight: 15,width: 80)
        profileImageView.anchor(top: scrollView.topAnchor, paddingTop: 60, centerX: view.centerXAnchor, width: 180, height: 180)
        nameLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 10, centerX: view.centerXAnchor)
        profileEditButton.anchor(top: profileImageView.topAnchor, right: profileImageView.rightAnchor,  width: 70, height: 60)
        orangeView.anchor(top:nameLabel.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 5,paddingRight: 20, paddingLeft: 20,height: 220)
        InfoCollectionView.anchor(top: orangeView.bottomAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10,paddingRight: 20, paddingLeft: 20)
       
        
        //Mark: selector
        saveButton.addTarget(self, action: #selector(logout), for: UIControl.Event.touchUpInside)
        
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
    
    //Mark: Logout
    @objc func logout() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupBinding() {
        print(#function)
        logoutButton.rx.tap
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
//                    //SaveAction
                    Storage.addProfileImageToStorage(image: image, dic: dic) {
                        print("Image Save Success")
                        self.hasChangedImage = false
                    }
                } else {
                    print("🌀")
                    Firestore.updateUserInfo(dic: dic)
                }
                let alertType = CDAlertViewType.success
                let alert = CDAlertView(title: "ユーザー情報を保存しました", message: "", type: alertType)
                let alertAction = CDAlertViewAction(title: "OK", font: UIFont.boldSystemFont(ofSize: 14), textColor: UIColor.blue, backgroundColor: .white)
                
                alert.add(action: alertAction)
                alert.hideAnimations = { (center, transform, alpha) in
                    transform = .identity
                    alpha = 0
                }
                alert.show() { (alert) in
                    print("completed")
                }
            }.disposed(by:diposeBag)
        
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
        print("🎨")
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

extension UserViewController:UITableViewDelegate,UITableViewDataSource,UIPopoverControllerDelegate ,UIAdaptivePresentationControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitleArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cellId")
        cell.textLabel?.text = cellTitleArray[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        cell.accessoryType = .disclosureIndicator
        let title = cellTitleArray[indexPath.row]
        cell.detailTextLabel?.text = ""
        if title == "レベル" {
            cell.detailTextLabel?.text = level
        } else if title == "性別" {
            cell.detailTextLabel?.text = gender
        } else if title == "バドミントン歴" {
            cell.detailTextLabel?.text = badmintonTime
        } else if title == "居住地" {
            cell.detailTextLabel?.text = place
        } else if title == "年代" {
            cell.detailTextLabel?.text = age
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cellTitleArray[indexPath.row] == "レベル" {
            //present
           performSegue(withIdentifier: "gotoLevel", sender: nil)
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

        orangeView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoLevel" {
            let vc = segue.destination as! LevelViewController
            vc.selectedLevel = self.level
        }
    }
}



