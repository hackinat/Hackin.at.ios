//
//  ProfileViewController.swift
//  Github Auth
//
//  Created by Prateek on 11/10/14.
//  Copyright (c) 2014 Prateek. All rights reserved.
//

import UIKit
import Alamofire
import PureLayout

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    
    @IBOutlet weak var basicInfoView: UIView!
    @IBOutlet weak var metaInfoView: UIView!
    @IBOutlet weak var tableHeaderView: UIView!
    
    @IBOutlet weak var reposCountLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var stickersLabel: UILabel!

    @IBOutlet weak var friendsLabel: UILabel!
    
    var hacker:Hacker!
    var friends: [Hacker]!
    var friendsListing: HackersListingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        clearPlaceholderLabels()
        setupStyles()
        setupLoggedInUser()
        populateBasicInfo()
        renderUserDetails()
        fetchFriends()
        setupTitle()
    }
    
    func setupTable(){
        friendsListing = HackersListingView(cellStyle: HackerTableCell.FullView.self)
        friendsListing.hackersTableView.tableHeaderView = tableHeaderView
        view.addSubview(friendsListing)
    }
    
    func setupTitle(){
        self.title = "@\(hacker.login)"
    }
    
    func clearPlaceholderLabels(){
        stickersLabel.text = ""
    }
    
    @IBAction func followButtonPressed(sender: AnyObject) {
        println("so you want to follow huh!")
    }
    
    func setupLoggedInUser(){
        if self.hacker == nil {
            self.hacker = CurrentHacker.hacker()!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderUserDetails(){
        if(hacker.hasFullProfile()){
            renderFullProfile()
        }else{
            hacker.fetchFullProfile(success: renderFullProfile)
        }
    }

    func fetchFriends(){
        
        func onFetch(friends: [Hacker]){
            self.friends = friends
            renderFriends()
        }
        
        hacker.fetchFriends(success: onFetch)
        
    }
    
    func renderFriends(){
        friendsLabel.text = "Friends (\(friends.count))"
        friendsListing.renderHackers(friends)
        updateViewConstraints()
    }
    
    func setupStyles(){
        profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
        profileImage.clipsToBounds = true;
        
        basicInfoView.backgroundColor = AppColors.profileBgColor
        metaInfoView.backgroundColor = AppColors.profileBgColor
    }
    
    override func updateViewConstraints() {
        
        let inset = AppTheme.Listing.elementsPadding/2.0
        friendsListing.autoPinEdgesToSuperviewMargins()
        
        basicInfoView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(inset, inset, 0, inset), excludingEdge: ALEdge.Bottom)
        
        profileImage.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(inset, inset, inset, inset), excludingEdge: ALEdge.Right)
        
        loginLabel.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Right,
            ofView: profileImage, withOffset: AppTheme.Listing.elementsPadding)
        loginLabel.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Top, ofView: profileImage)
        
        nameLabel.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Right, ofView: profileImage, withOffset: AppTheme.Listing.elementsPadding)
        nameLabel.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: loginLabel, withOffset: AppTheme.Listing.elementsPadding)

        companyLabel.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Right, ofView: profileImage, withOffset: AppTheme.Listing.elementsPadding)
        companyLabel.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: nameLabel, withOffset: AppTheme.Listing.elementsPadding)
        companyLabel.autoPinEdgeToSuperviewEdge(ALEdge.Bottom)
        
        metaInfoView.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: basicInfoView, withOffset: AppTheme.Listing.elementsPadding)
        metaInfoView.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: AppTheme.Listing.elementsPadding)
        metaInfoView.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: AppTheme.Listing.elementsPadding)
        
        stickersLabel.autoPinEdgeToSuperviewEdge(ALEdge.Top)
        stickersLabel.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: AppTheme.Listing.elementsPadding)
        
        reposCountLabel.autoPinEdgeToSuperviewEdge(ALEdge.Top)
        reposCountLabel.autoPinEdgeToSuperviewEdge(ALEdge.Left)
        reposCountLabel.autoPinEdgeToSuperviewEdge(ALEdge.Bottom)

        friendsLabel.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: metaInfoView)
        friendsLabel.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: metaInfoView, withOffset: AppTheme.Listing.elementsPadding)
        
        // Without this the header height will be 0
        friendsLabel.autoPinEdgeToSuperviewEdge(ALEdge.Bottom)
        
        
     //   friendsListing.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: friendsLabel)
     //   friendsListing.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: friendsLabel, withOffset: AppTheme.Listing.elementsPadding)
     //   friendsListing.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: AppTheme.Listing.elementsPadding)
     //   friendsListing.autoPinEdgeToSuperviewEdge(ALEdge.Bottom)
        
        super.updateViewConstraints()
    }
    
    func renderFullProfile(){
        
        var userDetails = hacker.userDetails!

        var avatarURL = userDetails["avatar_url"].string
        
        // Personal Info
        nameLabel.text = userDetails["name"].string
        companyLabel.text = userDetails["company"].string
        
        // Counts
        var reposCount = userDetails["github_repos"].int!
        
        println(reposCount)
        println(reposCount)
        
        reposCountLabel.text = "\(reposCount) Repos"
        
        Alamofire.request(.GET, avatarURL!)
            .response{ (_, _, data, _) in
                self.profileImage.image = UIImage(data: (data as NSData) )
        }
        
        stickersLabel.font = UIFont(name: "pictonic", size: 20)
        stickersLabel.text = hacker.stickerCodes()
        
    }
    
    func populateBasicInfo(){
        loginLabel.text = "@\(hacker.login)"
    }
    
}