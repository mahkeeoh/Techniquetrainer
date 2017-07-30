//
//  AddCardView.swift
//  TechTrainer
//
//  Created by Mikael Olezeski on 7/24/17.
//  Copyright © 2017 Mikael Olezeski. All rights reserved.
//

import UIKit

class AddCardView: UIView {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var techniqueNameField: UITextField!
    @IBOutlet weak var startingBPMField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addTaskButton: UIButton!

    var delegate:AddCardViewDelegate!
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        delegate?.moveAddCardView()
    }
    
    @IBAction func addPressed(_ sender: Any) {
        delegate?.addNewTask()
    }
}

protocol AddCardViewDelegate {
    func moveAddCardView()
    func addNewTask()
}
