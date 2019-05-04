//
//  FavoriteCell.swift
//  Poadcast
//
//  Created by hosam on 5/4/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    
    let mainImage:UIImageView = {
       let im = UIImageView()
        im.image = #imageLiteral(resourceName: "music")
        
        return im
    }()
    let epoisdeName:UILabel = {
       let la = UILabel()
        la.text = "hosam elmalt"
        la.font = UIFont.systemFont(ofSize: 15)
        la.numberOfLines = 0
        return la
    }()
    let epoisdeauthor:UILabel = {
        let la = UILabel()
        la.text = "sdfdsafdsaa dffgds"
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
        let stack = UIStackView(arrangedSubviews: [mainImage,epoisdeName,epoisdeauthor])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        
        stack.fillSuperview()
    }
}
