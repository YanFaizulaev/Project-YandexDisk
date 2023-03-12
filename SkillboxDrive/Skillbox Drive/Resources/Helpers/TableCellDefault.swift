//
//  TableCellDefault.swift
//  Skillbox Drive
//
//  Created by Bandit on 14.02.2023.
//

import UIKit

public class TableCellDefault: UITableViewCell {
    
    // MARK: - URL 
    let url = "https://www.macworld.com/wp-content/uploads/2021/03/macos-high-sierra-folder-icon-100773103-orig-3.jpg?resize=300%2C200&quality=50&strip=all"
    
    // MARK: - func LoadImage
    func loadImage(stringUrl: String, completion: @escaping ((UIImage?) -> Void)) {
        let token = UserDefaults.standard.tokenUser
        guard let url = URL(string: stringUrl) else { return }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }
        }
        task.resume()
    }
    
    // MARK: - Indicator
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = .gray
        return view
    }()
    
    // MARK: - View
    lazy var labelImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = Constans.Fonts.graphik15
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var subnameLabel: UILabel = {
        let label = UILabel()
        label.font = Constans.Fonts.graphik13
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .gray
        return label
    }()

    // MARK: - StyleCell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        contentView.addSubview(labelImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(subnameLabel)
        contentView.addSubview(activityIndicator)
        
        labelImage.translatesAutoresizingMaskIntoConstraints = false
        labelImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        labelImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        labelImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5).isActive = true
        labelImage.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5).isActive = true
        labelImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5).isActive = true

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: labelImage.trailingAnchor, constant: 5).isActive = true
        nameLabel.topAnchor.constraint(equalTo: labelImage.topAnchor,constant: 11).isActive = true

        subnameLabel.translatesAutoresizingMaskIntoConstraints = false
        subnameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        subnameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        subnameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3).isActive = true

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.labelImage.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.labelImage.centerYAnchor).isActive = true
    }

    // MARK: - NSCoder
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
