//
//  ViewController.swift
//  Example
//
//  Created by 刘明 on 2019/3/11.
//  Copyright © 2019 刘明. All rights reserved.
//

import LMFloatingBar

extension UITableView {
    public func dequeueReusableCell<T>(
        _ Type: T.Type,
        style: UITableViewCell.CellStyle = .default,
        reuseIdentifier: String) -> T where T: UITableViewCell {
        return (dequeueReusableCell(withIdentifier: reuseIdentifier) as? T ) ?? T.init(style: style, reuseIdentifier: reuseIdentifier)
    }
}

class ViewController: UITableViewController {
    struct Constant {
        struct Segue {
            static let NoInteractive         = "NoInteractive"
            static let Interactive           = "Interactive"
            static let FloatingAble          = "FloatigAble"
        }
        static let data = DefaultCellData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.rowHeight = 100
    }
    
    //MARK: - Tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let flag = "main.cells"
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, reuseIdentifier: flag)
        cell.textLabel?.text = Constant.data[indexPath.row].title
        cell.imageView?.image = Constant.data[indexPath.row].image.imageForFloatingBar
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.data[indexPath.row].title, sender: nil)
    }
}

extension ViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.title = segue.identifier
        guard let selectedIndex = tableView.indexPathForSelectedRow,
            let viewController = segue.destination as? NextViewController else {
                return
        }
        
        viewController.imageView.image = Constant.data[selectedIndex.row].image.backgroundImage
        
        if let keepable = segue.destination as? FloatingAbleViewController {
            if let image = Constant.data[selectedIndex.row].image.imageForFloatingBar {
                keepable.floatingBarImage = image
            } else {
                keepable.title = "\(segue.identifier!)(default image)"
            }
        }
    }
}
