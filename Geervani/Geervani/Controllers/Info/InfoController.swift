
import UIKit

class InfoController: UIViewController {
    

    @IBOutlet weak var InfoWebView: UIWebView!
    @IBOutlet weak var InfoTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Info"
        
        InfoTitle.text = "Geervani"
        InfoTitle.numberOfLines=0
        
        let infoFilePath = Bundle.main.url(forResource: "info", withExtension: "html");
        let myRequest = URLRequest(url:infoFilePath!)
        InfoWebView.loadRequest(myRequest)

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
}
