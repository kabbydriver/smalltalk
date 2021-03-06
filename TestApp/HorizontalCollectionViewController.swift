//
//  HorizontalCollectionViewController.swift
//  
//
//  Created by Kabir Gogia on 9/16/15.
//
//

import UIKit

let reuseIdentifier = "Cell"

class HorizontalCollectionViewController: UICollectionViewController {
    
    
    var data:[(nameAndImage)]?
    
    convenience init(collectionViewLayout layout: UICollectionViewLayout, data:[(nameAndImage)]) {
        self.init(collectionViewLayout: layout)
        self.data = data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.delegate = self
        self.collectionView!.dataSource = self
        self.collectionView!.backgroundColor = UIColor.clearColor()
        self.collectionView!.alwaysBounceHorizontal = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreate
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return data?.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
    
//        cell.imageView?.image = data?[indexPath.row].img
//        cell.textLabel?.text = data?[indexPath.row].name
        
        
        let img = data?[indexPath.row].img
        cell.imageView?.image = img
        cell.imageView?.layer.cornerRadius = cell.imageView!.frame.width/2
        cell.imageView?.clipsToBounds = true
        
        cell.textLabel?.text = data?[indexPath.row].name
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        cell.textLabel?.textColor = UIColor.lightGrayColor()
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 12)
        
        
        return cell
    }
    
    func updateData(data: [nameAndImage]) {
        self.data = data
        self.collectionView?.reloadData()
    }

}
