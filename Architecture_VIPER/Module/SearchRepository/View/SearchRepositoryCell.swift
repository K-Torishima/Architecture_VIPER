//
//  SearchRepositoryCell.swift
//  Architecture_VIPER
//
//  Created by 鳥嶋 晃次 on 2021/09/14.
//

import UIKit

class SearchRepositoryCell: UITableViewCell {
    
    @IBOutlet private weak var repossitoryName: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var baseView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBaseView()
    }
    
    private func setupBaseView() {
        baseView.layer.cornerRadius = 8
        baseView.layer.shadowOffset = CGSize(width: 0, height: 1)
        baseView.layer.shadowColor = UIColor.black.cgColor
        baseView.layer.shadowOpacity = 0.2
        baseView.clipsToBounds = false
        baseView.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configre(entity: Repository) {
        repossitoryName.text = entity.fullName
        descriptionLabel.text = entity.description
    }
}
