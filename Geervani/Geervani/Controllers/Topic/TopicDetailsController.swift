

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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = self.topic?.title
        let topicDetailsRepository = TopicDetailsRepository()
        topicDetailsRepository.addObserver(self)
        let promise = topicDetailsRepository.fetchDetailsForTopics(self.topic!)
        promise.then({ (allTopics) -> AnyObject? in
            self.topicDetails = allTopics as! [TopicDetail]
            return nil
        }) { (error) -> AnyObject? in
            return nil
        }
        self.tableView.register(UITableViewCell.classForKeyedArchiver(), forCellReuseIdentifier: cellIdentifier)
        self.edgesForExtendedLayout = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        
        if selectedDefaultIndexPath == false {
            let indexPath = IndexPath(row: 0, section: 0)
            // if have not this, cell.backgroundView will nil.
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
            // trigger delegate to do something.
            _ = tableView.delegate?.tableView?(self.tableView, didSelectRowAt: indexPath)
            selectedDefaultIndexPath = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupWithTopic(_ topic: Topic) {
        self.topic = topic
    }

    func topicDetailsRepository(_ topicDetailsRepository: TopicDetailsRepository, cachedTopicDetails: [TopicDetail]){
        self.topicDetails = cachedTopicDetails
        self.tableView.reloadData()
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

}
