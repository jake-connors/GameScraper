import UIKit
import HTMLKit
import WebKit

class OwTrackerViewController: UIViewController {
    
    @IBOutlet var headLabel: UILabel!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var playerLabel: UILabel!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var levelLabelPerm: UILabel!
    @IBOutlet var winRateLabel: UILabel!
    @IBOutlet var winRateLabelPerm: UILabel!
    @IBOutlet var primaryHeroLabel: UILabel!
    @IBOutlet var primaryHeroLabelPerm: UILabel!
    @IBOutlet var kdLabel: UILabel!
    @IBOutlet var kdLabelPerm: UILabel!
    @IBOutlet var kdaLabel: UILabel!
    @IBOutlet var kdaLabelPerm: UILabel!
    @IBOutlet var elimsPerGameLabel: UILabel!
    @IBOutlet var dmgPerGameLabel: UILabel!
    @IBOutlet var healsPerGameLabel: UILabel!
    @IBOutlet var gamesWonLabel: UILabel!
    @IBOutlet var gamesPlayedLabel: UILabel!
    @IBOutlet var mostElimsLabel: UILabel!
    @IBOutlet var mostFinalBlowsLabel: UILabel!
    @IBOutlet var mostDmgDoneLabel: UILabel!
    @IBOutlet var mostHealingLabel: UILabel!
    
    @IBOutlet var levelRankLabel: UILabel!
    @IBOutlet var kdRankLabel: UILabel!
    @IBOutlet var kdaRankLabel: UILabel!
    @IBOutlet var winRateRankLabel: UILabel!
    @IBOutlet var elimsPerGameRankLabel: UILabel!
    @IBOutlet var dmgPerGameRankLabel: UILabel!
    @IBOutlet var healsPerGameRankLabel: UILabel!
    @IBOutlet var gamesWonRankLabel: UILabel!
    @IBOutlet var gamesPlayedRankLabel: UILabel!
    @IBOutlet var mostElimsRankLabel: UILabel!
    @IBOutlet var mostFinalBlowsRankLabel: UILabel!
    @IBOutlet var mostHealingRankLabel: UILabel!

    
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
        let urlString = "https://overwatchtracker.com/profile/pc/global/\(newName)?mode=1"
        playerLabel.text = GlobalVariable.playerName.replacingOccurrences(of: "\\s", with: "", options: .regularExpression, range: nil)
        guard let url = URL(string: urlString) else {
            return
        }
        webView.load(URLRequest(url:url))
        
        print(newName + " welcome")
    }
}

extension OwTrackerViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //parsing
        parsePage()
    }

    func parsePage() {
        
        webView.evaluateJavaScript("document.body.innerHTML") { result, error in
            guard let html = result as? String, error == nil else {
                print("Failed to get html string")
                return
            }
            let document = HTMLDocument(string: html)
            print("created html doc")
            
            
            let headerStats: [String] = document.querySelectorAll(".infobox").compactMap({ element in
                let stat = element.textContent
                return stat
            })
            self.headLabel.text = "Stat Tracking For:"
            if headerStats.count == 0 {
                self.levelLabelPerm.isHidden = true
                self.winRateLabelPerm.isHidden = true
                self.primaryHeroLabelPerm.isHidden = true
                self.kdLabelPerm.isHidden = true
                self.kdaLabelPerm.isHidden = true
                self.headLabel.text = "Error searching for: "
                self.errorLabel.isHidden = false
                self.errorLabel.numberOfLines = 0
                self.errorLabel.text = "Check Spelling, Capitalization & Include #tag.\nProfile Must be Public.\nPlease Try Again."
            }
            var i = 0;
            for var stat in headerStats {
                if i == 4 {
                    self.primaryHeroLabel.isHidden = false
                    self.primaryHeroLabel.numberOfLines = 0
                    stat = stat.replacingOccurrences(of: "Primary Hero", with: "")
                    self.primaryHeroLabel.text = stat
                }
                i+=1
            }
            
            
            parseStatAndRank(cssStat: ".stat [data-stat='Level']", cssRank: ".stat [data-stat='Level'] + .rank", labelStat: self.levelLabel, labelRank: self.levelRankLabel)
            
            parseStatAndRank(cssStat: ".stat [data-stat='Kd']", cssRank: ".stat [data-stat='Kd'] + .rank", labelStat: self.kdLabel, labelRank: self.kdRankLabel)
            
            parseStatAndRank(cssStat: ".stat [data-stat='Kad']", cssRank: ".stat [data-stat='Kad'] + .rank", labelStat: self.kdaLabel, labelRank: self.kdaRankLabel)
            
            parseStatAndRank(cssStat: ".stat [data-stat='Wl']", cssRank: ".stat [data-stat='Wl'] + .rank", labelStat: self.winRateLabel, labelRank: self.winRateRankLabel)

            parseStatAndRank(cssStat: ".stat [data-stat='EliminationsPG']", cssRank: ".stat [data-stat='EliminationsPG'] + .rank", labelStat: self.elimsPerGameLabel, labelRank: self.elimsPerGameRankLabel)
            
            parseStatAndRank(cssStat: ".stat [data-stat='DamageDonePG']", cssRank: ".stat [data-stat='DamageDonePG'] + .rank", labelStat: self.dmgPerGameLabel, labelRank: self.dmgPerGameRankLabel)
            
            parseStatAndRank(cssStat: ".stat [data-stat='HealingDonePG']", cssRank: ".stat [data-stat='HealingDonePG'] + .rank", labelStat: self.healsPerGameLabel, labelRank: self.healsPerGameRankLabel)
            
            parseStatAndRank(cssStat: ".stat [data-stat='GamesWon']", cssRank: ".stat [data-stat='GamesWon'] + .rank", labelStat: self.gamesWonLabel, labelRank: self.gamesWonRankLabel)

            parseStatAndRank(cssStat: ".stat [data-stat='GamesPlayed']", cssRank: ".stat [data-stat='GamesPlayed'] + .rank", labelStat: self.gamesPlayedLabel, labelRank: self.gamesPlayedRankLabel)
            
            parseStatAndRank(cssStat: ".stat [data-stat='MostEliminations']", cssRank: ".stat [data-stat='MostEliminations'] + .rank", labelStat: self.mostElimsLabel, labelRank: self.mostElimsRankLabel)

            parseStatAndRank(cssStat: ".stat [data-stat='MostFinalBlows']", cssRank: ".stat [data-stat='MostFinalBlows'] + .rank", labelStat: self.mostFinalBlowsLabel, labelRank: self.mostFinalBlowsRankLabel)
            
            
            let mostDmgDoneStat: [String] = document.querySelectorAll(".stat [data-stat='MostDamageDone']").compactMap({ element in
                let stat = element.textContent
                return stat
            })
            for stat in mostDmgDoneStat {
                self.mostDmgDoneLabel.isHidden = false
                self.mostDmgDoneLabel.text = stat
            }
            
            parseStatAndRank(cssStat: ".stat [data-stat='MostHealing']", cssRank: ".stat [data-stat='MostHealing'] + .rank", labelStat: self.mostHealingLabel, labelRank: self.mostHealingRankLabel)
        }
        
        func parseStatAndRank(cssStat: String, cssRank: String, labelStat: UILabel, labelRank: UILabel) {
            webView.evaluateJavaScript("document.body.innerHTML") { result, error in
                guard let html = result as? String, error == nil else {
                    print("Failed to get html string")
                    return
                }
                let document = HTMLDocument(string: html)
                
                let numberStat: [String] = document.querySelectorAll(cssStat).compactMap({ element in
                    let stat = element.textContent
                    return stat
                })
                for stat in numberStat {
                    labelStat.isHidden = false
                    labelStat.text = stat
                }
                let percentRank: [String] = document.querySelectorAll(cssRank).compactMap({ element in
                    var rank = element.textContent
                    rank = rank.trimmingCharacters(in: .whitespacesAndNewlines)
                    rank = rank.replacingOccurrences(of: "[\\(\\)]", with: "", options: .regularExpression, range: nil)
                    rank = rank.components(separatedBy: " ").last!
                    return rank
                })
                for rank in percentRank {
                    labelRank.isHidden = false
                    labelRank.text = "Top \(rank)"
                }
            }
        }
        
    }
}
