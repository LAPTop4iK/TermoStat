//
//  ViewController.swift
//  TermoStat
//
//  Created by Nikita Laptyonok on 27.07.21.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    var cityName = String()
    let fillColor: UIColor = UIColor(red: 167/255.0, green: 189/255.0, blue: 202/255.0, alpha: 1)
    var dailyModels = [Daily]()
    var hourlyModels = [Hourly]()
    var currentWeather: Current?
    
    lazy var table: UITableView = {
        var table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(HourlyTableViewCell.self, forCellReuseIdentifier: HourlyTableViewCell.cellIdentifier)
        table.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.cellIdentifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        title = "Seatch for a location..."
        view.addSubview(table)
        LocationManager.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.fetchWeather(for: location)
            }
        }
        NetworkManager.shared.onCompletion = { [weak self] currentWeather in
            guard let self = self else {return}
            self.updateInterface(weather: currentWeather)
        }
        
        table.backgroundColor = fillColor
        view.backgroundColor = fillColor

    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    @objc func refreshTapped() {
        LocationManager.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.fetchWeather(for: location)
            }
        }
        NetworkManager.shared.onCompletion = { [weak self] currentWeather in
            guard let self = self else {return}
            self.updateInterface(weather: currentWeather)
        }
    }
    @objc func searchTapped() {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { city in
            LocationManager.shared.resolveLocationCoordWith(name: city) {placemark in
                guard let placemark = placemark else { return }
                let location = placemark.location
                let longitude = location?.coordinate.longitude
                let latitude = location?.coordinate.latitude
                self.cityName = "\(placemark.locality ?? "City"), \(placemark.country ?? "Country")"
                NetworkManager.shared.fetchWeather(forRequestType: .coordinate(latitude: latitude ?? CLLocationDegrees(0), longitude: longitude ?? CLLocationDegrees(0)))
                
                
            }
            
        }
        
        NetworkManager.shared.onCompletion = { [weak self] currentWeather in
            guard let self = self else {return}
            self.updateInterface(weather: currentWeather)
        }
    }
    
    func updateInterface(weather: Result) {
        dailyModels.removeAll()
        self.dailyModels.append(contentsOf: weather.daily)
        let current = weather.current
        self.currentWeather = current
        
        self.hourlyModels = weather.hourly
        DispatchQueue.main.async {
            self.table.reloadData()
            self.table.tableHeaderView = self.createTableHeader()
        }
    }
    
    func fetchWeather(for location: CLLocation) {
        let long = location.coordinate.longitude
        let lat = location.coordinate.latitude
        NetworkManager.shared.fetchWeather(forRequestType: .coordinate(latitude: lat, longitude: long))
        
        LocationManager.shared.resolveLocationName(with: location) { cityName in
            DispatchQueue.main.async {
                self.cityName = cityName ?? ""
                //self.title = cityName?.components(separatedBy: ", ")[0]
            }
        }
        
    }
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping(String) -> Void) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        ac.addTextField { tf in
            let cities = ["Moscow", "London", "Saint-Peterburg", "Berlin", "Paris"]
            tf.placeholder = cities.randomElement()
        }
        let search = UIAlertAction(title: "Search", style: .default) { action in
            let textField = ac.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
                let city = cityName.split(separator: " ").joined(separator: "%20")
                completionHandler(city)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(search)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return dailyModels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.cellIdentifier, for: indexPath) as! HourlyTableViewCell
            cell.fill(cellModels: hourlyModels)
            cell.backgroundColor = fillColor
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.cellIdentifier, for: indexPath) as! WeatherTableViewCell
        cell.fill(cellModel: dailyModels[indexPath.row])
        cell.backgroundColor = fillColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 90
        }
        return 70
    }
}

private extension MainViewController {
    
    func createTableHeader() -> UIView {
        
        let containerStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.alignment = .center
            stackView.distribution = .equalSpacing
            stackView.axis = .vertical
            return stackView
        }()
        
        let cityLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 24)
            return label
        }()
        
        let textWeatherLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18)
            return label
        }()
        
        let degreeWeatherLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 54)
            return label
        }()
        func configureViews() {
            configureContainerStackView()
            configureCityLabel()
            configureTextWeatherLabel()
            configureDegreeWeatherLabel()
        }
        
        func configureContainerStackView() {
            headerView.addSubview(containerStackView)
            containerStackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                containerStackView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 60),
                containerStackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -80),
                containerStackView.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16),
                containerStackView.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -16)
            ])
        }
        
        func configureCityLabel() {
            containerStackView.addArrangedSubview(cityLabel)
        }
        
        func configureTextWeatherLabel() {
            containerStackView.addArrangedSubview(textWeatherLabel)
        }
        
        func configureDegreeWeatherLabel() {
            containerStackView.addArrangedSubview(degreeWeatherLabel)
        }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width * 0.7))
        configureViews()
        guard let currentWeather = self.currentWeather else {
            return UIView()
        }
        degreeWeatherLabel.text = "\(currentWeather.temp)°C"
        cityLabel.text = cityName
        textWeatherLabel.text = currentWeather.weather[0].description.capitalized
        self.title = cityName.components(separatedBy: ", ")[0]
        headerView.backgroundColor = fillColor
        return headerView
    }
}



