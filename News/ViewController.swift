//
//  ViewController.swift
//  News
//
//  Created by Henri Gil on 28/01/2018.
//  Copyright © 2018 Henri Gil. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    let refreshControl = UIRefreshControl()

    lazy var tableView: UITableView = {
        let t = UITableView(frame: .zero)
        t.translatesAutoresizingMaskIntoConstraints = false
        t.register(ArticleCell.self, forCellReuseIdentifier: "Cell")
        t.register(ArticleImageCell.self, forCellReuseIdentifier: "CellImage")
        t.delegate = self
        t.dataSource = self
        t.estimatedRowHeight = 150.0
        t.rowHeight = UITableViewAutomaticDimension
        t.backgroundColor = .clear
        t.separatorColor = .clear
        t.separatorStyle = .none
        t.contentInset = UIEdgeInsetsMake(10, 0, 10, 0)
        return t
    }()
    
    var articles = [Article]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent=false
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        setupLayout()
        getData()
    }
    
   
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func initialize(){
        
        UIApplication.shared.statusBarStyle = .lightContent

        becomeFirstResponder()
        
        view.backgroundColor = UIColor.flatBlackDark
        navigationItem.title = "News"
        
        tableView.refreshControl = refreshControl
        view.addSubview(tableView)
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        let sortButton = UIBarButtonItem(title: "Sort", style: .done, target: self, action: #selector(sortHandler))
        
        
        navigationItem.leftBarButtonItem = sortButton

         NotificationCenter.default.addObserver(self, selector: #selector(notificationsHandler), name: Notification.Name("notificationTapped") , object: nil)
        
    }
    
    func setupLayout(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
    }
    
    var isSorted = false
    @objc func sortHandler(){
        
        if isSorted == false {
             articles = articles.sorted{$0.dateForm > $1.dateForm}
        } else {
             articles = articles.sorted{$0.dateForm < $1.dateForm}
        }
        
        isSorted = !isSorted
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = articles[indexPath.row]

        if article.urlToImage.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ArticleCell
            cell.article = article
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellImage", for: indexPath) as! ArticleImageCell
            cell.article = article
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        if let url = URL(string: article.url){
            let saf = SFSafariViewController(url: url)
            present(saf, animated: true, completion: nil)
        }
    }
}

extension ViewController {
    
    @objc func refreshData() {
    getData()
    }
    
    func getData(){
        
        let locale: Locale = Locale.current
        let country: String = locale.regionCode?.lowercased() ?? "fr"
        
        API.shared.request(url: "https://newsapi.org/v2/top-headlines", parameters: ["country" : country ]) { (articles) in
            self.articles = articles
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
}

extension ViewController {
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEventSubtype.motionShake) {
            
            let rand = Int( arc4random_uniform(UInt32(articles.count)) + 0 )
            let article = articles[rand]
            
            let notif1 = NotificationData()
            notif1.id = article.source?.id ?? "x"
            notif1.animationStyle = .left
            notif1.title = article.title
            notif1.message = article.description
            notif1.thumbnailUrl = "thumb"
            notif1.contentImage = article.urlToImage
            notif1.urlNews = article.url
            
            InAppNotification.shared.addNotification(notification: notif1)
            
        }
    }
    
}

extension ViewController {
    
    @objc func notificationsHandler(notif: Notification) {
        
        if let notification = notif.object as? NotificationData {
            print(notification.urlNews)
            
            if let url = URL(string: notification.urlNews){
                let saf = SFSafariViewController(url: url)
                present(saf, animated: true, completion: nil)
            }
            
        }
    }
    
}


