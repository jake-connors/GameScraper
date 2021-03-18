import UIKit

class ApexViewController: UIViewController {
    

    @IBOutlet weak var pcRadio: UIButton!
    @IBOutlet weak var xboxRadio: UIButton!
    @IBOutlet weak var psRadio: UIButton!
    
    
    @IBOutlet var apextrackerggButton: UIButton!
    @IBOutlet weak var nameTXT: UITextField!
    
    struct GlobalPlatform {
        static var userPlatform : String = "pc"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: Notification.Name("text"), object: nil)
    }
    
    
    @IBAction func selectedPC(_ sender: UIButton) {
        GlobalPlatform.userPlatform = "pc"
        if sender.isSelected {
            sender.isSelected = true
            xboxRadio.isSelected = false
            psRadio.isSelected = false
            
        } else {
            sender.isSelected = true
            xboxRadio.isSelected = false
            psRadio.isSelected = false
        }
    }
    
    @IBAction func selectedXbox(_ sender: UIButton) {
        GlobalPlatform.userPlatform = "xbl"
        if sender.isSelected {
            sender.isSelected = true
            pcRadio.isSelected = false
            psRadio.isSelected = false
            
        } else {
            sender.isSelected = true
            pcRadio.isSelected = false
            psRadio.isSelected = false
        }
    }
    
    @IBAction func selectedPS(_ sender: UIButton) {
        GlobalPlatform.userPlatform = "psn"
        if sender.isSelected {
            sender.isSelected = true
            pcRadio.isSelected = false
            xboxRadio.isSelected = false
        } else {
            sender.isSelected = true
            pcRadio.isSelected = false
            xboxRadio.isSelected = false
        }
    }
    
    @objc func didGetNotification(_ notification: Notification) {
        let text = notification.object as! String?
        ApexTrackerGGViewController.GlobalVariable.playerName = text!
    }
    
    @IBAction func didTapApexGGButton() {
        guard let vc = storyboard?.instantiateViewController(identifier: "apex_tracker_gg_vc") as? ApexTrackerGGViewController else {
            return
        }
        nameTXT.text = nameTXT.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        NotificationCenter.default.post(name: Notification.Name("text"), object: nameTXT.text)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
