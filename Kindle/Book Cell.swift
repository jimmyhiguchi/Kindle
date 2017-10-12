//
//  Book Cell.swift
//  Kindle
//
//  Created by Jimmy Higuchi on 10/5/17.
//  Copyright © 2017 Jimmy Higuchi. All rights reserved.
//

import UIKit

// Formatting and laying out the cells
class BookCell: UITableViewCell {
    
    // Encapsulation - proper MVC. this class will handle the ????
    var book: Book? {
        didSet {
            titleLabel.text = book?.title
            authorLabel.text = book?.author
            
            // tableview background set to gray
            backgroundColor = .clear
            
            guard let coverImageUrl = book?.coverImageUrl else { return }
            guard let url = URL(string: coverImageUrl) else { return }
            
            // prevents old image from cell from reappearing
            coverImageView.image = nil
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let err = error {
                    print("Error: could not return URL image: ", err)
                }
                
                guard let imageData = data else { return }
                let image = UIImage(data: imageData)
                
                DispatchQueue.main.async {
                    self.coverImageView.image = image
                }
                
                
            }.resume()
        }
    }
    // creating layout for cell
    // note: () at end of block executes block
    // note: private does not allow viewcontroller to access variable. Proper MVC
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        // this line needed to implement autosizing
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        addSubview(coverImageView)
        // autolayout. Need .isActive = true to work
        coverImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        coverImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        coverImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        coverImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(titleLabel)
        //
        titleLabel.leftAnchor.constraint(equalTo: coverImageView.rightAnchor, constant: 8).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        
        addSubview(authorLabel)
        authorLabel.leftAnchor.constraint(equalTo: coverImageView.rightAnchor, constant: 8).isActive = true
        authorLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
