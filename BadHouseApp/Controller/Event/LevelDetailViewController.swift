import UIKit

class LevelDetailViewController: UIViewController {

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var textView: UITextView!
    private var selectedLevel = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.addTarget(self, action: #selector(changeLevel(sender:)), for: .valueChanged)
        levelLabel.text = selectedLevel
        let end = String(selectedLevel.suffix(1))
        setupSlider(level:end)
       
        backButton.layer.cornerRadius = 14
        backButton.layer.masksToBounds = true
        backButton.backgroundColor = Utility.AppColor.OriginalBlue
        backButton.setTitleColor(.white, for: UIControl.State.normal)
        backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
   
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @objc func changeLevel(sender:UISlider) {
        let level = Double(sender.value)
        //分割して条件分岐する
        if case 0..<0.1 = level {
            levelLabel.text = "レベル1"
            textView.text = "まだバドミントンを初めて半年以内。\n基本的なショットや素振りなどの練習をしている"
        }
        if case 0.1..<0.2 = level {
            levelLabel.text = "レベル2"
            textView.text = "バドミントンを初めて半年から1年,\nほとんどのショットを簡単にできる。\n[小学校]スクールに通っていた"
        }
        if case 0.2..<0.3 = level {
            levelLabel.text = "レベル3"
            textView.text =
                "バドミントンを初めて1年以上。\n簡単な試合ができる。\n[中学校,高校]部活動に入部していた時期がある。\n[大学]サークルの練習で稀に練習している（月に一度等）\n[社会人]サークルで練習している"
        }
        if case 0.3..<0.4 = level {
            levelLabel.text = "レベル4"
            textView.text =
                "シングルス、ダブルス共に試合ができる。\n[中学校,高校]いずれかで3年間在籍していた。\n[大学]サークルの練習で定期的に練習している（2週に1度以上）\n[社会人]サークルで練習しており、2年以上は在籍している"
        }
        if case 0.4..<0.5 = level {
            levelLabel.text = "レベル5"
            textView.text =
                "試合を連続して行うことができる。\n[中学校,高校]6年間在籍していた　\n[大学]サークルの練習で定期的に練習しており、バドミントン歴4年以上\n[社会人]サークルで練習しており,オープン大会2回戦~3回戦"
            
        }
        if case 0.5..<0.6 = level {
            levelLabel.text = "レベル6"
            textView.text =
                "[中学校,高校]地区大会入賞、県大会出場等の結果を残している。　\n[大学]サークルの練習で定期的に練習しており、バドミントン歴6年以上\n[社会人]サークルで練習しており,オープン大会中級レベルで勝利したことがある"
        }
        if case 0.6..<0.7 = level {
            levelLabel.text = "レベル7"
            textView.text = "[中学校,高校]地区大会上位、県大会入賞等の結果を残している。　\n[大学]関東リーグ4部〜5部,体育会に4年間所属していた。\n[社会人]サークルで練習しており,オープン大会上級レベルで勝利したことがある"
        }
        if case 0.7..<0.8 = level {
            levelLabel.text = "レベル8"
            textView.text = "[中学校,高校]県大会上位,関東大会入賞　\n[大学]関東リーグ3~4部\n[社会人]サークルで練習しており,オープン大会上級レベルで入賞等を複数回したことがある"
        }
        if case 0.8..<0.9 = level {
            levelLabel.text = "レベル9"
            textView.text = "[中学校,高校]全国大会出場　\n[大学]関東リーグ2~3部。\n[社会人]全日本社会人等の大きい大会で優勝等の結果を複数回したことがある"
        }
        if case 0.9..<1.0 = level {
            levelLabel.text = "レベル10"
            textView.text = "全国大会入賞、上位、関東リーグ1部~2部。\n実業団所属しているなどのバドミントン界の超サイヤ人"
        }
    }
    

    private func setupSlider(level:String) {
        print(level)
        switch level {
        case "1":
            slider.value = 0.1
            textView.text = "まだバドミントンを初めて半年以内。\n基本的なショットや素振りなどの練習をしている"
        case "2":
            slider.value = 0.2
            textView.text = "バドミントンを初めて半年から1年,\nほとんどのショットを簡単にできる。\n[小学校]スクールに通っていた"
        case "3":
            slider.value = 0.3
            textView.text =
                "バドミントンを初めて1年以上。\n簡単な試合ができる。\n[中学校,高校]部活動に入部していた時期がある。\n[大学]サークルの練習で稀に練習している（月に1度以下）\n[社会人]サークルで練習している"

        case "4":
            slider.value = 0.4
            textView.text =
                "シングルス、ダブルス共に試合ができる。\n[中学校,高校]いずれかで3年間在籍していた。\n[大学]サークルの練習で定期的に練習している（月に1度以上）\n[社会人]サークルで練習しており、2年以上は在籍している"
        case "5":
            slider.value = 0.5
            textView.text =
                "試合を連続して行うことができる。\n[中学校,高校]6年間在籍していた　\n[大学]サークルの練習で定期的に練習しており、バドミントン歴4年以上\n[社会人]サークルで練習しており,オープン大会2回戦~3回戦"
        case "6":
            slider.value = 0.6
            textView.text =
                "[中学校,高校]地区大会入賞、県大会出場等の結果を残している。\n[大学]サークルの練習で定期的に練習しており、バドミントン歴6年以上\n[社会人]サークルで練習しており,オープン大会中級レベルで勝利したことがある"
        case "7":
            slider.value = 0.7
            textView.text = "[中学校,高校]地区大会上位、県大会入賞等の結果を残している。\n[大学]関東リーグ4部〜5部,体育会に4年間所属していた。\n[社会人]サークルで練習しており,オープン大会上級レベルで勝利したことがある"
        case "8":
            slider.value = 0.8
            textView.text = "[中学校,高校]県大会上位,関東大会入賞\n[大学]関東リーグ3~4部\n[社会人]サークルで練習しており,オープン大会上級レベルで入賞等を複数回したことがある"
        case "9":
            slider.value = 0.9
            textView.text = "[中学校,高校]全国大会出場　\n[大学]関東リーグ2~3部。\n[社会人]全日本社会人等の大きい大会で優勝等の結果を複数回したことがある"
        default:
            slider.value = 1.0
            textView.text = "全国大会入賞、上位、関東リーグ1部~2部。\n実業団所属しているなどのバドミントン界の超サイヤ人"
        }
    }


}
