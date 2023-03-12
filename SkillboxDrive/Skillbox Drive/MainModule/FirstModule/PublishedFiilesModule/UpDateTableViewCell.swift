//
//  UpDateTableViewCell.swift
//  Skillbox Drive
//
//  Created by Bandit on 31.01.2023.
//

import UIKit

final class UpDateTableViewCell: TableCellDefault {
    
    func configure(_ file: Items) {
        activityIndicator.startAnimating()
        loadImage(stringUrl: file.preview ?? url) { image in
            if file.type == "dir" {
                self.labelImage.image = UIImage(named: "IconFile")
                self.subnameLabel.text = ((file.modified)!).dateFormater()
            } else {
                self.labelImage.image = image
                self.subnameLabel.text = ((Int(file.size ?? 0)) ).formatterForSizeValueFile() + " " + ((file.modified)!).dateFormater()
            }
        }
        activityIndicator.stopAnimating()
        nameLabel.text = file.name
        
        fileTableView = file.name
        path = file.path!
    }

    private var path = ""
    private var fileTableView : String?
    weak var delegate : PublishedTableViewCellDelegate?

    private lazy var buttonView : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: UIControl.State.normal)
        button.tintColor = .gray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(presentAlert), for: .touchUpInside)
        return button
    }()
    
    @objc private func presentAlert () {
        if let file = fileTableView {
            self.delegate?.presentAlertTableViewCell(self, subscribeButtonTappedFor: file, path: path)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(buttonView)

        nameLabel.trailingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: -5).isActive = true

        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        buttonView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        buttonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        buttonView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
