//
//  SelectUserVC.swift
//  SnapchatClone
//
//  Created by Manolescu Mihai Alexandru on 05/08/2017.
//  Copyright © 2017 Manolescu Mihai Alexandru. All rights reserved.
//

import UIKit

class SelectUserVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var usersTableView: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        usersTableView.dataSource = self
        usersTableView.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        return cell;
    }


}






