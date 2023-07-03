//
//  todoCell.swift
//  SwiftStudyTest
//
//  Created by 문인범 on 2023/06/28.
//

import UIKit

class TodoCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    @IBOutlet var date: UILabel!
    
    /*
    override func prepareForReuse() {
        super.prepareForReuse()
        
        date.text = nil
    }
     */
}
