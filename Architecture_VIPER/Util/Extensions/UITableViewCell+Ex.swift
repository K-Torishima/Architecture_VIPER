//
//  UITableViewCell+Ex.swift
//  Architecture_VIPER
//
//  Created by 鳥嶋 晃次 on 2021/09/14.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
