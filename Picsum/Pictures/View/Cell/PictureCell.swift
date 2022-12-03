//
//  PictureCell.swift
//  Picsum
//
//  Created by Megi Sila on 3.12.22.
//

import UIKit

class PictureCell: UICollectionViewCell {
    let pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray2
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cellViewModel: PictureViewModel? {
        didSet {
            let modifiedUrl = cellViewModel!.downloadURL.optimiseURL()
            if let pictureUrl = URL(string: modifiedUrl) {
                //getting data in background concurrent thread
                DispatchQueue.global(qos: .background).async {
                    let imageData:NSData = NSData(contentsOf: pictureUrl as URL)!
                    //update UI in main thread
                    DispatchQueue.main.async {
                        self.pictureImageView.image = UIImage(data: imageData as Data)
                    }
                }
            }
        }
    }
    
    func setupUI() {
        addSubview(pictureImageView)
        NSLayoutConstraint.activate([
            pictureImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            pictureImageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            pictureImageView.topAnchor.constraint(equalTo: self.topAnchor),
            pictureImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pictureImageView.image = nil
    }
}
