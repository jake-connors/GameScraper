import UIKit
import HTMLKit
import WebKit

class OverbuffPage2ViewController: UIViewController {
    
    private let webView: WKWebView = {
        let prefs = WKPreferences()
        prefs.javaScriptEnabled = true
        let config = WKWebViewConfiguration()
        config.preferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        
        webView.navigationDelegate = self
        let urlString = "https://www.overbuff.com/players/pc/\(OverbuffViewController.GlobalVariable.link)?mode=competitive"
        guard let url = URL(string: urlString) else {
            return
        }
        webView.load(URLRequest(url:url))
        print(OverbuffViewController.GlobalVariable.link + " welcome to page 2")
    }
    
    func viewDidLayoutSubviews2() {
        //super.viewDidLayoutSubviews()
        let scrollView = UIScrollView(frame: CGRect(x: 10, y: 120, width: view.frame.size.width - 20, height: view.frame.size.height - 20))
        view.addSubview(scrollView)

        
        if GlobalList.nameList.isEmpty {
            let errorLabel = UILabel(frame: CGRect(x: 10, y: 30, width: 200, height: 25))
            errorLabel.font = UIFont.boldSystemFont(ofSize: 18)
            errorLabel.text = "Error"
            scrollView.addSubview(errorLabel)
        } else {
            let heroName1Label = UILabel(frame: CGRect(x: 10, y: 35, width: 200, height: 25))
            heroName1Label.text = GlobalList.nameList[0]
            heroName1Label.font = UIFont.boldSystemFont(ofSize: 20)
            scrollView.addSubview(heroName1Label)
            scrollView.contentSize = CGSize(width: 100, height: (130+(GlobalList.nameList.count*40)+(GlobalList.nameList.count*120)))
            var j = 0
            var k = 1
            var x1 = 0
            var y1 = 60
            var newName = 0
            for _ in GlobalList.statList {
                
                var longConditional : Bool
                if j > 3 {
                    if GlobalList.statList[j].contains("Destruct") || (GlobalList.statList[j].contains("Dmg Amped") && GlobalList.statList[j-2].contains("Off Assists")) || GlobalList.statList[j].contains("Fire Kills") || GlobalList.statList[j].contains("Hog Kills") || GlobalList.statList[j].contains("Flux") || GlobalList.statList[j].contains("Rage") || ( GlobalList.statList[j].contains("Env Kills") && GlobalList.statList[j+1].contains("Hero Rank") ) || GlobalList.statList[j].contains("Proj") || GlobalList.statList[j].contains("Bob") || GlobalList.statList[j].contains("Tank Kills") || GlobalList.statList[j].contains("Meteor") || GlobalList.statList[j-1].contains("Duplicate") || GlobalList.statList[j].contains("Dragon Kills") || GlobalList.statList[j].contains("Tire") || GlobalList.statList[j].contains("Deadeye") || GlobalList.statList[j].contains("Blizzard") || GlobalList.statList[j].contains("Barrage") || GlobalList.statList[j].contains("Blossom") || GlobalList.statList[j].contains("Visor") || GlobalList.statList[j-1].contains("Hacked") || GlobalList.statList[j].contains("Sentry") || GlobalList.statList[j].contains("Molten") || (GlobalList.statList[j].contains("Bomb Kills") && GlobalList.statList[j-1].contains("Bombs Stuck")) || GlobalList.statList[j].contains("Venom") || GlobalList.statList[j].contains("Boost") || GlobalList.statList[j].contains("Beam Healing") || GlobalList.statList[j].contains("Resurrects") || GlobalList.statList[j].contains("Heal Amped") || GlobalList.statList[j-1].contains("Armor Given") || GlobalList.statList[j].contains("Trans") || GlobalList.statList[j].contains("Sound Barriers") {
                        longConditional = true
                    } else {
                        longConditional = false
                    }
                } else {
                    longConditional = false
                }
                
                if longConditional {
                    
                    let heroStatLabel = UILabel(frame: CGRect(x: x1, y: y1, width: 200, height: 20))
                    heroStatLabel.text = GlobalList.statList[j]
                    heroStatLabel.font = heroStatLabel.font.withSize(16)
                    scrollView.addSubview(heroStatLabel)
                    
                    if newName < GlobalList.nameList.count - 1 {
                        let heroNameLabel = UILabel(frame: CGRect(x: 10, y: y1 + 30, width: 200, height: 25))
                        heroNameLabel.text = GlobalList.nameList[newName + 1]
                        heroNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
                        scrollView.addSubview(heroNameLabel)
                        newName = newName + 1
                    }

                    y1 = y1 + 40
                } else {
                    let heroStatLabel = UILabel(frame: CGRect(x: x1, y: y1, width: 200, height: 20))
                    heroStatLabel.text = GlobalList.statList[j]
                    heroStatLabel.font = heroStatLabel.font.withSize(16)
                    scrollView.addSubview(heroStatLabel)
                }
                
                x1 = x1 + 182
                if k % 2 == 0 {
                    //even num
                    y1 = y1 + 20
                    x1 = 0
                }

                j = j + 1
                k = k + 1
            }
            GlobalList.nameList = []
            GlobalList.statList = []
            
            
            
        }
        
    }
    
    struct GlobalList {
        static var nameList : [String] = []
        static var statList : [String] = []
    }
    
}



extension OverbuffPage2ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //parsing
        parseOverbuffPage2()
    }
    
    
    func parseOverbuffPage2() {
        webView.evaluateJavaScript("document.body.innerHTML") { result, error in
            guard let html = result as? String, error == nil else {
                print("Failed to get html string")
                return
            }
            let document = HTMLDocument(string: html)
            print("created html doc")
            
            let heroNamesList: [String] = document.querySelectorAll(".name .color-white").compactMap({ element in
                let stat = element.textContent
                return stat
            })
            
            for name in heroNamesList {
                GlobalList.nameList.append(name)
            }
            let heroStatList: [String] = document.querySelectorAll(".special .stat").compactMap({ element in
                var stat = element.textContent
                stat = stat.replacingOccurrences(of: "Hero", with: " Hero")
                stat = stat.replacingOccurrences(of: "Record", with: " Record")
                return stat
            })
            
            for stat in heroStatList {
                GlobalList.statList.append(stat)
                
            }
            self.viewDidLayoutSubviews2()
        }
    }
    
}
