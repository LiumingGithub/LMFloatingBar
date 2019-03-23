//
//  SettingViewController.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/19.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import LMTransitionKit
import LMFloatingBar

class SettingViewController: UITableViewController {
    struct Constant {
        static let section1: [(String, FloatingKeeperPopTransation.UponAnimationType)] = [("fromRight", .fromRight), ("fromLeft", .fromLeft)]
        
        static let section2: [(String, FrameAniTransitionProducer.UnderAnimationType)] = [("none", .none), ("crowd", .crowd), ("pushed", .pushed), ("squeezed", .squeezed)]
    }
    
    var control: FloatingKeeperControl?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let control = navigationController?.delegate as? FloatingKeeperControl
          else {
            navigationController?.popViewController(animated: false)
            return
        }
        self.control = control
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let producer = control?.floatingTransitionProducer else { return }

        switch indexPath.section {
        case 0:
            let data = Constant.section1[indexPath.row]
            cell.textLabel?.text = data.0
            if data.1 == producer.uponAnimationType {
                cell.accessoryType = .checkmark
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        default:
            let data = Constant.section2[indexPath.row]
            cell.textLabel?.text = data.0
            if data.1 == producer.underAnimationType {
                cell.accessoryType = .checkmark
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        tableView.indexPathsForSelectedRows!.filter{ $0.section == indexPath.section && $0 != indexPath}.forEach {
            tableView.deselectRow(at: $0, animated: true)
            tableView.cellForRow(at: $0)!.accessoryType = .none
        }
    }
    
    @IBAction func applyAnimationSettings(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows,
            let producer = control?.floatingTransitionProducer {
            let seleted1 = selectedRows.filter({$0.section == 0}).first!.row
            let selected2 = selectedRows.filter({$0.section == 1}).first!.row
            producer.uponAnimationType = Constant.section1[seleted1].1
            producer.underAnimationType = Constant.section2[selected2].1
        }
    }
}


