//
//  TechniqueCollectionViewController.swift
//  TechTrainer
//
//  Created by Mikael Olezeski on 7/9/17.
//  Copyright © 2017 Mikael Olezeski. All rights reserved.
//

import UIKit
import CoreData


class TechniqueViewController: UIViewController, AddCardViewDelegate {
    
    // Cards Setup
    fileprivate var techniqueCards: [NSManagedObject] = []
    fileprivate let reuseIdentifier = "TechniqueCardCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate let cardsPerRow: CGFloat = 2
    
    // IB Objects
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addCardView: AddCardView!
    @IBOutlet weak var addCardConstraint: NSLayoutConstraint!
    
    // Core Data
    var coreDataStack: CoreDataStack!
    
    
    override func viewDidLoad() {
    
        collectionView.delegate = self
        collectionView.dataSource = self
        addCardView.delegate = self
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "TechniqueCard")
        
        do {
            techniqueCards = try coreDataStack.mainContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        // Save this for deleting method
//        for techniqueCard in techniqueCards {
//            coreDataStack.mainContext.delete(techniqueCard)
//        }
//        do {
//            try coreDataStack.mainContext.save()
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
        
    }
    
    
    // AddCardView Delegate
    func moveAddCardView() {

        UIView.animate(withDuration: 1.0, animations: {
            
            [unowned self] in
        
            if (self.addCardView.addButton.currentTitle == "") {
                self.addCardConstraint.constant -= 300
                self.addCardView.addButton.setTitle("+", for: .normal)
                self.addCardView.cancelButton.setTitle("", for: .normal)
                self.addCardView.addTaskButton.setTitle("", for: .normal)
                self.view.layoutIfNeeded()
                
            }
                
            else {
                self.addCardView.techniqueNameField.text = nil
                self.addCardView.startingBPMField.text = nil
                self.addCardView.descriptionField.text = nil
                self.addCardConstraint.constant += 300
                self.addCardView.addButton.setTitle("", for: .normal)
                self.addCardView.cancelButton.setTitle("Cancel", for: .normal)
                self.addCardView.addTaskButton.setTitle("Add", for: .normal)
                self.view.layoutIfNeeded()
            }
        })
    }
    
    func addNewTask() {
        
        let techName = addCardView.techniqueNameField.text
        let startBPM = Int(addCardView.startingBPMField.text!)!
        let description = addCardView.descriptionField.text
        
        moveAddCardView()
        
       let entity = NSEntityDescription.entity(forEntityName: "TechniqueCard" ,
           in: coreDataStack.mainContext)!
        
        let card = NSManagedObject(entity: entity,
                                     insertInto: coreDataStack.mainContext)
        
        card.setValue(techName, forKey: "techniqueName")
        card.setValue(startBPM, forKey: "currentBPM")
        card.setValue(description, forKey: "techniqueDescription")
        
        do {
            try coreDataStack.mainContext.save()
            techniqueCards.append(card)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        collectionView.reloadData()
        
    }
    

}

// MARK: UICollectionViewDataSource
extension TechniqueViewController: UICollectionViewDataSource {
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return techniqueCards.count
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TechniqueCardCell
        
        // Configure the cell
        cell.backgroundColor = UIColor.blue
        cell.layer.cornerRadius = 10.0
        
        let card = techniqueCards[indexPath.row]
        let numberCurrentBPM = card.value(forKeyPath: "currentBPM") as? NSNumber
        cell.currentBPM.text = numberCurrentBPM?.stringValue
        cell.techniqueName.text = card.value(forKeyPath: "techniqueName") as? String

        return cell
    }
}

// MARK: UICollectionViewDelegate
extension TechniqueViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        let paddingSpace = sectionInsets.left * (cardsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / cardsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */

    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */

    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
}

