import UIKit
import SDWebImage
import Firebase
import NVActivityIndicatorView
import Charts
import FacebookCore
import SwiftUI

class GroupDetailViewController: UIViewController, GetGenderCount, GetBarChartDelegate {
    //Mark: Properties
    private let fetchData = FetchFirestoreData()
    var team:TeamModel?
    var friend:User?
    var teamPlayers = [User]()
    var friends = [User]()
    @IBOutlet private weak var friendImageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var teamNameLabel: UILabel! {
        didSet {
            teamNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        }
    }
    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var teamTagStackView: UIStackView! {
        didSet {
            teamTagStackView.distribution = .fillEqually
            teamTagStackView.axis = .horizontal
            teamTagStackView.spacing = 5
        }
    }
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var placeStackView: UIStackView!
    @IBOutlet private weak var timeStackView: UIStackView!
    @IBOutlet private weak var priceStackView: UIStackView!
    @IBOutlet private weak var pieView: PieChartView!
    @IBOutlet private weak var BarChartView: BarChartView!
    private let teamMemberCellId = Utility.CellId.MemberCellId
    private var genderArray = [Int]()
    private var genderValue = Utility.Data.genderArray
    private var IndicatorView:NVActivityIndicatorView!
    private var rawData: [Int] = []
    @IBOutlet weak var withdrawButton: UIButton! {
        didSet {
            withdrawButton.updateButton(radius: 15, backColor: Utility.AppColor.OriginalBlue, titleColor: .white, fontSize: 14)
        }
    }
    var flag = false
    @IBOutlet private weak var updateButton: UIButton! {
        didSet {
            updateButton.updateButton(radius: 15, backColor: .white
                                      , titleColor: Utility.AppColor.OriginalBlue, fontSize: 14)
        }
    }
    @IBOutlet private weak var chatButton: UIButton!
    @IBOutlet private weak var inviteButton: UIBarButtonItem!
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIndicator()
        updateBorder()
        setupDelegate()
        IndicatorView.startAnimating()
        setupData()
        setUpTeamStatus()
        setUpTeamPlayer()
        setupGraph()
        changeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavAccessory()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    //Mark: setupMethod
    private func setupData() {
        guard let teamId = team?.teamId else { return }
        Firestore.getTeamTagData(teamId: teamId) {[weak self] tags in
            guard let self = self else { return }
            if tags.count <= 1 {
                let button = UIButton(type: .system).cretaTagButton(text: "バド好き歓迎")
                let button2 = UIButton(type: .system).cretaTagButton(text: "仲良く")
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                button2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                self.teamTagStackView.addArrangedSubview(button)
                self.teamTagStackView.addArrangedSubview(button2)
            }
            for i in 0..<tags.count {
                let title = tags[i].tag
                let button = UIButton(type: .system).cretaTagButton(text: title)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                if i == 4 { return }
                self.teamTagStackView.addArrangedSubview(button)
            }
        }
    }
    
    private func setUpTeamPlayer() {
        print(#function)
        guard let teamId = team?.teamId else { return }
        Firestore.getTeamPlayer(teamId: teamId) { membersId in
            self.teamPlayers = []
            for i in 0..<membersId.count {
                let teamPlayerId = membersId[i]
                Firestore.getUserData(uid: teamPlayerId) { teamPlayer in
                    guard let teamPlayer = teamPlayer else { return }
                    self.teamPlayers.append(teamPlayer)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.fetchData.getGenderCount(teamPlayers: self.teamPlayers)
                self.fetchData.teamPlayerLevelCount(teamPlayers: self.teamPlayers)
                self.IndicatorView.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    
    private func setupDelegate() {
        fetchData.delegate = self
        fetchData.barDelegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupIndicator() {
        IndicatorView = self.setupIndicatorView()
        view.addSubview(IndicatorView)
        IndicatorView.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width:100,height: 100)
    }
    //Mark: setupBorder
    private func setupBorder(view:UIView) {
        let border = CALayer()
        border.frame = CGRect(x: view.frame.width - 1,
                              y: 15,
                              width: 5.0,
                              height: view.frame.height - 25)
        border.backgroundColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(border)
    }
    
    private func setUpTeamStatus() {
        print(#function)
        let nib = TeammemberCell.nib()
        collectionView.register(nib, forCellWithReuseIdentifier: teamMemberCellId)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        guard let urlString = team?.teamImageUrl else { return }
        let url = URL(string: urlString)
        friendImageView.sd_setImage(with: url, completed: nil)
        friendImageView.contentMode = .scaleAspectFill
        friendImageView.chageCircle()
        friendImageView.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
        friendImageView.layer.borderWidth = 2
        friendImageView.layer.masksToBounds = true
        teamNameLabel.text = team?.teamName
        timeLabel.text = team?.teamTime
        placeLabel.text = team?.teamPlace
        priceLabel.text = "\(team?.teamLevel ?? "")/月"
    }
    
    private func setupPieChart() {
        var entry = [ChartDataEntry]()
        for i in 0..<genderArray.count {
            entry.append(PieChartDataEntry(value: Double(genderArray[i]),label:genderValue[i], data: genderArray[i]))
        }
        let pieChartDataSet = PieChartDataSet(entries: entry,label: "男女比")
        pieChartDataSet.entryLabelFont = UIFont.boldSystemFont(ofSize: 12)
        pieChartDataSet.drawValuesEnabled = false
        pieView.centerText = "男女比"
        pieView.legend.textColor = .label
        pieChartDataSet.valueTextColor = .label
        pieView.legend.enabled = false
        pieView.data = PieChartData(dataSet:pieChartDataSet)
        let colors = [UIColor.blue,.red,Utility.AppColor.OriginalBlue]
        pieChartDataSet.colors = colors
    }
    
    private func setupGraph() {
        let entries = rawData.enumerated().map { BarChartDataEntry(x: Double($0.offset + 1), y: Double($0.element)) }
        BarChartView.scaleXEnabled = false
        BarChartView.scaleYEnabled = false
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.drawValuesEnabled = false
        let data = BarChartData(dataSet: dataSet)
        BarChartView.data = data
        BarChartView.rightAxis.enabled = false
        BarChartView.xAxis.labelPosition = .bottom
        BarChartView.xAxis.labelCount = rawData.count
        BarChartView.leftAxis.labelCount = 10
        BarChartView.xAxis.labelTextColor = .darkGray
        BarChartView.xAxis.drawGridLinesEnabled = false
        BarChartView.xAxis.drawAxisLineEnabled = false
        BarChartView.leftAxis.axisMinimum = 0
        BarChartView.leftAxis.axisMaximum = 10
        BarChartView.legend.enabled = false
        dataSet.colors = [.lightGray]
    }
    //Mark: helplerMethod
    private func updateBorder() {
//        setupBorder(view: placeStackView)
//        setupBorder(view: timeStackView)
    }
    
    private func changeUI() {
        withdrawButton.isHidden = flag
        chatButton.isHidden = flag
        updateButton.isHidden = flag
        if flag == true {
            navigationItem.setRightBarButton(nil, animated: true)
        }
        friendImageView.isUserInteractionEnabled = !flag
    }
    //Mark:Protocol
    func getGenderCount(count: [Int]) {
        self.genderArray = count
        self.setupPieChart()
    }
    
    func getBarData(count: [Int]) {
        self.rawData = count
        self.setupGraph()
    }
    //Mark IBAction
    @IBAction private func gotoInvite(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: Utility.Storyboard.inviteVC) as! InviteViewController
        vc.friends = self.friends
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func updateTeamInfo(_ sender: Any) {
        print(#function)
        guard let team = self.team else { return }
        let vc = UpdateViewController(team: team)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction private func gotoGroup(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: Utility.Storyboard.GroupChatVC) as! GroupChatViewController
        vc.team = self.team
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func go(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: Utility.Storyboard.GroupChatVC) as! GroupChatViewController
        vc.team = self.team
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func withdraw(_ sender: Any) {
        print(#function)
        guard let teamId = team?.teamId else { return }
        Firestore.deleteSubCollectionData(collecionName: "Users", documentId: Auth.getUserId(), subCollectionName: "OwnTeam", subId: teamId)
        Firestore.deleteSubCollectionData(collecionName: "Teams", documentId: teamId, subCollectionName: "TeamPlayer", subId: Auth.getUserId())
        navigationController?.popViewController(animated: true
        )
    }
    //Mark prepareMethod
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Utility.Segue.gotoInvite {
            let vc = segue.destination as! InviteViewController
            vc.friends = self.friends
            vc.team = self.team
        }
    }
}
//Mark detailSearchDelegate
extension GroupDetailViewController:backDelegate {
    
    func updateTeamData() {
        guard let id = team?.teamId else { return }
        Firestore.getTeamData(teamId: id) { team in
            self.team = team
            self.placeLabel.text = team.teamPlace
            self.timeLabel.text = team.teamTime
            self.priceLabel.text = team.teamLevel
            let urlString = team.teamImageUrl
            let url = URL(string: urlString)
            self.friendImageView.sd_setImage(with: url)
        }
    }
}
//Mark: CollectionViewDelegate,DataSource
extension GroupDetailViewController:UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamPlayers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: teamMemberCellId, for: indexPath) as! TeammemberCell
        let memberName = teamPlayers[indexPath.row].name
        let urlString = teamPlayers[indexPath.row].profileImageUrl
        cell.configure(name: memberName, urlString: urlString)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: Utility.Storyboard.UserDetailVC) as! UserDetailViewController
        vc.user = teamPlayers[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

protocol backDelegate:AnyObject {
    func updateTeamData()
}
class UpdateViewController:UIViewController {
    //Mark properties
    var team:TeamModel?
    private let placeTextField = ProfileTextField(placeholder: "")
    private let timeTextField = ProfileTextField(placeholder: "")
    private let moneyTextField = ProfileTextField(placeholder: "")
    weak var delegate:backDelegate?
    private let iv:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Utility.ImageName.noImages)
        iv.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
        iv.layer.borderWidth = 2
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(handleImagePicker))
        iv.addGestureRecognizer(touchGesture)
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 75
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private let button:UIButton = {
        let button = UIButton()
        button.updateButton(radius: 15, backColor: Utility.AppColor.OriginalBlue, titleColor: .white, fontSize: 16)
        button.setTitle("保存", for: .normal)
        return button
    }()
    private let imagePicker = UIImagePickerController()
    //Mark lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupteamInfo()
        imagePicker.delegate = self
    }
    //Mark setupMethod
    private func setupLayout() {
        view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [placeTextField,timeTextField,moneyTextField])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        view.addSubview(iv)
        view.addSubview(button)
        
        iv.anchor(top:view.safeAreaLayoutGuide.topAnchor,paddingTop: 100,centerX: view.centerXAnchor,width:150, height:150)
        stackView.anchor(top:iv.bottomAnchor,left:view.leftAnchor, right:view.rightAnchor,paddingTop:20, paddingRight:30,paddingLeft:30,height: 170)
        button.anchor(top:stackView.bottomAnchor,left:view.leftAnchor,right:view.rightAnchor,paddingTop: 20,paddingRight: 30,paddingLeft: 30,height: 50)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
    }
    
    private func setupteamInfo() {
        placeTextField.text = team?.teamPlace
        timeTextField.text = team?.teamTime
        moneyTextField.text = team?.teamLevel
        guard let urlString = team?.teamImageUrl else { return }
        let url = URL(string: urlString)
        iv.sd_setImage(with: url, completed: nil)
    }
    //Mark initalize
    init(team:TeamModel) {
        super.init(nibName: nil, bundle: nil)
        self.team = team
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //Mark selector
    @objc private func handleSave() {
        guard let place = placeTextField.text else { return }
        guard let time = timeTextField.text else { return }
        guard let money = moneyTextField.text else { return }
        self.team?.teamPlace = place
        self.team?.teamTime = time
        self.team?.teamLevel = money
        guard let image = iv.image else { return }
        Storage.addTeamImage(image: image) { [weak self] urlString in
            guard let self = self else { return }
            self.team?.teamImageUrl = urlString
            guard let team = self.team else { return }
            Firestore.updateTeamInfo(team: team)
            self.delegate?.updateTeamData()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func handleImagePicker() {
        print(#function)
        present(imagePicker, animated: true, completion: nil)
    }
}
//Mark: UIImagePickerDelegate
extension UpdateViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        print(#function)
        iv.image = image
        dismiss(animated: true, completion: nil)
    }
}
