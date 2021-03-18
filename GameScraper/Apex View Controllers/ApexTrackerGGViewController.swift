import UIKit
import HTMLKit
import WebKit

class ApexTrackerGGViewController: UIViewController {
    
    @IBOutlet var headLabel: UILabel!
    @IBOutlet var playerLabel: UILabel!
    
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
        
        
        print("welcome: " + GlobalVariable.playerName)
        print("platform: " + ApexViewController.GlobalPlatform.userPlatform)
        
        
        
        webView.navigationDelegate = self
        let newName = GlobalVariable.playerName.replacingOccurrences(of: "\\s", with: "", options: .regularExpression, range: nil)
        let urlString = "https://apex.tracker.gg/profile/\(ApexViewController.GlobalPlatform.userPlatform)/\(newName)"
        playerLabel.text = GlobalVariable.playerName.replacingOccurrences(of: "\\s", with: "", options: .regularExpression, range: nil)
        guard let url = URL(string: urlString) else {
            return
        }
        webView.load(URLRequest(url:url))
    }
    
    
    func viewDidLayoutSubviews2() {
        //super.viewDidLayoutSubviews()
        let scrollView = UIScrollView(frame: CGRect(x: 10, y: 170, width: view.frame.size.width - 20, height: view.frame.size.height - 20))
        view.addSubview(scrollView)
        
        if GlobalList.statLabelList.isEmpty {
            self.headLabel.text = "Error for:"
            let errorLabel = UILabel(frame: CGRect(x: 10, y: 20, width: 330, height: 50))
            errorLabel.font = UIFont.boldSystemFont(ofSize: 15)
            errorLabel.numberOfLines = 0
            errorLabel.text = "Check spelling, capitalization, and try again"
            scrollView.addSubview(errorLabel)
        } else {
            let rankImage = UIImageView(frame: CGRect(x: 125, y: 15, width: 70, height: 70))
            let imageURL = URL(string: GlobalList.imageList[0])!
            rankImage.load(url: imageURL)
            scrollView.addSubview(rankImage)
            
            scrollView.contentSize = CGSize(width: 100, height: ((150) + (GlobalList.legendStatsList.count*20) ) ) // height dynamic
            
            var j = 0
            var k = 1
            var x1 = 30
            var y1 = 30
            for _ in GlobalList.statLabelList {
                let statLabel = UILabel(frame: CGRect(x: x1, y: y1, width: 200, height: 20))
                statLabel.text = GlobalList.statLabelList[j]
                statLabel.font = UIFont.boldSystemFont(ofSize: 18)
                scrollView.addSubview(statLabel)

                x1 = x1 + 182
                if k % 2 == 0 {
                    //even num
                    y1 = y1 + 60
                    x1 = 30
                }

                j = j + 1
                k = k + 1
            }
            
            j = 0
            k = 1
            x1 = 30
            y1 = 50
            
            for _ in GlobalList.statValueList {
                let statValue = UILabel(frame: CGRect(x: x1, y: y1, width: 200, height: 20))
                statValue.text = GlobalList.statValueList[j]
                statValue.font = statValue.font.withSize(18)
                scrollView.addSubview(statValue)

                x1 = x1 + 182
                if k % 2 == 0 {
                    //even num
                    y1 = y1 + 60
                    x1 = 30
                }
                j = j + 1
                k = k + 1
            }

            j = 0
            k = 1
            x1 = 30
            y1 = y1 + 50
            for _ in GlobalList.legendStatsList {
                var checkConditional: Bool
                
                if GlobalList.legendStatsList[j] == "Bangalore" || GlobalList.legendStatsList[j] == "Bloodhound" || GlobalList.legendStatsList[j] == "Caustic" || GlobalList.legendStatsList[j] == "Crypto" || GlobalList.legendStatsList[j] == "Gibraltar" || GlobalList.legendStatsList[j] == "Horizon" || GlobalList.legendStatsList[j] == "Lifeline" || GlobalList.legendStatsList[j] == "Loba" || GlobalList.legendStatsList[j] == "Mirage" || GlobalList.legendStatsList[j] == "Octane" || GlobalList.legendStatsList[j] == "Pathfinder" || GlobalList.legendStatsList[j] == "Rampart" || GlobalList.legendStatsList[j] == "Revenant" || GlobalList.legendStatsList[j] == "Wattson" || GlobalList.legendStatsList[j] == "Wraith" {
                    checkConditional = true
                } else {
                    checkConditional = false
                }
                if checkConditional {
                    let heroNameLabel = UILabel(frame: CGRect(x: 10, y: y1, width: 200, height: 25))
                    heroNameLabel.text = GlobalList.legendStatsList[j]
                    heroNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
                    scrollView.addSubview(heroNameLabel)
                    x1 = 30
                    k = k - 1
                } else {
                    let statValue = UILabel(frame: CGRect(x: x1, y: y1, width: 200, height: 20))
                    statValue.text = GlobalList.legendStatsList[j]
                    statValue.font = statValue.font.withSize(18)
                    statValue.adjustsFontSizeToFitWidth = true
                    scrollView.addSubview(statValue)

                    x1 = x1 + 200
                    
                }
                if k % 2 == 0 {
                    //even num
                    y1 = y1 + 20
                    x1 = 30
                }
                j = j + 1
                k = k + 1
            }
            GlobalList.imageList = []
            GlobalList.statLabelList = []
            GlobalList.statValueList = []
            GlobalList.legendStatsList = []
        }
    }

}

struct GlobalList {
    static var statLabelList: [String] = []
    static var statValueList: [String] = []
    static var imageList: [String] = []
    static var legendStatsList: [String] = []
}

extension ApexTrackerGGViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //parsing
        parseApexTrackerGGPage()
    }
    
    
    func parseApexTrackerGGPage() {
        webView.evaluateJavaScript("document.body.innerHTML") { result, error in
            guard let html = result as? String, error == nil else {
                print("Failed to get html string")
                return
            }
            let document = HTMLDocument(string: html)
            print("created html doc")
            
            
            let statLabels: [String] = document.querySelectorAll(".trn-defstats--width4 .trn-defstat__name").compactMap({ element in
                let stat = element.textContent
                return stat
            })
            for stat in statLabels {
                GlobalList.statLabelList.append(stat)
            }
            
            let statValues: [String] = document.querySelectorAll(".trn-defstats--width4 .trn-defstat__value").compactMap({ element in
                let stat = element.textContent
                return stat
            })
            var i = 0
            for stat in statValues {
                if i == 0 {
                    GlobalList.statValueList.append("RP: \(stat)")
                } else {
                    GlobalList.statValueList.append(stat)
                }
                i = i + 1
            }
            
            
            let legendStats: [String] = document.querySelectorAll(".trn-card__header-title, .ap-legend-stats__stats .trn-defstat__name, .ap-legend-stats__stats .trn-defstat__value").compactMap({ element in
                var stat = element.textContent
                stat = stat.replacingOccurrences(of: "Matches", with: "")
                stat = stat.replacingOccurrences(of: "Lifetime Totals", with: "")
                return stat
            })
            for stat in legendStats {
                GlobalList.legendStatsList.append(stat)

            }

            let rankImageList: [String] = document.querySelectorAll(".trn-defstat__img img").compactMap({ element in
                guard let src = element.attributes["src"] as? String else {
                    return nil
                }
                return src
            })
            for image in rankImageList {
                GlobalList.imageList.append(image)
            }

            self.viewDidLayoutSubviews2()
        }
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
