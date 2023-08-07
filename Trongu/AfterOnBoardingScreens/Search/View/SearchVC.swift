//
//  SearchVC.swift
//  Trongu
//
//  Created by apple on 29/06/23.
//

import UIKit

class SearchVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchTableView.register(UINib(nibName: "SearchTVCell", bundle: nil), forCellReuseIdentifier: "SearchTVCell")
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        updateCrossButtonVisibility()
    }
    func updateCrossButtonVisibility() {
        crossButton.isHidden = false
        crossButton.isHidden = searchTF.text?.isEmpty ?? true
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func crossAction(_ sender: UIButton) {
        searchTF.text = ""
        crossButton.isHidden = true
    }
}
extension SearchVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTVCell", for: indexPath) as! SearchTVCell
        if indexPath.row == 0 {
            cell.locationView.isHidden = true
        }
        return cell
    }
    
    
}
