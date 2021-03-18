import UIKit
import HTMLKit
import WebKit

class OwTrackerPage2ViewController: UIViewController {
    
    @IBOutlet var hero1: UILabel!
    @IBOutlet var hero2: UILabel!
    @IBOutlet var hero3: UILabel!
    @IBOutlet var hero4: UILabel!
    @IBOutlet var hero5: UILabel!
    
    @IBOutlet var playtime1: UILabel!
    @IBOutlet var playtime2: UILabel!
    @IBOutlet var playtime3: UILabel!
    @IBOutlet var playtime4: UILabel!
    @IBOutlet var playtime5: UILabel!
    
    @IBOutlet var heroStats1: UILabel!
    @IBOutlet var heroStats10: UILabel!
    @IBOutlet var heroStats2: UILabel!
    @IBOutlet var heroStats20: UILabel!
    @IBOutlet var heroStats3: UILabel!
    @IBOutlet var heroStats30: UILabel!
    @IBOutlet var heroStats4: UILabel!
    @IBOutlet var heroStats40: UILabel!
    @IBOutlet var heroStats5: UILabel!
    @IBOutlet var heroStats50: UILabel!
    
    @IBOutlet var hero1WL: UILabel!
    @IBOutlet var hero2WL: UILabel!
    @IBOutlet var hero3WL: UILabel!
    @IBOutlet var hero4WL: UILabel!
    @IBOutlet var hero5WL: UILabel!
    
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
        
        let urlString = "https://overwatchtracker.com/profile/pc/global/\(OwTrackerViewController.GlobalVariable.link)?mode=1"
        
        guard let url = URL(string: urlString) else {
            return
        }
        webView.load(URLRequest(url:url))
        
        print(OwTrackerViewController.GlobalVariable.link + " welcome to page 2")
    } 
}


extension OwTrackerPage2ViewController: WKNavigationDelegate {
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
            
            let heroNames: [String] = document.querySelectorAll(".hero .card-title").compactMap({ element in
                let stat = element.textContent
                return stat
            })
            
            if heroNames.count == 0 {
                self.hero1.isHidden = false
                self.hero1.text = "Error - Check spelling, capitalization & include #tag."
                self.hero1.numberOfLines = 0
                self.hero1.textAlignment = .center
                let size = self.hero1.sizeThatFits(CGSize(width: 343, height: 159))
                self.hero1.frame = CGRect(origin: CGPoint(x: 25, y: 250), size: size)
                self.hero1.adjustsFontSizeToFitWidth = true

            }
            
            var i = 1
            for stat in heroNames {
                if i == 1 {
                    self.hero1.isHidden = false
                    self.hero1.text = stat
                } else if i == 2 {
                    self.hero2.isHidden = false
                    self.hero2.text = stat
                } else if i == 3 {
                    self.hero3.isHidden = false
                    self.hero3.text = stat
                } else if i == 4 {
                    self.hero4.isHidden = false
                    self.hero4.text = stat
                } else if i == 5 {
                    self.hero5.isHidden = false
                    self.hero5.text = stat
                }
                i = i + 1
            }
            print("heroNames Loop End")
            
            
            
            let timePlayed: [String] = document.querySelectorAll(".text-stats").compactMap({ element in
                var stat = element.textContent
                stat = stat.trimmingCharacters(in: .whitespacesAndNewlines)
                return stat
            })
            
            i = 0
            for stat in timePlayed {
                if i == 0 {
                    self.playtime1.isHidden = false
                    self.playtime1.text = stat
                } else if i == 1 {
                    self.playtime2.isHidden = false
                    self.playtime2.text = stat
                } else if i == 2 {
                    self.playtime3.isHidden = false
                    self.playtime3.text = stat
                } else if i == 3 {
                    self.playtime4.isHidden = false
                    self.playtime4.text = stat
                } else if i == 4 {
                    self.playtime5.isHidden = false
                    self.playtime5.text = stat
                }
                i = i + 1
            }
            
            
            let heroStats: [String] = document.querySelectorAll(".stat-group").compactMap({ element in
                var stat = element.textContent
                stat = stat.trimmingCharacters(in: .whitespacesAndNewlines)
                stat = stat.replacingOccurrences(of: "\n", with: " ", options: .regularExpression, range: nil)
                stat = stat.replacingOccurrences(of: "Hero Specific (Per Min)  ", with: "HERO SPECIFIC (Per Min):")
                stat = stat.replacingOccurrences(of: "Most Per Game  ", with: "\nMOST (Per Game):")
                stat = stat.replacingOccurrences(of: " - Most in Game  ", with: "")
                stat = stat.replacingOccurrences(of: "Game Averages  ", with: "AVERAGES (Per Game):")
                return stat
            })
            self.heroStats1.text = ""
            self.heroStats10.text = ""
            self.heroStats2.text = ""
            self.heroStats20.text = ""
            self.heroStats3.text = ""
            self.heroStats30.text = ""
            self.heroStats4.text = ""
            self.heroStats40.text = ""
            self.heroStats5.text = ""
            self.heroStats50.text = ""
            
            i = 0
            for stat in heroStats {
                if i == 0 {
                    self.heroStats1.isHidden = false
                    self.heroStats1.text?.append(stat)
                } else if i == 1 {
                    self.heroStats10.isHidden = false
                    self.heroStats10.text?.append(stat)
                }
                else if i == 2 {
                    self.heroStats2.isHidden = false
                    self.heroStats2.text?.append(stat)
                } else if i == 3 {
                    self.heroStats20.isHidden = false
                    self.heroStats20.text?.append(stat)
                } else if i == 4 {
                    self.heroStats3.isHidden = false
                    self.heroStats3.text?.append(stat)
                } else if i == 5 {
                    self.heroStats30.isHidden = false
                    self.heroStats30.text?.append(stat)
                } else if i == 6 {
                    self.heroStats4.isHidden = false
                    self.heroStats4.text?.append(stat)
                } else if i == 7 {
                    self.heroStats40.isHidden = false
                    self.heroStats40.text?.append(stat)
                } else if i == 8 {
                    self.heroStats5.isHidden = false
                    self.heroStats5.text?.append(stat)
                } else if i == 9 {
                    self.heroStats50.isHidden = false
                    self.heroStats50.text?.append(stat)
                }
                i = i + 1
            }
            print("heroStats loop end")
            
            let winStats: [String] = document.querySelectorAll(".left-text").compactMap({ element in
                let stat = element.textContent
                return stat
            })
         
            i = 0
            for stat in winStats {
                if i == 0 {
                    self.hero1WL.isHidden = false
                    self.hero1WL.text = stat
                } else if i == 1 {
                    self.hero2WL.isHidden = false
                    self.hero2WL.text = stat
                } else if i == 2 {
                    self.hero3WL.isHidden = false
                    self.hero3WL.text = stat
                } else if i == 3 {
                    self.hero4WL.isHidden = false
                    self.hero4WL.text = stat
                } else if i == 4 {
                    self.hero5WL.isHidden = false
                    self.hero5WL.text = stat
                }
                i = i + 1
            }
            
            let lossStats: [String] = document.querySelectorAll(".right-text").compactMap({ element in
                let stat = element.textContent
                return stat
            })
            i = 0
            for stat in lossStats {
                if i == 0 {
                    self.hero1WL.text?.append(" \(stat)")
                } else if i == 1 {
                    self.hero2WL.text?.append(" \(stat)")
                } else if i == 2 {
                    self.hero3WL.text?.append(" \(stat)")
                } else if i == 3 {
                    self.hero4WL.text?.append(" \(stat)")
                } else if i == 4 {
                    self.hero5WL.text?.append(" \(stat)")
                }
                i = i + 1
            }
            
            
        }
    }
    
}

