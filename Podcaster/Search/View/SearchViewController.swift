//
//  SearchViewController.swift
//  Podcaster
//
//  Created by Coupang on 2018. 1. 4..
//  Copyright © 2018년 Byoungho. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBarTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dimmedView: UIView!
    @IBOutlet weak var searchCancelButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let buttonWidth: CGFloat = 42
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(tapGestureRecognizer)
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func didDimmedViewTapped(_ sender: Any) {
        stopSearch()
    }
    
    func startSearch() {
        if let navigationBar = navigationController?.navigationBar {
            dimmedView.isHidden = false
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.layoutSubviews, .showHideTransitionViews], animations: {
                let searchBarBounds = self.searchBar.bounds
                let searchBarCenter = self.searchBar.center
                let buttonWidth = self.buttonWidth
                let searchCancelButtonCenter = self.searchCancelButton.center
                
                navigationBar.center = CGPoint(x: navigationBar.center.x, y: -navigationBar.center.y)
                navigationBar.alpha = 0.0
                self.searchBar.bounds = CGRect(x: searchBarBounds.origin.x, y: searchBarBounds.origin.y, width: searchBarBounds.width - buttonWidth, height: searchBarBounds.height)
                self.searchBar.center = CGPoint(x: searchBarCenter.x - buttonWidth / 2, y: searchBarCenter.y - navigationBar.bounds.height)
                self.searchCancelButton.center = CGPoint(x: searchCancelButtonCenter.x - buttonWidth, y: searchCancelButtonCenter.y - navigationBar.bounds.height)
                self.dimmedView.alpha = 0.5
                self.dimmedView.center = CGPoint(x: self.dimmedView.center.x, y: self.dimmedView.center.y - navigationBar.bounds.height)
            }) { _ in
                navigationBar.isHidden = true
                self.searchBarTrailingConstraint.constant = self.buttonWidth
            }
        }
        
    }
    
    func stopSearch() {
        searchBar.resignFirstResponder()
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.isHidden = false
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.layoutSubviews, .showHideTransitionViews], animations: {
                navigationBar.center = CGPoint(x: navigationBar.center.x, y: -navigationBar.center.y)
                navigationBar.alpha = 1.0
                let searchBarBounds = self.searchBar.bounds
                let searchBarCenter = self.searchBar.center
                let buttonWidth = self.buttonWidth
                let searchCancelButtonCenter = self.searchCancelButton.center
                self.searchBar.bounds = CGRect(x: searchBarBounds.origin.x, y: searchBarBounds.origin.y, width: searchBarBounds.width + buttonWidth, height: searchBarBounds.height)
                self.searchBar.center = CGPoint(x: searchBarCenter.x + buttonWidth / 2, y: searchBarCenter.y + navigationBar.bounds.height)
                self.searchCancelButton.center = CGPoint(x: searchCancelButtonCenter.x + buttonWidth, y: searchCancelButtonCenter.y + navigationBar.bounds.height)
                self.dimmedView.center = CGPoint(x: self.dimmedView.center.x, y: self.dimmedView.center.y + navigationBar.bounds.height)
                self.dimmedView.alpha = 0.0
            }) { _ in
                self.searchBarTrailingConstraint.constant = 0
                self.dimmedView.isHidden = true
                self.searchBar.resignFirstResponder()
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func didCancelButtonTapped(_ sender: Any) {
        stopSearch()
    }
}


extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        startSearch()
    }
}
