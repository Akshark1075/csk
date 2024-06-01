//
//  GalleryCollectionViewCell.swift
//  csk
//
//  Created by Arvind K on 21/02/24.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    var data:String?{
        didSet{
            guard let data = self.data else{return}
            let resizedImage = resizeImage(image: UIImage(named: data) ?? UIImage(named: "Dhoni.png")!, targetSize: contentView.frame.size)
                      bg.image = resizedImage
                   
                  }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bg)
        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive=true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive=true
        bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive=true
        bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive=true
    }
    fileprivate let bg:UIImageView={
        let iv=UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints=false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds=true
        iv.layer.cornerRadius=12
        return iv
    }()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let newSize = targetSize
        let rect = CGRect(x: 0, y: 0, width: newSize.width+75, height: newSize.height)

            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage ?? UIImage()
        }
}
