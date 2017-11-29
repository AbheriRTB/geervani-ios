
import UIKit


class TopicController: UIViewController,UITableViewDelegate,UITableViewDataSource,TopicsRepositoryObserver{
    
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier:String = "!"
    var topics : [Topic] = [Topic]()
    var activityIndicator : UIActivityIndicatorView =
        UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Topics"
        
        //Show activity indicator
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.color=UIColor.black
        activityIndicator.startAnimating()
        
        
        let topicsRepository = TopicsRepository()
        topicsRepository.addObserver(self)
        
        //Initially load from cache
        self.topics = topicsRepository.fetchAllTopicsFromCache()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        //Refresh from online if network is available
        let networkStatus = Reachability().connectionStatus()
        switch networkStatus {
        case .Unknown, .Offline:
            activityIndicator.stopAnimating()
            break
        case .Online(_):
            let promise  = topicsRepository.fetchAllTopics()
            promise.then({ (allTopics) -> AnyObject? in
                self.topics = allTopics as! [Topic]
                //self.tableView.reloadData()
                return nil
            }) { (error) -> AnyObject? in
                return nil
            }
        }
        
        self.tableView.register(UITableViewCell.classForKeyedArchiver(), forCellReuseIdentifier: cellIdentifier)
    }
    
    func topicsRepository(_ punchRepository: TopicsRepository, cachedTopics: [Topic]){
        self.topics = cachedTopics
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.topics.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let topic = self.topics[indexPath.row]
        cell.textLabel?.text = topic.title
        cell.backgroundColor=UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let topicDetailsController = TopicDetailsController()
        let topic = self.topics[indexPath.row]
        topicDetailsController.setupWithTopic(topic)
        self.navigationController!.pushViewController(topicDetailsController as UIViewController, animated: true)
    }
}
