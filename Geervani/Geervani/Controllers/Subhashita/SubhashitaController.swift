import UIKit
import PromiseKit

class SubhashitaController: UIViewController, SubhashitaRepositoryObserver {

    @IBOutlet weak var subhashita_text: UILabel!
    
    var subhashitas: [Subhashita] = [Subhashita]()
    var currentSubhashita: String = ""
    var defaultSubhashita = "स्वभावो नोपदेशेन शक्यते कर्तुमन्यथा ।" + "\n\r" +  "सुतप्तमपि पानीयं पुनर्गच्छति शीतताम् ॥" + "\n\nIt is not possible to change a persons habits by advising him. Just like water becomes hot when you heat it... But always turns cold (normal behaviour) in time."

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    


}
