
import UIKit


class TopicController: UIViewController,UITableViewDelegate,UITableViewDataSource,TopicsRepositoryObserver{

    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier:String = "!"
    var topics : [Topic] = [Topic]()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Topics"
        let topicsRepository = TopicsRepository()
        topicsRepository.addObserver(self)
        let promise  = topicsRepository.fetchAllTopics()
        promise.then({ (allTopics) -> AnyObject? in
            self.topics = allTopics as! [Topic]
            self.tableView.reloadData()
            return nil
        }) { (error) -> AnyObject? in
            return nil
        }

        self.tableView.register(UITableViewCell.classForKeyedArchiver(), forCellReuseIdentifier: cellIdentifier)

    }

    func topicsRepository(_ punchRepository: TopicsRepository, cachedTopics: [Topic]){
        self.topics = cachedTopics
        self.tableView.reloadData()
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
