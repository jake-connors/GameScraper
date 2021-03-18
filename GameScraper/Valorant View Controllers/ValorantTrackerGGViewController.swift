import UIKit
import HTMLKit
import WebKit

class ValorantTrackerGGViewController: UIViewController {
    
    @IBOutlet var headLabel : UILabel!
    @IBOutlet var playerLabel : UILabel!
    
    @IBOutlet var rankLabel: UILabel!
    @IBOutlet var winsLabel: UILabel!
    @IBOutlet var winRateLabel: UILabel!
    @IBOutlet var killsLabel: UILabel!
    @IBOutlet var assistsLabel: UILabel!
    @IBOutlet var deathsLabel: UILabel!
    @IBOutlet var kadLabel: UILabel!
    @IBOutlet var headshotsLabel: UILabel!
    @IBOutlet var mostKillsLabel: UILabel!
    @IBOutlet var killsPerRoundLabel: UILabel!
    @IBOutlet var scorePerRoundLabel: UILabel!
    @IBOutlet var damagePerRoundLabel: UILabel!
    @IBOutlet var firstBloodsLabel: UILabel!
    @IBOutlet var clutchesLabel: UILabel!
    @IBOutlet var flawlessLabel: UILabel!
    
    private let webView: WKWebView = {
        let prefs = WKPreferences()
        prefs.javaScriptEnabled = true
        let config = WKWebViewConfiguration()
        config.preferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    struct GlobalVariable{
        static var playerName = String()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        print("Welcome \(GlobalVariable.playerName)")
        
        webView.navigationDelegate = self
        var newName = GlobalVariable.playerName.replacingOccurrences(of: "\\s", with: "", options: .regularExpression, range: nil)
        newName = GlobalVariable.playerName.replacingOccurrences(of: "#", with: "%23", options: .regularExpression, range: nil)
        let urlString = "https://tracker.gg/valorant/profile/riot/\(newName)/overview"
        playerLabel.text = GlobalVariable.playerName.replacingOccurrences(of: "\\s", with: "", options: .regularExpression, range: nil)
        guard let url = URL(string: urlString) else {
            return
        }
        webView.load(URLRequest(url:url))
    }

}


extension ValorantTrackerGGViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //parsing
        parseValorantTrackerGGPage()
    }
    
    
    func parseValorantTrackerGGPage() {
        webView.evaluateJavaScript("document.body.innerHTML") { result, error in
            guard let html = result as? String, error == nil else {
                print("Failed to get html string")
                return
            }
            let document = HTMLDocument(string: html)
            print("created html doc")
                        

            let statHeaderValues: [String] = document.querySelectorAll(".valorant-highlighted-stat__value").compactMap({ element in
                let stat = element.textContent
                return stat
            })
            
            print(statHeaderValues)
            
            
            let statValues: [String] = document.querySelectorAll(".value").compactMap({ element in
                let stat = element.textContent
                return stat
            })
            print(statValues)
            
            var i = 0
            for stat in statHeaderValues {
                if i == 0 {
                    self.rankLabel.isHidden = false
                    self.rankLabel.text = stat
                } else if i == 1 {
                    self.kadLabel.isHidden = false
                    self.kadLabel.text = stat
                }
                i = i + 1
            }
            
            if statValues.isEmpty {
                self.headLabel.text = "Error for:"
            }
            
            i = 0
            for stat in statValues {
                if i == 3 {
                    self.damagePerRoundLabel.isHidden = false
                    self.damagePerRoundLabel.text = stat
                } else if i == 6 {
                    self.winRateLabel.isHidden = false
                    self.winRateLabel.text = stat
                } else if i == 7 {
                    self.winsLabel.isHidden = false
                    self.winsLabel.text = stat
                } else if i == 8 {
                    self.killsLabel.isHidden = false
                    self.killsLabel.text = stat
                } else if i == 9 {
                    self.headshotsLabel.isHidden = false
                    self.headshotsLabel.text = stat
                } else if i == 10 {
                    self.deathsLabel.isHidden = false
                    self.deathsLabel.text = stat
                } else if i == 11 {
                    self.assistsLabel.isHidden = false
                    self.assistsLabel.text = stat
                } else if i == 12 {
                    self.scorePerRoundLabel.isHidden = false
                    self.scorePerRoundLabel.text = stat
                } else if i == 13 {
                    self.killsPerRoundLabel.isHidden = false
                    self.killsPerRoundLabel.text = stat
                } else if i == 14 {
                    self.firstBloodsLabel.isHidden = false
                    self.firstBloodsLabel.text = stat
                } else if i == 16 {
                    self.clutchesLabel.isHidden = false
                    self.clutchesLabel.text = stat
                } else if i == 17 {
                    self.flawlessLabel.isHidden = false
                    self.flawlessLabel.text = stat
                } else if i == 18 {
                    self.mostKillsLabel.isHidden = false
                    self.mostKillsLabel.text = stat
                }
                i = i + 1
            }
            
        }
    }
}
