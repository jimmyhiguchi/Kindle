//
//  BookPagerController.swift
//  Kindle
//
//  Created by Jimmy Higuchi on 10/8/17.
//  Copyright © 2017 Jimmy Higuchi. All rights reserved.
//

import UIKit

// CollectionView is used to show multiple levels
// note: UICollectionViewDelegateFlowLayout needed to adjust size of collection view cells
class BookPagerController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // created to pass selectedBooks from ViewController
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        navigationItem.title = book?.title
        
        //must register cellId with UICollectionViewCell class
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        
        //downcast UICollectionViewFlowLayout to access scroll direction
        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        
        layout?.minimumLineSpacing = 0
        layout?.scrollDirection = .horizontal
        
        //pages now snap to edge of screen
        collectionView?.isPagingEnabled = true
        
        //adding Close button
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Close", style: .plain, target: self, action: #selector (handleCloseBook))
    }
    
    // Close button in navigation bar
    @objc func handleCloseBook() {
        dismiss(animated: true, completion: nil)
    }
    // resize the collection view cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //view.frame.width/height is the size of the screen
        //note: height -20 -44 is height of status + navigation bar
        return CGSize(width: view.frame.width, height: view.frame.height - 20 - 64)
    }
    
    // number of pages per book
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // if no value returned .count then return 0
        return book?.pages.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell  {
        let pageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PageCell
        
        // .item for collectionview .row for tableview
        let page = book?.pages[indexPath.item]
        pageCell.textLabel.text = page?.text

        
        return pageCell
    }
    
}

