import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var owButton: UIButton!
    @IBOutlet var apexButton: UIButton!
    @IBOutlet var valorantButton: UIButton!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
    }
    
    @IBAction func didTapOwButton() {
        guard let vc = storyboard?.instantiateViewController(identifier: "ow_vc") as? OwViewController else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapApexButton() {
        guard let vc = storyboard?.instantiateViewController(identifier: "apex_vc") as? ApexViewController else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapValorantButton() {
        guard let vc = storyboard?.instantiateViewController(identifier: "valorant_vc") as? ValorantViewController else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension UIViewController {
    func setBackgroundColor() {
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [#colorLiteral(red: 0, green: 0.3930349743, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 0, green: 0.8822773973, blue: 1, alpha: 1).cgColor]
        layer.startPoint = CGPoint(x: 0,y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(layer, at: 0)
    }
}
