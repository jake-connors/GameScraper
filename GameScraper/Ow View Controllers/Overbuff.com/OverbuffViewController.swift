import UIKit
import HTMLKit
import WebKit

class OverbuffViewController: UIViewController {
    
    @IBOutlet var headLabel: UILabel!
    @IBOutlet var playerLabel: UILabel!
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var skillRankLabel: UILabel!
    @IBOutlet var skillRankLabelPerm: UILabel!
    @IBOutlet var onFireLabel: UILabel!
    @IBOutlet var onFireLabelPerm: UILabel!
    @IBOutlet var recordLabel: UILabel!
    @IBOutlet var recordLabelPerm: UILabel!
    @IBOutlet var winRateLabel: UILabel!
    @IBOutlet var winRateLabelPerm: UILabel!
    
    @IBOutlet var tank1Label: UILabel!
    @IBOutlet var tank1LabelPerm: UILabel!
    @IBOutlet var damageLabel: UILabel!
    @IBOutlet var damageLabelPerm: UILabel!
    @IBOutlet var support1Label: UILabel!
    @IBOutlet var support1LabelPerm: UILabel!
    @IBOutlet var tank2Label: UILabel!
    @IBOutlet var support2Label: UILabel!
    @IBOutlet var offenseLabel: UILabel!
    @IBOutlet var defenseLabel: UILabel!
    
    @IBOutlet var tank3Label: UILabel!
    @IBOutlet var support3Label: UILabel!
    @IBOutlet var offense2Label: UILabel!
    @IBOutlet var defense2Label: UILabel!
    
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
        static var link = String()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        self.headLabel.text = "Loading..."
        webView.navigationDelegate = self
        var newName = GlobalVariable.playerName.replacingOccurrences(of: "#", with: "-", options: .regularExpression, range: nil)
        newName = newName.replacingOccurrences(of: "\\s", with: "", options: .regularExpression, range: nil)
        GlobalVariable.link = newName
        let urlString = "https://www.overbuff.com/players/pc/\(newName)?mode=competitive"
        playerLabel.text = GlobalVariable.playerName.replacingOccurrences(of: "\\s", with: "", options: .regularExpression, range: nil)
        guard let url = URL(string: urlString) else {
            return
        }
        webView.load(URLRequest(url:url))
        
        print(newName + " welcome")
        
    }
}


extension OverbuffViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //parsing
        parseOverbuffPage()
    }
    
    
    func parseOverbuffPage() {
        webView.evaluateJavaScript("document.body.innerHTML") { result, error in
            guard let html = result as? String, error == nil else {
                print("Failed to get html string")
                return
            }
            let document = HTMLDocument(string: html)
            print("created html doc")
                        
            let mainStats: [String] = document.querySelectorAll(".layout-header-secondary-player").compactMap({ element in
                var stat = element.textContent.replacingOccurrences(of: "Skill Rank", with: " ")
                stat = stat.replacingOccurrences(of: "Skill Rating", with: " ")
                stat = stat.replacingOccurrences(of: "On Fire", with: " ")
                stat = stat.replacingOccurrences(of: "Record", with: " ")
                stat = stat.replacingOccurrences(of: "Wins", with: " None")
                stat = stat.replacingOccurrences(of: "Win", with: " ")
                return stat
            })
            
            self.headLabel.text = "Stat Tracking for:"
            
            for stat in mainStats {
                var i = 0
                let mainStatsArray = stat.wordList
                for word in mainStatsArray {
                    if i == 0 {
                        self.skillRankLabel.isHidden = false
                        self.skillRankLabel.text = word
                    } else if i == 2 {
                        self.onFireLabel.isHidden = false
                        self.onFireLabel.text = word
                    } else if i == 3 {
                        self.recordLabel.isHidden = false
                        self.recordLabel.text = word
                    } else if i == 4 {
                        self.winRateLabel.isHidden = false
                        self.winRateLabel.text = word
                    }
                    i = i + 1
                }
            }
            print("mainStats loop end ")
            
            if mainStats.count == 0 {
                self.skillRankLabelPerm.isHidden = true
                self.onFireLabelPerm.isHidden = true
                self.recordLabelPerm.isHidden = true
                self.winRateLabelPerm.isHidden = true
                
                self.headLabel.text = "Error searching for: "
                self.errorLabel.isHidden = false
                self.errorLabel.numberOfLines = 0
                self.errorLabel.text = "Check Capitalization, Spelling &\nInclude #tag.\nProfile Must be Public."
                self.errorLabel.adjustsFontSizeToFitWidth = true
            }
            
            let srStatDamage: [String] = document.querySelectorAll("[data-value='Damage'] + td").compactMap({ element in
                let stat = element.textContent
                return stat
            })
            if srStatDamage.isEmpty {
                self.damageLabel.isHidden = false
                self.damageLabel.text = "None"
            } else {
                self.damageLabel.isHidden = false
                self.damageLabel.text = srStatDamage[0] + " sr"
            }
            
            let srStatSupport: [String] = document.querySelectorAll("[data-value='Support'] + td").compactMap({ element in
                let stat = element.textContent
                return stat
            })
            if srStatSupport.isEmpty {
                self.support1Label.isHidden = false
                self.support1Label.text = "None"
            } else {
                self.support1Label.isHidden = false
                self.support1Label.text = srStatSupport[0] + " sr"
            }
                        
            let srStatTank: [String] = document.querySelectorAll("[data-value='Tank'] + td").compactMap({ element in
                let stat = element.textContent
                return stat
            })
            if srStatTank.isEmpty {
                self.tank1Label.isHidden = false
                self.tank1Label.text = "None"
            } else {
                self.tank1Label.isHidden = false
                self.tank1Label.text = srStatTank[0] + " sr"
            }
            
            
            let roleStatTankGames: [String] = document.querySelectorAll("[data-value^='Tank'] + td").compactMap({ element in
                let stat = element.textContent
                return stat
            })
            let roleStatTankWR: [String] = document.querySelectorAll("[data-value^='Tank'] + td + td").compactMap({ element in
                let stat = element.textContent
                return stat
            })
            if roleStatTankGames.isEmpty {
                self.tank2Label.isHidden = false
                self.tank2Label.text = "None"
            } else {
                self.tank2Label.isHidden = false
                if roleStatTankGames.count == 2 {
                    self.tank2Label.text = roleStatTankGames[1]
                } else {
                    self.tank2Label.text = "None"
                }
            }
            if roleStatTankWR.isEmpty {
                self.tank3Label.isHidden = false
                self.tank3Label.text = "None"
            } else {
                self.tank3Label.isHidden = false
                self.tank3Label.text = roleStatTankWR[0]
            }
            
            let roleStatSupportGames: [String] = document.querySelectorAll("[data-value^='Support'] + td").compactMap({ element in
                let stat = element.textContent
                return stat
            })
            let roleStatSupportWR: [String] = document.querySelectorAll("[data-value^='Support'] + td + td").compactMap({ element in
                let stat = element.textContent
                return stat
            })
            if roleStatSupportGames.isEmpty {
                self.support2Label.isHidden = false
                self.support2Label.text = "None"
            } else {
                self.support2Label.isHidden = false
                if roleStatSupportGames.count == 2 {
                    self.support2Label.text = roleStatSupportGames[1]
                } else {
                    self.support2Label.text = "None"
                }
            }
            if roleStatSupportWR.isEmpty {
                self.support3Label.isHidden = false
                self.support3Label.text = "None"
            } else {
                self.support3Label.isHidden = false
                self.support3Label.text = roleStatSupportWR[0]
            }
            
            let roleStatOffenseGames: [String] = document.querySelectorAll("[data-value^='Offense'] + td").compactMap({ element in
                let stat = element.textContent
                return stat
            })
            let roleStatOffenseWR: [String] = document.querySelectorAll("[data-value^='Offense'] + td + td").compactMap({ element in
                let stat = element.textContent
                return stat
            })
            if roleStatOffenseGames.isEmpty {
                self.offenseLabel.isHidden = false
                self.offenseLabel.text = "None"
            } else {
                self.offenseLabel.isHidden = false
                self.offenseLabel.text = roleStatOffenseGames[0]
            }
            if roleStatOffenseWR.isEmpty {
                self.offense2Label.isHidden = false
                self.offense2Label.text = "None"
            } else {
                self.offense2Label.isHidden = false
                self.offense2Label.text = roleStatOffenseWR[0]
            }
            
            let roleStatDefenseGames: [String] = document.querySelectorAll("[data-value^='Defense'] + td").compactMap({ element in
                let stat = element.textContent
                return stat
            })
            let roleStatDefenseWR: [String] = document.querySelectorAll("[data-value^='Defense'] + td + td").compactMap({ element in
                let stat = element.textContent
                return stat
            })
            if roleStatDefenseGames.isEmpty {
                self.defenseLabel.isHidden = false
                self.defenseLabel.text = "None"
            } else {
                self.defenseLabel.isHidden = false
                self.defenseLabel.text = roleStatDefenseGames[0]
            }
            if roleStatDefenseWR.isEmpty {
                self.defense2Label.isHidden = false
                self.defense2Label.text = "None"
            } else {
                self.defense2Label.isHidden = false
                self.defense2Label.text = roleStatDefenseWR[0]
            }
            
            if mainStats.isEmpty {
                self.damageLabel.isHidden = true
                self.tank1Label.isHidden = true
                self.tank2Label.isHidden = true
                self.tank3Label.isHidden = true
                self.support1Label.isHidden = true
                self.support2Label.isHidden = true
                self.support3Label.isHidden = true
                self.offenseLabel.isHidden = true
                self.offense2Label.isHidden = true
                self.defenseLabel.isHidden = true
                self.defense2Label.isHidden = true
            }
            
        }
    }
}
            
extension String {
    var wordList: [String] {
        return components(separatedBy: " ").filter { !$0.isEmpty }
    }
}
