
import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , UITabBarControllerDelegate {
    
    //App ID: ca-app-pub-6039214503549316~7886279482
    //Ad unit ID: ca-app-pub-6039214503549316/3037277486
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let frame = UIScreen.main.bounds
        self.window = UIWindow(frame: frame)
        
        Fabric.with([Crashlytics.self])
        
        let rootTabBarController: UITabBarController = UITabBarController()
        rootTabBarController.viewControllers = TabProvider().viewControllersForModules()
        rootTabBarController.delegate = self
        rootTabBarController.tabBar.isTranslucent = false
        self.window!.rootViewController = rootTabBarController
        self.window!.makeKeyAndVisible()
        
        /*
         * GA Code - not working. Need to check
         */
        /*
         guard let gai = GAI.sharedInstance() else {
         assert(false, "Google Analytics not configured correctly")
         }
         gai.tracker(withTrackingId: "YOUR_TRACKING_ID")
         // Optional: automatically report uncaught exceptions.
         gai.trackUncaughtExceptions = true
         
         // Optional: set Logger to VERBOSE for debug information.
         // Remove before app release.
         gai.logger.logLevel = .verbose; */
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

