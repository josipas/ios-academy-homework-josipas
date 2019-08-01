//
//  CommentsViewController.swift
//  TVShows
//
//  Created by Infinum on 01/08/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

final class CommentsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var episodeId = ""
    private var comments : [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        title = "Comments"
        setUpUI()
    }
}

private extension CommentsViewController {
    func setUpUI() {
        tableView.delegate = self 
        tableView.dataSource = self
        
        getComments()
        
        let navigationBar = navigationController?.navigationBar
        navigationBar?.barTintColor = .white
        navigationBar?.isTranslucent = false
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
        
        let backItem = UIBarButtonItem.init(
            image: UIImage(named: "ic-navigate-back"),
            style: .plain,
            target: self,
            action: #selector(navigateToEpisodeDetails))
        navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func navigateToEpisodeDetails() {
        self.presentingViewController?.dismiss(animated: true, completion:nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    func getComments() {
        guard let login = Storage.shared.loginUser else { return }
        SVProgressHUD.show()
        let headers = ["Authorization": login.token]
        Alamofire
            .request(
                "https://api.infinum.academy/api/episodes/\(episodeId)/comments",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self](response: DataResponse<[Comment]>) in
                SVProgressHUD.dismiss()
                guard let self = self else { return }
                switch response.result {
                case .success(let comments):
                    print("Succes: \(comments)")
                    self.comments = comments
                    self.tableView.reloadData()
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
}

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as! CommentsTableViewCell
        cell.configure(with: comments[indexPath.row])
        return cell
    }
}

extension CommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

