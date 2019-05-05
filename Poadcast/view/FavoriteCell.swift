//
//  FavoriteCell.swift
//  Poadcast
//
//  Created by hosam on 5/4/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    
    var podcasts:PodcastModel? {
        didSet{
            guard let pod = podcasts else { return  }
            epoisdeName.text = pod.trackName
            epoisdeauthor.text = pod.artistName
            
            guard  let url = URL(string: pod.artworkUrl600 ?? "") else {return}
            
            mainImage.sd_setImage(with: url)
        }
    }
    
    let mainImage:UIImageView = {
       let im = UIImageView()
        im.image = #imageLiteral(resourceName: "music")
        
        return im
    }()
    let epoisdeName:UILabel = {
       let la = UILabel()
        la.font = UIFont.systemFont(ofSize: 15)
        la.numberOfLines = 0
        return la
    }()
    let epoisdeauthor:UILabel = {
        let la = UILabel()
        la.font = UIFont.systemFont(ofSize: 13)
        la.textColor = .lightGray
        la.numberOfLines = 0
        return la
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
        
        
        let stack = UIStackView(arrangedSubviews: [epoisdeName,epoisdeauthor])
        stack.axis = .vertical
        stack.spacing = 2
        stack.distribution = .fillEqually
        addSubview(mainImage)
        addSubview(stack)
        
        mainImage.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 120))
        stack.anchor(top: mainImage.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 4, left: 0, bottom: 0, right: 0))
    }
}
