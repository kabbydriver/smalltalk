//
//  User.swift
//  TestApp
//
//  Created by Kabir Gogia on 9/9/15.
//  Copyright (c) 2015 Kabir. All rights reserved.
//

import UIKit

typealias nameAndImage = (name: String, img: UIImage)
typealias idAndName = (id: String, name: String)
class User {
    
    var tokenString:String!
    var id:String!
    //metadata for user
    var places  = [idAndName]()
    var shows   = [idAndName]()
    var movies  = [idAndName]()
    var events  = [idAndName]()
    
    //raw data for user
    var placesPictures  = [nameAndImage]()
    var showsPictures   = [nameAndImage]()
    var moviesPictures  = [nameAndImage]()
    var eventsPictures  = [nameAndImage]()
    
    //basic info
    var image:UIImage?
    var coverPhoto:UIImage?
    var hometown:String?
    var first_name:String?
    var last_name:String?
    var gender:String?
    var religion:String?
    
    init(userID: String, token: String) {
        self.id = userID
        self.tokenString = token
        self.getMetaData()
        self.getRawData()
    }
    
    
    func getMetaData() {
        var downloadGroup = dispatch_group_create()
        
        dispatch_group_enter(downloadGroup)
        getTelevisionShows(&downloadGroup)

        dispatch_group_enter(downloadGroup)
        getMovies(&downloadGroup)
        
        dispatch_group_enter(downloadGroup)
        getTaggedPlaces(&downloadGroup)
        
        dispatch_group_enter(downloadGroup)
        getProfilePicture(&downloadGroup)
        
        dispatch_group_enter(downloadGroup)
        getCoverPhoto(&downloadGroup)
        
        dispatch_group_enter(downloadGroup)
        getBasicInfo(&downloadGroup)
        
        dispatch_group_enter(downloadGroup)
        getEvents(&downloadGroup)
        
        dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER)
        
    }
    
    func getEvents(inout downloadGroup: dispatch_group_t!) {
        let rest = Rest()
        let url = "https://graph.facebook.com/\(id)/events?access_token=\(tokenString)"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        rest.httpGet(request, completionHandler: { (data, response, error) -> Void in
            
            if let data = data {
                var response = (try! NSJSONSerialization.JSONObjectWithData(data, options: [])) as! [NSObject:AnyObject]
                let eventsArray = response["data"] as! [[NSObject:AnyObject]]
            
                for event in eventsArray {
                    let id = event["id"] as! String
                    let name = event["name"] as! String
                    self.events.append((id,name))
                }
            }
            dispatch_group_leave(downloadGroup)
        })
        
    }
    
    func getBasicInfo(inout downloadGroup: dispatch_group_t!) {
        let rest = Rest()
        let url = "https://graph.facebook.com/\(id)?fields=hometown,first_name,last_name,gender,religion&access_token=\(tokenString)"
        let request = NSMutableURLRequest(URL:NSURL(string: url)!)
        
        rest.httpGet(request, completionHandler: {(data, response, error) -> Void in
            
            if let data = data {
                var response = (try! NSJSONSerialization.JSONObjectWithData(data, options: [])) as! [NSObject:AnyObject]
        
                var hometown = response["hometown"] as? [NSObject:AnyObject]
                self.hometown = hometown?["name"] as? String
            
                self.first_name = response["first_name"] as? String
                self.last_name = response["last_name"] as? String
                self.gender = response["gender"] as? String
                self.religion = response["religion"] as? String
            
                dispatch_group_leave(downloadGroup)
            } else {
                self.getBasicInfo(&downloadGroup)
            }
        })
    }
    
    func getTelevisionShows(inout downloadGroup: dispatch_group_t!) {
        let rest = Rest()
        let url = "https://graph.facebook.com/\(id)?fields=television&access_token=\(tokenString)"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        rest.httpGet(request, completionHandler: { (data, response, error) -> Void in
            
            if let data = data {
                var response = (try! NSJSONSerialization.JSONObjectWithData(data, options: [])) as! [NSObject:AnyObject]
                if let television = response["television"] as? [NSObject:AnyObject] {
                    if let shows = television["data"] as? [[NSObject:AnyObject]] {
                        for show in shows {
                            let id = show["id"] as! String
                            let name = show["name"] as! String
                            self.shows.append((id,name))
                        }
                    }
                }
                dispatch_group_leave(downloadGroup)
            } else {
                self.getTelevisionShows(&downloadGroup)
            }
        })
    }
    
    func getMovies(inout downloadGroup: dispatch_group_t!) {
        let rest = Rest()
        let url = "https://graph.facebook.com/\(id)?fields=movies&access_token=\(tokenString)"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        rest.httpGet(request, completionHandler: { (data, response, error) -> Void in
            
            if let data = data {
                var response = (try! NSJSONSerialization.JSONObjectWithData(data, options: [])) as! [NSObject:AnyObject]
                if let items = response["movies"] as? [NSObject:AnyObject] {
                    if let movies = items["data"] as? [[NSObject:AnyObject]] {
                        for movie in movies {
                            let id = movie["id"] as! String
                            let name = movie["name"] as! String
                            self.movies.append((id,name))
                        }
                    }
                }
                dispatch_group_leave(downloadGroup)
            }
        })
    }
    
    func getTaggedPlaces(inout downloadGroup: dispatch_group_t!) {
        let rest = Rest()
        let url = "https://graph.facebook.com/\(id)?fields=tagged_places&access_token=\(tokenString)"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        rest.httpGet(request, completionHandler: { (data, response, error) -> Void in
            if let data = data {
                var response = (try! NSJSONSerialization.JSONObjectWithData(data, options: [])) as! [NSObject:AnyObject]
                if let places = response["tagged_places"] as? [NSObject:AnyObject] {
                    if let dataArray = places["data"] as? [[NSObject:AnyObject]] {
                        for key in dataArray {
                            if let place = key["place"] as? [NSObject:AnyObject] {
                                let id = place["id"] as! String
                                let name = place["name"] as! String
                                self.places.append((id,name))
                            }
                        }
                    }
                }
                dispatch_group_leave(downloadGroup)
            }
        })
    }
    
    func getProfilePicture(inout downloadGroup: dispatch_group_t!) {
        let rest = Rest()
        let url = "https://graph.facebook.com/\(id)/picture?type=large&access_token=\(tokenString)"
        let request = NSMutableURLRequest(URL: NSURL(string:url)!)
        
        rest.httpGet(request, completionHandler: { (data, response, error) -> Void in
            if let data = data {
                let image = UIImage(data: data)
                self.image = image
                dispatch_group_leave(downloadGroup)
            }
            
        })
    }
    
    func getCoverPhoto(inout downloadGroup: dispatch_group_t!) {
        let rest = Rest()
        let url = "https://graph.facebook.com/\(id)?fields=cover&access_token=\(tokenString)"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        rest.httpGet(request, completionHandler: { (data, response, error) -> Void in
            if let data = data {
                var response = (try! NSJSONSerialization.JSONObjectWithData(data, options: [])) as! [NSObject:AnyObject]
                var cover = response["cover"] as! [NSObject:AnyObject]
                let newURL = cover["source"] as! String
                let newRequest = NSMutableURLRequest(URL: NSURL(string: newURL)!)
                let newRest = Rest()
                newRest.httpGet(newRequest, completionHandler: { (data, response, error) -> Void in
                    let image = UIImage(data: data!)
                    self.coverPhoto = image
                })
                dispatch_group_leave(downloadGroup)
            }
        })
    }
    
    func getRawData() {
        
        let downloadGroup = dispatch_group_create()!
        
        for place in places {
            dispatch_group_enter(downloadGroup)
            idToImg(place.id, handler: { (data, response, error) -> Void in
                let image = UIImage(data: data!)!
                self.placesPictures.append((place.name, image))
                dispatch_group_leave(downloadGroup)
            })
        }
        
        for show in shows {
            dispatch_group_enter(downloadGroup)
            idToImg(show.id, handler: { (data, response, error) -> Void in
                let image = UIImage(data: data!)!
                self.showsPictures.append((show.name, image))
                dispatch_group_leave(downloadGroup)
            })
        }
        
        for movie in movies {
            dispatch_group_enter(downloadGroup)
            idToImg(movie.id, handler: { (data, response, error) -> Void in
                let image = UIImage(data: data!)!
                self.moviesPictures.append((movie.name, image))
                dispatch_group_leave(downloadGroup)
            })
        }
        
        for event in events {
            dispatch_group_enter(downloadGroup)
            idToImg(event.id, handler: { (data, response, error) -> Void in
                let image = UIImage(data: data!)
                self.eventsPictures.append((event.name, image!))
                dispatch_group_leave(downloadGroup)
            })
        }
    
        dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER)
    }

    func idToImg(id:String, handler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        let rest = Rest()
        let url = "https://graph.facebook.com/\(id)/picture?type=large&access_token=\(tokenString)"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        rest.httpGet(request, completionHandler: handler)
    }
    
    
}
