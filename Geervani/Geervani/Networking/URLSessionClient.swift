
import Foundation
import UIKit
import PromiseKit
import KSDeferred

class URLSessionClient {

    func requestWithURL(_ urlString : String) -> KSPromise<AnyObject>{
        let deferred = KSDeferred<AnyObject>()
        let url = URL(string: urlString)!
        let request = NSMutableURLRequest(url:url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) {data,response,error in
            if let error = error{
                DispatchQueue.main.async{
                    deferred.rejectWithError(error)
                }
            }
            else {
                //DispatchQueue.main.async
                    DispatchQueue.global().async{
                    deferred.resolve(withValue: data! as AnyObject)
                }
            }
        }
        dataTask.resume()
        return deferred.promise
    }
}


