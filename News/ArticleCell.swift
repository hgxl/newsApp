//
//  ArticleCell.swift
//  News
//
//  Created by Henri Gil on 28/01/2018.
//  Copyright © 2018 Henri Gil. All rights reserved.
//

import UIKit
import AlamofireImage
import ChameleonFramework

class ArticleImageCell: ArticleCell {
    
   override var article: Article  {
        didSet{
            if let url =  URL(string: article.urlToImage){
                image_article.af_setImage(withURL: url)
            }
        }
    }
    
    
    
    let image_article: UIImageView = {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints=false
        i.contentMode = .scaleAspectFill
        i.layer.masksToBounds=true
        i.backgroundColor = .flatBlack
        return i
    }()
    
    override func initialize(){
        super.initialize()
        containerView.addSubview(image_article)
    }
    
    override func setupLayout(){
        
        let heightImage = (UIScreen.main.bounds.width*9)/16

        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            
            title_article.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            title_article.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            title_article.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            
            description_article.topAnchor.constraint(equalTo: title_article.bottomAnchor, constant: 5),
            description_article.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant:8),
            description_article.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            
            image_article.topAnchor.constraint(equalTo: description_article.bottomAnchor, constant: 5),
            image_article.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            image_article.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            image_article.heightAnchor.constraint(equalToConstant: heightImage.rounded()),
            
            date_article.topAnchor.constraint(equalTo: image_article.bottomAnchor, constant: 10),
            date_article.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5),
            date_article.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5),
            
            source_article.topAnchor.constraint(equalTo: image_article.bottomAnchor, constant: 10),
            source_article.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5),
            source_article.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5),
            source_article.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
            
            ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image_article.image = nil
    }
    
}



class ArticleCell: UITableViewCell {

    
    var article: Article = Article(data: [:], source: nil) {
        didSet{
            
            title_article.text = article.title
            description_article.text = article.description
            date_article.text = article.publishedAt
            
            if let source = article.source?.name {
                source_article.text = "Source: "+source
            }else {
                source_article.text = "Source: Unknown"
            }

        }
    }

    
    /*UI*/
    let containerView: UIView = {
    let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints=false
        v.backgroundColor = .flatBlack
        v.layer.cornerRadius = 2
        return v
    }()
    
    let title_article: UILabel =  {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints=false
        l.numberOfLines=0
        l.font = UIFont.boldSystemFont(ofSize: 14)
        l.textColor = UIColor.flatWhite
        return l
    }()
    
    let description_article: UILabel =  {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints=false
        l.numberOfLines=0
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = UIColor.flatWhite
        l.textAlignment = .justified
        return l
    }()
    
    
    let source_article: UILabel =  {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints=false
        l.numberOfLines=1
        l.font = UIFont.systemFont(ofSize: 9)
        l.textColor = UIColor.flatWhite
        return l
    }()
    
    let date_article: UILabel =  {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints=false
        l.numberOfLines=1
        l.font = UIFont.systemFont(ofSize: 9)
        l.textColor = UIColor.flatWhite
        l.textAlignment = .right
        return l
    }()
    /**/
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialize()
        setupLayout()
    }
    
    func initialize(){
        
        contentView.backgroundColor = .flatBlackDark
        contentView.addSubview(containerView)
        
        containerView.addSubview(title_article)
        containerView.addSubview(description_article)
        containerView.addSubview(source_article)
        containerView.addSubview(date_article)
    }
    
    func setupLayout(){
    
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            
            title_article.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            title_article.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            title_article.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            
            description_article.topAnchor.constraint(equalTo: title_article.bottomAnchor, constant: 5),
            description_article.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant:8),
            description_article.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
        
            date_article.topAnchor.constraint(equalTo: description_article.bottomAnchor, constant: 10),
            date_article.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5),
            date_article.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5),

            source_article.topAnchor.constraint(equalTo: description_article.bottomAnchor, constant: 10),
            source_article.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5),
            source_article.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5),
            source_article.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),

            ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
