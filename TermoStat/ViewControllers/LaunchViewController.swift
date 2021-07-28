//
//  LaunchViewController.swift
//  TermoStat
//
//  Created by Nikita Laptyonok on 27.07.21.
//

import UIKit

class LaunchViewController: UIViewController {
    let configuration = UIImage.SymbolConfiguration(weight: .thin)
   
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "T E R M O S T A T"
        label.font = UIFont.systemFont(ofSize: 34, weight: .semibold)
        label.tintColor = .black
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    lazy var sun: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "sun.max", withConfiguration: configuration)
        view.contentMode = .scaleAspectFit
        view.tintColor = .black
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 50
        return view
    }()
    
    lazy var sky: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "cloud.fill", withConfiguration: configuration)
        view.contentMode = .scaleAspectFit
        view.tintColor = .black
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 50
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupAnimation()
        presentWeatherVC()
    }
    
    private func setupConstraints() {
        
        view.addSubview(label)
        view.addSubview(sun)
        view.addSubview(sky)
        
        [label,
         sun,
         sky].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            sun.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            sun.widthAnchor.constraint(equalToConstant: 200),
            sun.heightAnchor.constraint(equalToConstant: 200),
            sun.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            sky.widthAnchor.constraint(equalToConstant: 150),
            sky.heightAnchor.constraint(equalToConstant: 150),
            sky.leadingAnchor.constraint(equalTo: sun.leadingAnchor, constant: 60),
            sky.bottomAnchor.constraint(equalTo: sun.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    private func setupAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.byValue = 1 * -CGFloat.pi
        rotation.duration = 6
        rotation.repeatCount = Float.greatestFiniteMagnitude
        sun.layer.add(rotation, forKey: "myAnimation")
    }
    
    private func presentWeatherVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let vc = UINavigationController(rootViewController: MainViewController())
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.fade
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            self.view.window!.layer.add(transition, forKey: kCATransition)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }

}
