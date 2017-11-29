
import UIKit
import GoogleMobileAds
import AudioToolbox

class InfoController: UIViewController, GADBannerViewDelegate {
    
    
    @IBOutlet weak var InfoWebView: UIWebView!
    @IBOutlet weak var VersionLabel: UILabel!
    
    // IMPORTANT: REPLACE THE RED STRING BELOW WITH THE AD UNIT ID YOU'VE GOT BY REGISTERING YOUR APP IN http://apps.admob.com
    let ADMOB_BANNER_UNIT_ID = "ca-app-pub-6039214503549316/3037277486"
    // Ad banner and interstitial views
    var adMobBannerView = GADBannerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Init AdMob banner
        initAdMobBanner()
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.VersionLabel.text = "v" + version
        }

        
        self.title = "Info"
        
        /*
         let infoFilePath = Bundle.main.url(forResource: "info", withExtension: "html");
         let myRequest = URLRequest(url:infoFilePath!)
         InfoWebView.loadRequest(myRequest) */
        
        let url = NSURL(string: "http://abheri.pythonanywhere.com/static/geervani/geervani_info.html")
        let request = NSURLRequest(url: url! as URL)
        InfoWebView.loadRequest(request as URLRequest)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getInfoData() -> String  {
        
        var infoString:String = ""
        
        let specsBundle: Bundle = Bundle.main
        let path: String = specsBundle.path(forResource: "info", ofType: "html")!
        
        do{
            infoString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
        }catch let error as NSError{
            print("Failed reading info from file: Error: " + error.localizedDescription)
        }
        
        return infoString
    }
    
    
    // MARK: -  ADMOB BANNER
    func initAdMobBanner() {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone
            adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
            adMobBannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: 320, height: 50)
        } else  {
            // iPad
            adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 468, height: 60))
            adMobBannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: 468, height: 60)
        }
        
        adMobBannerView.adUnitID = ADMOB_BANNER_UNIT_ID
        adMobBannerView.rootViewController = self
        adMobBannerView.delegate = self
        self.view.addSubview(adMobBannerView)
        
        let request = GADRequest()
        adMobBannerView.load(request)
    }
    
    
    // Hide the banner
    func hideBanner(_ banner: UIView) {
        UIView.beginAnimations("hideBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        UIView.commitAnimations()
        banner.isHidden = true
    }
    
    // Show the banner
    func showBanner(_ banner: UIView) {
        UIView.beginAnimations("showBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        UIView.commitAnimations()
        banner.isHidden = false
    }
    
    // AdMob banner available
    func adViewDidReceiveAd(_ view: GADBannerView) {
        showBanner(adMobBannerView)
    }
    
    // NO AdMob banner available
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        hideBanner(adMobBannerView)
    }
}
