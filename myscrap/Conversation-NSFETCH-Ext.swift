//
//  Conversation-NSFETCH-Ext.swift
//  myscrap
//
//  Created by MS1 on 11/7/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
import CoreData

/*

extension ConversationVC : NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            blockOperations.append(BlockOperation(block: {
                self.collectionView.insertItems(at: [newIndexPath!])
            }))
        case .update:
            blockOperations.append(BlockOperation(block: {
                if let ip = indexPath{
                    if let cell = self.collectionView.cellForItem(at: ip) as? SenderCell{
                        self.configSender(cell: cell, indexPath: ip)
                    }
                    if let cell = self.collectionView.cellForItem(at: ip) as? ReceiverCell{
                        self.configReceiver(cell: cell, indexpath: ip)
                    }
                    if let cell = self.collectionView.cellForItem(at: ip) as? SenderImageCell{
                        self.configSenderImage(cell: cell, indexPath: ip)
                    }
                    if let cell = self.collectionView.cellForItem(at: ip) as? ReceiverImageCell{
                        self.configReceiverImage(cell: cell, indexPath: ip)
                    }
                    self.collectionView.reloadItems(at: [ip])
                }
            }))
        default:
            blockOperations.append(BlockOperation(block: {
                self.collectionView.reloadData()
            }))
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates({
            for operation in self.blockOperations{
                operation.start()
            }
        }) { (completed) in
            self.collectionView.reloadData()
            let lastItem = self.fetchedResultsController.sections![0].numberOfObjects - 1
            let indexPath = IndexPath(item: lastItem, section: 0)
            //: Scroll to the new message that is being entered
            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
}

*/
