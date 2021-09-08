

import UIKit
import Firebase
import NVActivityIndicatorView


class ViewController: UIViewController {
    
    //Mark: Properties
    private var user:User?
    private var IndicatorView:NVActivityIndicatorView!
    
    
    
    //Mark LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Mark:NVActivityIndicatorView
        navigationController?.isNavigationBarHidden = false
        IndicatorView = NVActivityIndicatorView(frame: CGRect(x: view.frame.width / 2,
                                                              y: view.frame.height / 2,
                                                              width: 100,
                                                              height: 100),
                                                type: NVActivityIndicatorType.ballSpinFadeLoader,
                                                color: Utility.AppColor.OriginalBlue,
                                                padding: 0)
       
        view.addSubview(IndicatorView)
        IndicatorView.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width:100,height: 100)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            performSegue(withIdentifier: Utility.Segue.gotoRegister, sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Mark:NVActivityIndicatorView
        navigationController?.isNavigationBarHidden = false
    }
    
    //Mark: IBAction
    @IBAction func gotoUser(_ sender: Any) {
        IndicatorView.startAnimating()
        let uid = Auth.getUserId()
        Firestore.getUserData(uid: uid) { user in
            self.IndicatorView.stopAnimating()
            guard let user = user else { return }
            self.user = user
            self.performSegue(withIdentifier: "gotoUser", sender: nil)
            print("sdss")
    }
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoUser" {
            let vc = segue.destination as! UserViewController
            vc.user = self.user
        }
    }
    

}



