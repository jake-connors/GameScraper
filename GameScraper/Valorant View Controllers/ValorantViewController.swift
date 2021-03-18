import UIKit

class ValorantViewController: UIViewController {
    
    @IBOutlet weak var nameTXT: UITextField!
    @IBOutlet var valorantTrackerGGButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: Notification.Name("text"), object: nil)
    }
    
    @objc func didGetNotification(_ notification: Notification) {
        let text = notification.object as! String?
        ValorantTrackerGGViewController.GlobalVariable.playerName = text!
    }
    
    @IBAction func didTapTrackerGGButton() {
        guard let vc = storyboard?.instantiateViewController(identifier: "valorant_tracker_gg_vc") as? ValorantTrackerGGViewController else {
            return
        }
        nameTXT.text = nameTXT.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        NotificationCenter.default.post(name: Notification.Name("text"), object: nameTXT.text)
        navigationController?.pushViewController(vc, animated: true)
    }

}
