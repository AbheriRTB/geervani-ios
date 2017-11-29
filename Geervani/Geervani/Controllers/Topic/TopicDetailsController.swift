import UIKit
import PromiseKit

class TopicDetailsController: UIViewController,TopicDetailsRepositoryObserver {
    
    @IBOutlet weak var translitLabel: UILabel!
    @IBOutlet weak var sanskritLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier:String = "!!"
    var topicDetails : [TopicDetail] = [TopicDetail]()
    var topic : Topic?
    var selectedDefaultIndexPath = false
    var activityIndicator : UIActivityIndicatorView =
        UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //navigationController?.navigationBar.barTintColor=UIColor.init(red:100/255, green:200/255,blue:255/255, alpha:1.0)
        
        //Show activity indicator
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.color=UIColor.blue
        activityIndicator.startAnimating()
        
        self.title = self.topic?.title
        let topicDetailsRepository = TopicDetailsRepository()
        topicDetailsRepository.addObserver(self)
        
        self.topicDetails = topicDetailsRepository.fetchAllTopicsDetailsForTopic(topic: self.topic!)
        tableView.reloadData()
        
        let networkStatus = Reachability().connectionStatus()
        switch networkStatus {
        case .Unknown, .Offline:
            activityIndicator.stopAnimating()
            break
        case .Online(_):
            let promise = topicDetailsRepository.fetchDetailsForTopics(self.topic!)
            promise.then({ (allTopics) -> AnyObject? in
                self.topicDetails = allTopics as! [TopicDetail]
                return nil
            }) { (error) -> AnyObject? in
                return nil
            }
        }
        self.tableView.register(UITableViewCell.classForKeyedArchiver(), forCellReuseIdentifier: cellIdentifier)
        
        
        //Code to select the first row of the table
        if self.selectedDefaultIndexPath == false && self.topicDetails.count > 1 {
            let indexPath = IndexPath(row: 0, section: 0)
            // if have not this, cell.backgroundView will nil.
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
            // trigger delegate to do something.
            _ = self.tableView.delegate?.tableView?(self.tableView, didSelectRowAt: indexPath)
            //self.selectedDefaultIndexPath = true
        }
        self.edgesForExtendedLayout = []
    }
    
    func topicDetailsRepository(_ topicDetailsRepository: TopicDetailsRepository, cachedTopicDetails: [TopicDetail]){
        self.topicDetails = cachedTopicDetails
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            
            
            //Code to select the first row of the table
            if self.selectedDefaultIndexPath == false && self.topicDetails.count > 1 {
                let indexPath = IndexPath(row: 0, section: 0)
                // if have not this, cell.backgroundView will nil.
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
                // trigger delegate to do something.
                _ = self.tableView.delegate?.tableView?(self.tableView, didSelectRowAt: indexPath)
                self.selectedDefaultIndexPath = true
            }
        } 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
         //Code to select the first row of the table
         if selectedDefaultIndexPath == false && topicDetails.count > 1 {
         let indexPath = IndexPath(row: 0, section: 0)
         // if have not this, cell.backgroundView will nil.
         tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
         // trigger delegate to do something.
         _ = tableView.delegate?.tableView?(self.tableView, didSelectRowAt: indexPath)
         selectedDefaultIndexPath = true
         } */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupWithTopic(_ topic: Topic) {
        self.topic = topic
    }
    
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.topicDetails.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)
        let topic = self.topicDetails[indexPath.row]
        cell.textLabel?.text = topic.english
        if cell.isSelected{
            cell.contentView.backgroundColor = UIColor(red:0/255, green:140/255, blue:190/255, alpha:1)
        }else{
            cell.backgroundColor = tableView.backgroundColor
        }
        
        cell.textLabel?.backgroundColor=UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        let topic = self.topicDetails[indexPath.row]
        self.translitLabel.text = topic.translit
        self.sanskritLabel.text = topic.sanskrit
        self.sanskritLabel.numberOfLines=0
        self.translitLabel.numberOfLines=0
        
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath as IndexPath)!
        selectedCell.textLabel?.backgroundColor=UIColor.clear
        selectedCell.contentView.backgroundColor = UIColor(red:0/255, green:140/255, blue:190/255, alpha:1)
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAtIndexPath indexPath: IndexPath){
        
        guard let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath as IndexPath) else {
            return
        }
        selectedCell.textLabel?.backgroundColor=UIColor.clear
        selectedCell.backgroundColor = tableView.backgroundColor
    }
    
    
    
}
