//
//  UTPlainTableRowView.swift
//  UIToolkit
//
//  Created by James Nestor on 10/06/2021.
//

import Cocoa

public class UTPlainTableRowView : NSTableRowView{
    
    public class func makeWithIdentifier(_ tableView: NSTableView, rowIdentifier:String, owner: Any?) -> UTPlainTableRowView {
        
        let identifier = NSUserInterfaceItemIdentifier(rawValue: rowIdentifier)
        if let rowView = tableView.makeView(withIdentifier: identifier, owner: owner) as? UTPlainTableRowView {
            return rowView
        }
        
        let rowView = UTPlainTableRowView(frame: NSZeroRect)
        rowView.identifier = identifier
        
        return rowView
    }
}
