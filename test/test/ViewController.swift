//
//  ViewController.swift
//  test
//
//  Created by 小海 on 13/03/2018.
//  Copyright © 2018 Xiaohai Sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "celltimer",for:indexPath as IndexPath) as UITableViewCell
        return cell
    }
}

