//
//  ViewController.swift
//  Kindle
//
//  Created by Jimmy Higuchi on 10/3/17.
//  Copyright © 2017 Jimmy Higuchi. All rights reserved.
//

import UIKit



class ViewController: UITableViewController {
    
    var allBooks: [Book]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarStyle()
        setupNavigationBarButtons()

        navigationItem.title = "Kindle"
        
        // BookCell is a customized subclass of UITableViewCell
        tableView.register(BookCell.self, forCellReuseIdentifier: "cellId")
        
        //remove additional cells
        tableView.tableFooterView = UIView()
        
        tableView.backgroundColor = UIColor(white: 0.7, alpha: 0.3)
        
        
        fetchJSONBooks()
    }
    
    // navigation bar style
    func setupNavigationBarStyle() {
        
        // turns the navibar black
        navigationController?.navigationBar.barTintColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        // changing title font color to white
        // note: changing status bar color is in AppDelegate
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        }
    
    //note: .withRenderingMode(.alwaysOriginal) will change menu from blue to actual color of image
    func setupNavigationBarButtons() {
        
        // left menu button
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuPress))
        
        // right amazon icon
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "amazon_icon-2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAmazonPress))
    }
    
    @objc func handleMenuPress() {
        print("Menu bar button pressed")
    }
    
    @objc func handleAmazonPress() {
        print("Amazon bar button pressed")
    }
    
    // getting JSON data
    func fetchJSONBooks() {
        
        print("Fetching books....")
        
        if let url = URL(string: "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/kindle.json") {
        
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                // always check "error" in the completion handler
                if let err = error {
                    print("Error parsing JSON data: ", err)
                    return
                }
                
                // safely unwrap "data" from completion handler
                // note: dataAsString will operate in the background and execute later
                guard let data = data else {return}
                
                // start parsing JSON data
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    
                    //
                    let bookDictionaries = json as? [[String: Any]]
                    
                    // why do we have to initialize this with an empty array???
                    self.allBooks = []
                    
                    for bookDictionary in bookDictionaries! {
                        
                        let book = Book(dictionary: bookDictionary)
                        
                        self.allBooks?.append(book)
                        
                        }
                    
                    // reload view on the main thread????
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    
                // parsing error handling
                } catch let jsonError {
                    print("Failed to parse JSON data", jsonError)
                }
                
            }).resume()
            
        }
    }
    
    // adding footer
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView()
        
        // changing the background color of footer
        footerView.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        
        
        // add segmented controllers to footer
        let segmentedControl = UISegmentedControl(items: ["Cloud","Device"])
        footerView.addSubview(segmentedControl)
        
        // needed to apply constraints
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        // change color to white
        segmentedControl.tintColor = .white
        // default select "Cloud"
        segmentedControl.selectedSegmentIndex = 0
        
        // adjusting size and placement of segmented controllers
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        segmentedControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
        // center segmented controllers
        segmentedControl.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        
        // adding buttons to footer
        let gridButton = UIButton(type: .system)
        gridButton.setImage(#imageLiteral(resourceName: "grid").withRenderingMode(.alwaysOriginal), for: .normal)
        gridButton.translatesAutoresizingMaskIntoConstraints = false
        
        // note: must add subview before constraints
        footerView.addSubview(gridButton)
        
        // contraints for grid button
        gridButton.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 8).isActive = true
        gridButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        gridButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        gridButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        // adding buttons to footer
        let sortButton = UIButton(type: .system)
        sortButton.setImage(#imageLiteral(resourceName: "sort").withRenderingMode(.alwaysOriginal), for: .normal)
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        
        // note: must add subview before constraints
        footerView.addSubview(sortButton)
        
        // contraints for sort button
        sortButton.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -8).isActive = true
        sortButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        sortButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sortButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    // didSelectRowAt calls action to cell selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedBook = allBooks?[indexPath.row]
        
        let layout = UICollectionViewFlowLayout()
        let bookPageController = BookPagerController(collectionViewLayout: layout)
        
        // adding navigation bar for collection
        let navController = UINavigationController(rootViewController: bookPageController)
        present(navController, animated: true, completion: nil)
        
        // send selectedBook to bookPageController
        bookPageController.book = selectedBook
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = allBooks?.count {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! BookCell
        
        let book = allBooks?[indexPath.row]
        cell.book = book
        return cell
    
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
 
// static function created to test initial setup.
//    func setupBooks() {
//        let page1 = Page(number: 1, text: "This is first book first page.")
//        let page2 = Page(number: 2, text: "This is first book second page.")
//
//        let pages = [page1, page2]
//
//        let book1 = Book(title: "Steve Jobs", author: "Walter Isaacson", image: #imageLiteral(resourceName: "steve_jobs"),pages: pages)
//
//        // video 2 if statements and for loops
//        let book2 = Book(title: "Bill Gates: A Biography", author: "Michael Becraft", image: #imageLiteral(resourceName: "bill_gates"),pages: [
//            Page(number: 1, text: "Second book first page"),
//            Page(number: 2, text: "Second book second page"),
//            Page(number: 3, text: "Second book third page"),
//            Page(number: 4, text: "Second book fourth page")
//            ])
    
//        allBooks = [book1, book2]
//         challenge to print all the pages in the first and second book
//         lesson 3 optionals. Safely unwrap optional
//
//         optional binding if let method
//                if let unwrappedBook = allBooks {
//                    for book in unwrappedBook {
//                        print(book.title)
//                        for page in book.pages {
//                            print(page.text)
//                        }
//                    }
//                }
//        
//         unwrapping using guard statement
//        guard let unwrappedBook = allBooks else {return}
//        for book in unwrappedBook {
//            print(book.title)
//            for page in book.pages {
//                print(page.text)
//            }
//        }
//    }

}

