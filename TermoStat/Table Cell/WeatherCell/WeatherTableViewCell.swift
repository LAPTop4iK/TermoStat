//
//  WeatherTableViewCell.swift
//  TermoStat
//
//  Created by Nikita Laptyonok on 27.07.21.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    static let cellIdentifier: String = "WeatherTableViewCell"
    
    // MARK: UI
    
    let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let dayOfTheWeekLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let highTempLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .orange
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let lowTempLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let iconImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.tintColor = .label
        return img
    }()
    
    // MARK: Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
}

// MARK: - Configure views

private extension WeatherTableViewCell {
    
    func configureViews() {
        selectionStyle = .none
        [iconImageView, dayOfTheWeekLabel, highTempLabel, lowTempLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false}
//        configureContainerStackView()
        configureIconImageView()
        configureDayOfTheWeekLabel()
        configureHighTempLabel()
        configureLowTempLabel()
    }
    
    func configureContainerStackView() {
        contentView.addSubview(containerStackView)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            containerStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
    }
    
    func configureDayOfTheWeekLabel() {
        
        contentView.addSubview(dayOfTheWeekLabel)
        NSLayoutConstraint.activate([
            dayOfTheWeekLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dayOfTheWeekLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dayOfTheWeekLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayOfTheWeekLabel.trailingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: -10)
        ])
    }
    
    func configureHighTempLabel() {
        contentView.addSubview(highTempLabel)
        NSLayoutConstraint.activate([
            highTempLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            highTempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            highTempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            highTempLabel.widthAnchor.constraint(equalToConstant: 66)
        ])
    }
    
    func configureLowTempLabel() {
        contentView.addSubview(lowTempLabel)
        NSLayoutConstraint.activate([
            lowTempLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            lowTempLabel.trailingAnchor.constraint(equalTo: highTempLabel.leadingAnchor, constant: -10),
            lowTempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lowTempLabel.widthAnchor.constraint(equalToConstant: 66)
        ])
    }
    
    func configureIconImageView() {
        contentView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 65),
            iconImageView.widthAnchor.constraint(equalToConstant: 65)
        ])
    }
}

// MARK: - ConfigureCell

extension WeatherTableViewCell {
    
    func fill(cellModel: Daily) {
        let weatherIconName = cellModel.weather[0].icon
        dayOfTheWeekLabel.text = getDateForDate(Date(timeIntervalSince1970: Double(cellModel.dt)))
        highTempLabel.text = "\(Int(cellModel.temp.max.rounded()))°C"
        lowTempLabel.text = "\(Int(cellModel.temp.min.rounded()))°C"
        iconImageView.image = UIImage(named: weatherIconName)
        
    }
    
    func getDateForDate(_ date: Date?) -> String {
        guard let imputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: imputDate)
    }
}
