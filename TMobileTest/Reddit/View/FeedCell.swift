//
//  FeedCell.swift
//  TMobileTest
//
//  Created by Ashish Patel on 10/14/20.
//

import UIKit

class FeedCell: UITableViewCell {
    lazy var mainImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var cellCommentLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.numberOfLines = 0
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textAlignment = .right
        return lable
    }()
    
    lazy var cellTitleLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont.boldSystemFont(ofSize: 16)
        lable.numberOfLines = 0
        return lable
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
       return stackView
    }()

    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setTitle(" Like", for: .normal)
        let image = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.tintColor = .gray
        return button
    }()

    lazy var commentButton: UIButton = {
        let button = UIButton()
        button.setTitle(" Comment", for: .normal)
        let image = UIImage(named: "comment")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    
    func setupView() {
        self.addSubview(cellTitleLable)
        NSLayoutConstraint.activate([
            cellTitleLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            cellTitleLable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            cellTitleLable.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
        self.addSubview(mainImageView)
        NSLayoutConstraint.activate([
            mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainImageView.topAnchor.constraint(equalTo: cellTitleLable.bottomAnchor, constant: 5)
        ])
        self.addSubview(cellCommentLable)
        NSLayoutConstraint.activate([
            cellCommentLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            cellCommentLable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            cellCommentLable.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 5)
        ])
        stackView.addArrangedSubview(likeButton)
        stackView.addArrangedSubview(commentButton)
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: cellCommentLable.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Helper Function
    func populate(with child: Child) {
        cellTitleLable.text = child.data.title
        if let imageURL = URL(string: child.data.thumbnailURL),
           child.data.thumbnailURL.isValidURL {
            mainImageView.downloadImageFrom(imageURL: imageURL)
        } else {
            mainImageView.image = nil
        }
        guard let comments = child.data.numOfComments,
              let score = child.data.score else {
            return
        }
        cellCommentLable.text = "Score \(score.roundedWithAbbreviations) Comments \(comments.roundedWithAbbreviations)"
    }
}
