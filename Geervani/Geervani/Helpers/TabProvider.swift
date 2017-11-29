
import Foundation
import UIKit

class TabProvider {

    let subhashitaModule:String = "SUBHASHITA_TAB_MODULE_NAME"
    let topicModule     :String = "TOPIC_TAB_MODULE_NAME"
    let dictionaryModule:String = "DICTIONARY_TAB_MODULE_NAME"
    let infoModule      :String = "INFO_TAB_MODULE_NAME"

    func viewControllersForModules() -> [UIViewController]  {

        var modules :[String] = [subhashitaModule, topicModule, dictionaryModule,infoModule]
        var viewControllers: [UIViewController] = [UIViewController]()

        for index in 0 ..< modules.count {
            let moduleName = modules[index]
            if (moduleName == subhashitaModule) {

                let subhashitaViewController = SubhashitaController(nibName: "SubhashitaController", bundle: nil)
                let navController = navigationControllerWithRootController(subhashitaViewController, title: "Subhashita", imageName: "subhashita_icon", tag: index)
                viewControllers.append(navController)
            }
            else if (moduleName == topicModule) {

                let topicController = TopicController(nibName: "TopicController", bundle: nil)
                let navController = navigationControllerWithRootController(topicController, title: "Topics", imageName: "topics_icon", tag: index)
                viewControllers.append(navController)
            }

            else if (moduleName == dictionaryModule) {

                let dictionaryController = DictionaryController(nibName: "DictionaryController", bundle: nil)
                let navController = navigationControllerWithRootController(dictionaryController, title: "Dictionary", imageName: "dictionary_icon", tag: index)
                viewControllers.append(navController)
            }

            else if (moduleName == infoModule) {

                let infoController = InfoController(nibName: "InfoController", bundle: nil)
                let navController = navigationControllerWithRootController(infoController, title: "Info", imageName: "info_icon", tag: index)
                viewControllers.append(navController)
            }

        }

        return viewControllers;
    }

    fileprivate func navigationControllerWithRootController(_ rootViewController: UIViewController, title: String,imageName : String,tag : Int) -> UINavigationController {
        let navController: UINavigationController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        navController.view.tag = tag
        return navController
    }
}

