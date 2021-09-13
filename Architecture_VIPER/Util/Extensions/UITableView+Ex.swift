//
//  UITableView+Ex.swift
//  Architecture_VIPER
//
//  Created by 鳥嶋 晃次 on 2021/09/14.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func registerNib<T: UITableViewCell>(cellClass: T.Type) {
        register(
            UINib(nibName: cellClass.reuseIdentifier, bundle: nil)
            , forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func dequeue<T: UITableViewCell>(cellClass: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier) as? T
    }
    
    func dequeue<T: UITableViewCell>(cellClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
                withIdentifier: cellClass.reuseIdentifier, for: indexPath) as? T else {
            fatalError(
                "Error: cell with id: \(cellClass.reuseIdentifier) for indexPath: \(indexPath) is not \(T.self)")
        }
        return cell
    }
}
