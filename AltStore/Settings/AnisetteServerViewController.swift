//
//  AnisetteServerViewController.swift
//  SideStore
//
//  Created by Nicholas Yoder on 12/18/22.
//  Copyright © 2022 SideStore. All rights reserved.
//

import UIKit

import AltStoreCore
import Roxas



class AnisetteServerViewController: UITableViewController
{
    @IBOutlet var anisetteServers: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        self.prepareServers()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    func prepareServers() -> UIMenu {
        var menuItems: [UIAction] = []
        for server in AnisetteManager.publicServers {
            let action = UIAction(title: server.label, identifier: UIAction.Identifier(server.urlString), handler: { (_) in })
            if action.title == "Sideloadly" {
                action.attributes = .destructive
            }
            menuItems.append(action)
        }
        var anisetteMenu: UIMenu {
            return UIMenu(title: "Anisette Servers", image: nil, identifier: nil, options: [], children: menuItems)
        }
        
        return anisetteMenu
    }
}

extension AnisetteServerViewController
{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if indexPath[1] == 2 {
            
        }
    }
}
