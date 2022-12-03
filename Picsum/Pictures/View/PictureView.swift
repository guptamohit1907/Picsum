//
//  PictureView.swift
//  Picsum
//
//  Created by Megi Sila on 3.12.22.
//

import UIKit

class PictureView: UIViewController {
    let pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray2
        return imageView
    }()
    
    var initialPictureImage = UIImage()
    var grayscalePictureImage = UIImage()
    var blurPictureImage = UIImage()
    
    let control = UISegmentedControl(items: ["Normal", "Grayscale", "Blur"])
    let slider = UISlider()
    
    var pictureViewModel: PictureViewModel!
    
    
    init(model: PictureViewModel) {
        self.pictureViewModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupImageView(filter: .none)
        setupImageView(filter: .grayscale)
        setupImageView(filter: .blur)
    }
    
    func setupUI() {
        navigationItem.title = pictureViewModel.author
        
        view.backgroundColor = .systemBackground
        view.addSubview(pictureImageView)
        view.addSubview(control)
        view.addSubview(slider)
        
        slider.frame = CGRect(x: 20, y: 475, width: view.frame.width - 40, height: 20)
        slider.minimumValue = 1
        slider.maximumValue = 10
        slider.value = 4
        slider.isHidden = true
        slider.addTarget(self, action: #selector(changeBlurRatio), for: .editingChanged)
        slider.addTarget(self, action:#selector(changeBlurRatio(sender:)), for: .valueChanged)
        
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        control.selectedSegmentIndex = 0
        
        NSLayoutConstraint.activate([
            pictureImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            pictureImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pictureImageView.widthAnchor.constraint(equalToConstant: 300),
            pictureImageView.heightAnchor.constraint(equalToConstant: 300),
            
            control.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            control.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            control.topAnchor.constraint(equalTo: view.topAnchor, constant: 420),
            control.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    @objc
    func segmentControl(_ segmentedControl: UISegmentedControl) {
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            pictureImageView.image = initialPictureImage
            slider.isHidden = true
            break
        case 1:
            pictureImageView.image = grayscalePictureImage
            slider.isHidden = true
            break
        case 2:
            pictureImageView.image = blurPictureImage
            slider.isHidden = false
            break
        default:
            break
        }
    }
    
    @objc
    func changeBlurRatio(sender: UISlider) {
        if (!slider.isTracking) {
            let modifiedUrl = pictureViewModel.downloadURL.optimiseURL()
            PictureNetworking().getBlurredRatioPicture(url: modifiedUrl, ratio: Int(slider.value)) { _, _, image in
                DispatchQueue.main.async {
                    self.pictureImageView.image = image!
                    self.blurPictureImage = image!
                }
            }
        }
    }
    
    func setupImageView(filter: Filter) {
        let modifiedUrl = pictureViewModel.downloadURL.optimiseURL()
        PictureNetworking().getFilteredPicture(url: modifiedUrl, filter: filter) { _, _, image in
            DispatchQueue.main.async {
                switch filter {
                case .none:
                    self.pictureImageView.image = image!
                    self.initialPictureImage = image!
                case .grayscale:
                    self.grayscalePictureImage = image!
                case .blur:
                    self.blurPictureImage = image!
                }
            }
        }
    }
}
