//
//  CardViewController.swift
//  TestApp
//
//  Created by Kabir Gogia on 9/17/15.
//  Copyright (c) 2015 Kabir. All rights reserved.
//

import UIKit

extension UICollectionViewFlowLayout {
    
    func deepCopy() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.itemSize
        layout.sectionInset = self.sectionInset
        layout.minimumLineSpacing = self.minimumLineSpacing
        layout.scrollDirection = self.scrollDirection
        return layout
    }
    
}

class CardViewController: UIViewController {

    var user: User!
    
    var coverPhotoView: UIImageView!
    var pfpImageView: UIImageView!
    var infoLabel: UILabel!

    var movieCollectionController: TestCollectionViewController!
    var placesCollectionController: TestCollectionViewController!
    var eventsCollectionController: TestCollectionViewController!
    var layout: UICollectionViewFlowLayout!
    
    convenience init(user: User) {
        self.init()
        self.user = user
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.borderColor = UIColor.blackColor().CGColor
        self.view.layer.borderWidth = 1
        
        layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        
        addCoverPhotoView()
        addPfpView()
        addInfoLabel()
        
        addMovieCollectionController()
        addPlacesCollectionController()
        addEventsCollectionController()
    
    
    }
    
    func updateUser(user: User) {
        self.user = user
        addCoverPhotoView()
        addPfpView()
        addInfoLabel()
        addMovieCollectionController()
        addPlacesCollectionController()
        addEventsCollectionController()
    }
    
    func addCoverPhotoView() {
        
        if coverPhotoView == nil {
            coverPhotoView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 140))
            coverPhotoView!.image = user.coverPhoto
            self.view.addSubview(coverPhotoView)
            return
        }
        
        coverPhotoView.image = user.coverPhoto
        
    }
    
    func addPfpView() {
        
        if pfpImageView == nil {
            pfpImageView = UIImageView(frame: CGRect(x: 25, y: 25, width: 100, height: 100))
            pfpImageView.layer.cornerRadius = pfpImageView.frame.width/2
            pfpImageView.layer.borderColor = UIColor.whiteColor().CGColor
            pfpImageView.layer.borderWidth = 1
            pfpImageView.clipsToBounds = true
            pfpImageView.image = user.image
            self.view.addSubview(pfpImageView)
            return
        }

        pfpImageView.image = user.image!
    }

    func addInfoLabel() {
        
        if infoLabel == nil {
            infoLabel = UILabel(frame: CGRect(x: 0, y: 140, width: self.view.frame.width, height: 20))
            infoLabel.font = UIFont(name: "Helvetica", size: 12)
            infoLabel.textColor = UIColor.lightGrayColor()
            infoLabel.textAlignment = NSTextAlignment.Center
            infoLabel.text = "\(user.first_name!) \(user.last_name!) | \(user.hometown!)"
            self.view.addSubview(infoLabel)
            return

        }
        infoLabel.text = "\(user.first_name!) \(user.last_name!) | \(user.hometown!)"
    }
    
    func addMovieCollectionController() {
        
        if movieCollectionController == nil {
            movieCollectionController = TestCollectionViewController(collectionViewLayout: layout, data: user.moviesPictures + user.showsPictures)
            movieCollectionController.view.frame = CGRect(x: 0, y: 180, width: self.view.frame.width, height: 120)
            self.view.addSubview(movieCollectionController.view)
            return
        }
        
        movieCollectionController.updateData(user.moviesPictures + user.showsPictures)
    }
    
    func addPlacesCollectionController() {
        
        if placesCollectionController == nil {
            placesCollectionController = TestCollectionViewController(collectionViewLayout: layout.deepCopy(), data: user.placesPictures)
            placesCollectionController.view.frame = CGRect(x: 0, y: 320, width: self.view.frame.width, height: 120)
            self.view.addSubview(placesCollectionController.view)
            return
        }
        
        placesCollectionController.updateData(user.placesPictures)
    }
    
    func addEventsCollectionController() {
        
        if eventsCollectionController == nil {
            eventsCollectionController = TestCollectionViewController(collectionViewLayout: layout.deepCopy(), data: user.eventsPictures)
            eventsCollectionController.view.frame = CGRect(x: 0, y: 460, width: self.view.frame.width, height: 120)
            self.view.addSubview(eventsCollectionController.view)
        }
        
        eventsCollectionController.updateData(user.eventsPictures)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
