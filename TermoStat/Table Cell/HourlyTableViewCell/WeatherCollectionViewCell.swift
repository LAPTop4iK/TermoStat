//
//  WetherCollectionViewCell.swift
//  TermoStat
//
//  Created by Nikita Laptyonok on 28.07.21.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier: String = "WetherCollectionViewCell"
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let iconImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.tintColor = .label
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .clear
        configureViews()
    }
    required init?(coder: NSCoder) {
        return nil
    }
    
    func getDateForDate(_ date: Date?) -> String {
        guard let imputDate = date else {
            return ""
        }
        let currentDate = Date().timeIntervalSince1970
        if (currentDate - 3600)...(currentDate) ~= imputDate.timeIntervalSince1970 {
            return "Now"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        if formatter.string(from: imputDate) == "00" {
            formatter.dateFormat = "E, d. HH"
            return formatter.string(from: imputDate)
        }
        return formatter.string(from: imputDate)
    }
    
    func configure(with model: Hourly) {
        let weatherIconName = model.weather[0].icon
        self.dateLabel.text = getDateForDate(Date(timeIntervalSince1970: Double(model.dt)))
        self.tempLabel.text = "\(model.temp)°C"
        self.iconImageView.image = UIImage(named: weatherIconName)
    }
    
    func configureViews() {
        [iconImageView, tempLabel, dateLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false}
        configureDateLabel()
        configureTempLabel()
        configureIconImageView()
        
    }
    
    func configureDateLabel() {
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    func configureIconImageView() {
        contentView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iconImageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: tempLabel.topAnchor)
        ])
    }
    
    func configureTempLabel() {
        contentView.addSubview(tempLabel)
        NSLayoutConstraint.activate([
            tempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            tempLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tempLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
}

