//
//  SecondViewingControllerCell.swift
//  Skillbox Drive
//
//  Created by Bandit on 01.03.2023.
//

import UIKit

final class SecondViewingControllerCell: TableCellDefault {
    
    func configure(_ file: Items) {
        activityIndicator.startAnimating()
        loadImage(stringUrl: file.preview ?? url) { image in
            if file.type == "dir" {
                self.labelImage.image = UIImage(named: "IconFile")
                self.subnameLabel.text = ((file.modified)!).dateFormater()
            } else {
                self.labelImage.image = image
                self.subnameLabel.text = (((file.size)) ?? 0).formatterForSizeValueFile() + " " + ((file.modified)!).dateFormater()
            }
        }
        activityIndicator.stopAnimating()
        nameLabel.text = file.name
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
