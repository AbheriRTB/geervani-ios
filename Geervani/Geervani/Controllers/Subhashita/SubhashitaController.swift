import UIKit
import PromiseKit
import GoogleMobileAds
import AudioToolbox

class SubhashitaController: UIViewController, SubhashitaRepositoryObserver,GADBannerViewDelegate {
    
    @IBOutlet weak var subhashita_text: UILabel!
    
    var subhashitas: [Subhashita] = [Subhashita]()
    var currentSubhashita: String = ""
    var defaultSubhashita = "स्वभावो नोपदेशेन शक्यते कर्तुमन्यथा ।" + "\n\r" +  "सुतप्तमपि पानीयं पुनर्गच्छति शीतताम् ॥" + "\n\nIt is not possible to change a persons habits by advising him. Just like water becomes hot when you heat it... But always turns cold (normal behaviour) in time."
    
    // IMPORTANT: REPLACE THE RED STRING BELOW WITH THE AD UNIT ID YOU'VE GOT BY REGISTERING YOUR APP IN http://apps.admob.com
    let ADMOB_BANNER_UNIT_ID = "ca-app-pub-6039214503549316/3037277486"
    // Ad banner and interstitial views
    var adMobBannerView = GADBannerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Init AdMob banner
        initAdMobBanner()
        
        self.navigationController?.navigationBar.isHidden = true
        
        
        let subhashitaRepository = SubhashitaRepository()
        subhashitaRepository.addObserver(self)
        
        self.subhashitas = subhashitaRepository.fetchAllSubhashitas()
        self.currentSubhashita = getCurrentSubhashita()
        DispatchQueue.main.async {
            self.subhashita_text.numberOfLines=0
            self.subhashita_text.text = self.currentSubhashita
        }
        
        //Fetch latest data from the web and update the table view
        let promise = subhashitaRepository.fetchSubhashitas()
        promise.then({ (allSubhashitas) -> AnyObject? in
            self.subhashitas = allSubhashitas as! [Subhashita]
            self.currentSubhashita = self.getCurrentSubhashita()
            self.subhashita_text.numberOfLines=0
            self.subhashita_text.text = self.currentSubhashita
            return nil
        }) { (error) -> AnyObject? in
            return nil
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func subhashitaRepository(_ subhashitaRepository: SubhashitaRepository, cachedSubhashita cachedSubhashitas: [Subhashita]){
        self.subhashitas = cachedSubhashitas
        self.currentSubhashita = getCurrentSubhashita()
        DispatchQueue.main.async {
            self.subhashita_text.numberOfLines=0
            self.subhashita_text.text = self.currentSubhashita
        }
    }
    
    
    func getCurrentSubhashita() -> String {
        
        let date = Date()
        let unitFlags: NSCalendar.Unit = [.day]
        let components = (Calendar.current as NSCalendar).components(unitFlags, from: date)
        var retString: String = ""
        
        if subhashitas.count >= components.day! {
            retString =  subhashitas[components.day!].sanskrit_text!
        }else if subhashitas.count > 0{
            retString = subhashitas[0].sanskrit_text!
        }else{
            retString =  defaultSubhashita
        }
        
        print("Selected Subhashita: \n" + retString)
        
        return retString
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
