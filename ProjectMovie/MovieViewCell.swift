//
//  MovieViewCell.swift
//  ProjectMovie
//
//  Created by Rafaela Galdino on 07/04/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import UIKit

protocol FavoriteMovieProtocol {
    func someMethodIWantToCall(cell: UICollectionViewCell)
}
    
class MovieViewCell: UICollectionViewCell {
    public let posterImage = UIImageView()
    private let textPlaceholderView = UIView()
    public let titleLabel = UILabel()
    public let favoriteButton = UIButton(type: .system)
        
    static let reuseIdentifier = "MovieViewCell"

    var delegate: FavoriteMovieProtocol?
    
    static let height: CGFloat = 240
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 3.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3.0)
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath

        contentView.addSubview(posterImage)
        posterImage.anchor(top: topAnchor,
                           leading: leadingAnchor,
                           bottom: bottomAnchor,
                           trailing: trailingAnchor,
                           padding: .init(top: 0, left: 0, bottom: 0, right: 0))
                
        textPlaceholderView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.8078431373, blue: 0.3568627451, alpha: 1)
        contentView.addSubview(textPlaceholderView)
        textPlaceholderView.anchor(top: nil,
                                   leading: leadingAnchor,
                                   bottom: bottomAnchor,
                                   trailing: trailingAnchor,
                                   padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                                   size: .init(width: 0, height: bounds.height * 0.15))
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        textPlaceholderView.addSubview(blurredEffectView)
        blurredEffectView.fillSuperview()
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        blurredEffectView.contentView.addSubview(vibrancyEffectView)
        vibrancyEffectView.fillSuperview()

        favoriteButton.setImage(#imageLiteral(resourceName: "favorite_full_icon"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        favoriteButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        favoriteButton.setContentHuggingPriority(.required, for: .horizontal)
        vibrancyEffectView.contentView.addSubview(favoriteButton)
        favoriteButton.anchor(top: vibrancyEffectView.topAnchor,
                              leading: nil,
                              bottom: vibrancyEffectView.bottomAnchor,
                              trailing: vibrancyEffectView.trailingAnchor,
                              padding: .init(top: 0, left: 0, bottom: 0, right: 8))
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
        vibrancyEffectView.contentView.addSubview(titleLabel)
        titleLabel.anchor(top: vibrancyEffectView.topAnchor,
                          leading: vibrancyEffectView.leadingAnchor,
                          bottom: vibrancyEffectView.bottomAnchor,
                          trailing: favoriteButton.leadingAnchor,
                          padding: .init(top: 8, left: 8, bottom: 8, right: 0))
    }
}

extension MovieViewCell {
    @objc private func toggleFavorite() {
        print("TAPPED")
        delegate?.someMethodIWantToCall(cell: self)
    }
}
