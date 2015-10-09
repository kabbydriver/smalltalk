import UIKit


class Rest: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate {
    
    var customQueue = NSOperationQueue()
    func httpGet(request: NSMutableURLRequest!, completionHandler:(data:NSData?, response:NSURLResponse?, error:NSError?) -> Void) {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue:customQueue)
        let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
        task.resume()
    }
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge,
        completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void)
    {
        completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!))
    }
    
    
}