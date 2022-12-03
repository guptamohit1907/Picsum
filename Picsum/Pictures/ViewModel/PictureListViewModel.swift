//
//  PictureListViewModel.swift
//  Picsum
//
//  Created by Megi Sila on 3.12.22.
//

import Foundation

class PictureListViewModel: NSObject {
    private var pictureNetworking: PictureListNetworkingProtocol
    
    var reloadCollectionView: (() -> Void)?
    
    var pictures = Pictures()
    
    var pictureCellViewModels = [PictureViewModel]() {
        didSet {
            reloadCollectionView?()
        }
    }

    init(pictureNetworking: PictureListNetworkingProtocol = PictureListNetworking()) {
        self.pictureNetworking = pictureNetworking
    }
    
    func getPictures() {
        pictureNetworking.getPictures { success, model, error in
            if success, let pictures = model {
                self.fetchData(pictures: pictures)
            } else {
                print(error!)
            }
        }
    }
    
    func fetchData(pictures: Pictures) {
        self.pictures = pictures // Cache
        var vms = [PictureViewModel]()
        for picture in pictures {
            vms.append(createCellModel(picture: picture))
        }
        pictureCellViewModels = vms
    }
    
    func createCellModel(picture: Picture) -> PictureViewModel {
        return PictureViewModel(id: picture.id, author: picture.author, width: picture.width, height: picture.height, url: picture.url, downloadURL: picture.downloadURL)
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> PictureViewModel {
        return pictureCellViewModels[indexPath.row]
    }
}


