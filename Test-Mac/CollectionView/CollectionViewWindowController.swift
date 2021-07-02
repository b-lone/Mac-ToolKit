//
//  CollectionViewWindowController.swift
//  Test-Mac
//
//  Created by Archie You on 2021/6/29.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class CollectionViewWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
}

extension CollectionViewWindowController: NSCollectionViewDelegate {
    
}

extension CollectionViewWindowController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        return NSCollectionViewItem()
    }
}
