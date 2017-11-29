//
//  DictionaryController.swift
//  Geervani
//
//  Created by Prasanna Ramaswamy on 27/06/16.
//  Copyright © 2016 Geervani. All rights reserved.
//

import UIKit
import PromiseKit

class DictionaryController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating, WordRepositoryObserver {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier:String = "!"
    var words : [Word] = [Word]()
    var resultSearchController = UISearchController()
    let cellSpacingHeight: CGFloat = 150
    var sections : [(index: Int, length :Int, title: String)] = Array()
    var activityIndicator : UIActivityIndicatorView =
        UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    var loadLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 10))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dictionary"
        
        print("Inside DictionaryController.viewDidLoad")
        
        //Code for adding search window
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.autocapitalizationType = UITextAutocapitalizationType.none
            
            self.tableView.tableHeaderView = controller.searchBar
            //self.view.addSubview(resultSearchController.view)
            
            return controller
        })()
        
        //Show activity indicator
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.color=UIColor.gray
        activityIndicator.startAnimating()
        
        let textLabel = UIBarButtonItem(customView:loadLabel)
        self.navigationItem.setLeftBarButton(textLabel, animated: false)
        loadLabel.text="Loading..."
        loadLabel.sizeToFit()
        
        
        let wordRepository = WordRepository()
        wordRepository.addObserver(self)
        
        //Initially render the table with cached data
        self.words = wordRepository.fetchAllWords()
        if self.words.count > 0 {
            self.sections = self.getSections(self.words)
            self.tableView.reloadData()
        }
        
        let networkStatus = Reachability().connectionStatus()
        switch networkStatus {
        case .Unknown, .Offline:
            activityIndicator.stopAnimating()
            loadLabel.text=""
            break
        case .Online(_):
            //Fetch latest data from the web and update the table view
            let promise = wordRepository.fetchWords()
            promise.then({ (allWords) -> AnyObject? in
                self.words = allWords as! [Word]
                self.sections = self.getSections(self.words)
                return nil
            }) { (error) -> AnyObject? in
                return nil
            }
            break
        }
        
        //self.tableView.registerClass(UITableViewCell.classForKeyedArchiver(), forCellReuseIdentifier: cellIdentifier)
        let cellNib=UINib(nibName: "DictionaryTableCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableView.rowHeight=UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight=200
        
        
        //Register tap gesture recognizer to hide keyboard when not required
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DictionaryController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
    }
    
    func wordRepository(_ wordRepository: WordRepository,cachedWords: [Word]){
        self.words = cachedWords
        self.sections = getSections(self.words)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.loadLabel.text=""
        } 
        
    }
    func wordRepository(_ wordRepository: WordRepository,cachedWords: [Word], letter:String){
        self.words = cachedWords
        self.sections = getSections(self.words)
        print(letter)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return (self.words.count)
        return sections[section].length
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    
    @objc func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        return sections.map { $0.title }
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        return index
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //Create label and autoresize it
        let labelFrame = CGRect(x: 10, y: 5, width: tableView.frame.width, height: 0.01)
        let headerLabel = UILabel(frame: labelFrame)
        headerLabel.font = UIFont(name: "Avenir-Light", size: 20)
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerLabel.textColor=UIColor.init(red:200, green:200, blue:200, alpha:1)
        
        //Adding Label to existing headerView
        self.edgesForExtendedLayout = UIRectEdge()
        
        let headerView = UIView(frame: CGRect.zero)
        headerView.backgroundColor = UIColor.darkGray
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    //This function is a must to control the height of the header. viewForHeaderInSection can't control the height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerFrame = CGRect(x: 10, y: 5, width: tableView.frame.width, height: 0.01)
        let footerView = UIView(frame: footerFrame)
        footerView.backgroundColor = UIColor.lightGray
        
        return footerView
    }
    
    //This function is a must to control the height of the footer. viewForFooterInSection can't control the height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)as! DictionaryTableCell
        
        //let word = self.words[indexPath.row]
        let word = self.words[sections[indexPath.section].index + indexPath.row]
        cell.WordLabel?.text = word.english
        cell.WordLabel.numberOfLines=0;
        
        cell.WordMeaningLabel?.text = word.sanskrit
        cell.WordMeaningLabel.numberOfLines=0;
        cell.WordMeaningLabel.sizeToFit()
        
        //cell.EnglishText.preferredMaxLayoutWidth=cell.frame.size.width;
        //cell.EnglishText?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        /*cell.SanskritText?.text = word.sanskrit!
         cell.ExampleText?.text = "Example Text. Example Text. Example Text"
         cell.backgroundColor=UIColor.whiteColor()
         
         cell.SanskritText.numberOfLines=0;
         cell.ExampleText.numberOfLines=0;
         
         
         cell.SanskritText.preferredMaxLayoutWidth=cell.frame.size.width;
         cell.ExampleText.preferredMaxLayoutWidth=cell.frame.size.width;*/
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //let topicDetailsController = TopicDetailsController()
        //let topic = self.words[indexPath.row]
        //topicDetailsController.setupWithTopic(topic)
        //self.navigationController!.pushViewController(topicDetailsController as UIViewController, animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        var filteredwords : [Word] = [Word]()
        
        let searchString:String = searchController.searchBar.text! + "%"
        //print("Search:" + searchString)
        let wordRepository = WordRepository()
        if searchString.count > 1{
            filteredwords = wordRepository.fetchFilteredWords(searchString)
            
            //Recreate the section
            let string = searchController.searchBar.text!.uppercased();
            let firstCharacter = string[string.startIndex]
            let title = "\(firstCharacter)"
            let newSection = (index: 0, length: filteredwords.count, title: title)
            sections.removeAll()
            sections.append(newSection)
            
        }else{
            filteredwords = wordRepository.fetchAllWords()
            sections = getSections(filteredwords)
        }
        
        
        self.words = filteredwords
        self.tableView.reloadData()
        
        /*
         filteredTableData.removeAll(keepCapacity: false)
         
         let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text)
         let array = (tableData as NSArray).filteredArrayUsingPredicate(searchPredicate)
         filteredTableData = array as! [String]
         
         self.tableView.reloadData()*/
    }
    
    func getSections(_ words:[Word]) -> [(index: Int, length :Int, title: String)]{
        
        var index = 0;
        var sections : [(index: Int, length :Int, title: String)] = Array()
        
        for  i in 0...words.count-1 {
            
            if words[i].english!.count == 0{
                continue
            }
            
            let commonPrefix = words[i].english!.commonPrefix(with: words[index].english!, options: .caseInsensitive)
            
            if (commonPrefix.count == 0 || i == words.count-1){
                
                let string = words[index].english!.uppercased();
                let firstCharacter = string[string.startIndex]
                let title = "\(firstCharacter)"
                if title=="Z"{
                    let newSection = (index: index, length: words.count - index, title: title)
                    sections.append(newSection)
                }else{
                    let newSection = (index: index, length: i - index, title: title)
                    sections.append(newSection)
                }
                
                index = i
            }
        }
        
        return sections
    }
    
    func hideKeyboard() {
        tableView.endEditing(true)
    }
    
    
}
