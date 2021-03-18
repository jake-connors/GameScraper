import UIKit

class OwViewController: UIViewController {
    
    @IBOutlet weak var nameTXT: UITextField!
    @IBOutlet var owtrackerdotcomButton: UIButton!
    @IBOutlet var overbuffdotcomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: Notification.Name("text"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: Notification.Name("text2"), object: nil)
    }
    
    @objc func didGetNotification(_ notification: Notification) {
        let text = notification.object as! String?
        OwTrackerViewController.GlobalVariable.playerName = text!
        let text2 = notification.object as! String?
        OverbuffViewController.GlobalVariable.playerName = text2!
    }
    
    
    @IBAction func didTapFirstButton() {
        guard let vc = storyboard?.instantiateViewController(identifier: "ow_tracker_tab_bar_vc") as? OwTrackerTabBarViewController else {
            return
        }
        nameTXT.text = nameTXT.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        NotificationCenter.default.post(name: Notification.Name("text"), object: nameTXT.text)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapSecondButton() {
        guard let vc = storyboard?.instantiateViewController(identifier: "overbuff_tab_bar_vc") as? OverbuffTabBarViewController else {
            return
        }
        nameTXT.text = nameTXT.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        NotificationCenter.default.post(name: Notification.Name("text"), object: nameTXT.text)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

