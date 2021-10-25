//
//  TestPopoverList.swift
//  ComponentApp
//
//  Created by James Nestor on 28/05/2021.
//

import Cocoa
import UIToolkit

class TestPopoverList: NSViewController {

    var popoverListVC:UTPopoverListTableVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popoverListVC = UTPopoverListTableVC()
        if let v = popoverListVC?.view{
            self.view.setAsOnlySubviewAndFill(subview: v)            
        }
        
        
        var data:[UTListItem] = []
        
        data.append(UTListItemData(icon: .editRegular, title:"Edit space settings"))
        data.append(UTListItemData(icon: .alertRegular, title:"Notifications"))
        data.append(UTListItemData(icon: nil, title:"Availability"))
        
        data.append(UTListItemData(icon: nil, title:"Set a status"))
        data.append(UTListItemData(icon: nil, title:"Mobile download"))
        data.append(UTListItemData(icon: .appsFilled, title:"Custom web page", iconColorToken: .tabGold))
        
        
        data.append(UTListItemData(icon: .announcementRegular , title:"Announcemnets"))
        data.append(UTListItemData(icon: .secureLockRegular, title:"Lock space"))
        data.append(UTListItemSeparator())
        data.append(UTListItemData(icon: nil, title:"Show favourites on top", isChecked: true))
        data.append(UTListItemData(icon: nil, title:"Separate DMs and Spaces", isChecked: true))
        
        popoverListVC?.delegate = self
        popoverListVC?.setDataSource(data: data)
    }
    
    @IBAction func tableMenuItemAction(_ sender:Any) {
        NSLog("actioned menu item from context menu")
    }
}

extension TestPopoverList: UTPopoverListTableVCDelegate{
    
    func rightClickMenu(sender: UTTableView, listItem: UTListItem, row: Int, parentMenu: NSMenu) {
        
        if let _ = listItem as? UTListItemData {
            //Cast data tag to the type and use it to build menu items
            
            parentMenu.addItem(NSMenuItem(title: "Menu Item row: " + String(row), action: #selector(TestPopoverList.tableMenuItemAction), keyEquivalent: ""))
            parentMenu.addItem(NSMenuItem(title: "Menu Item row: " + String(row), action: #selector(TestPopoverList.tableMenuItemAction), keyEquivalent: ""))
            parentMenu.addItem(NSMenuItem(title: "Menu Item row: " + String(row), action: #selector(TestPopoverList.tableMenuItemAction), keyEquivalent: ""))
        }
        
        //Adding no items to the parent menu prevents menu from opening
    }
    
    func invokeActionForListItem(listItem: UTListItemData, index: Int) {
        popoverListVC?.updateListItemChecked(isChecked: !listItem.isChecked, index: index)
    }
    
}

