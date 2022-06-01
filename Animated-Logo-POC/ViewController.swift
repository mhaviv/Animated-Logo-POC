//
//  ViewController.swift
//  Animated-Logo-POC
//
//  Created by Michael Haviv on 5/31/22.
//

import UIKit

class ViewController: UIViewController {
    
    /// Pulsating circle layer
    var pulsatingLayer = CAShapeLayer()
    /// Stagnant circle layer
    var staticLayer = CAShapeLayer()
        
    var watchLiveText: UIImageView = {
        let image = UIImage(named: "watch-live-text")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// View containing both circle layers
    var liveIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    var watchLiveContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        createLiveIndicatorView(radius: 32.5, alpha: 0.3, isPulsatingLayer: true)
        createLiveIndicatorView(radius: 16.5, alpha: 1, isPulsatingLayer: false)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(watchLiveTapped))
        watchLiveContainerView.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        staticLayer.frame = liveIndicatorView.bounds
        pulsatingLayer.frame = liveIndicatorView.bounds
    }
    
    // FIXME: View not triggering tap gesture
    @objc func watchLiveTapped() {
        let secondVC = SecondViewController()
        secondVC.title = "Second View Controller"
        navigationController?.pushViewController(secondVC, animated: true)
    }
        
    func setupView() {
        watchLiveContainerView.addSubview(liveIndicatorView)
        watchLiveContainerView.addSubview(watchLiveText)
        view.addSubview(watchLiveContainerView)
        
        liveIndicatorView.frame = watchLiveContainerView.bounds
        watchLiveText.frame = watchLiveContainerView.bounds
        
        NSLayoutConstraint.activate([
            // Container view constraints
            watchLiveContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            watchLiveContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            watchLiveContainerView.heightAnchor.constraint(equalToConstant: 80),
            
            // Live indicator circle constraints
            liveIndicatorView.heightAnchor.constraint(equalToConstant: 24),
            liveIndicatorView.widthAnchor.constraint(equalToConstant: 24),
            liveIndicatorView.leadingAnchor.constraint(equalTo: watchLiveContainerView.leadingAnchor, constant: 10),
            liveIndicatorView.trailingAnchor.constraint(equalTo: watchLiveText.leadingAnchor, constant: -10),

            // Watch Live text imageview constraints constraints
            watchLiveText.heightAnchor.constraint(equalToConstant: 60),
            watchLiveText.widthAnchor.constraint(equalToConstant: 108),
            watchLiveText.trailingAnchor.constraint(equalTo: watchLiveContainerView.trailingAnchor, constant: -10)
        ])
    }
    
    /// Generates live indicator circles
    private func createLiveIndicatorView(radius: CGFloat, alpha: CGFloat, isPulsatingLayer: Bool) {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 28), radius: CGFloat(radius), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        let shapeLayer = isPulsatingLayer ? pulsatingLayer : staticLayer
        let liveIndicatorColor = UIColor(red: 221/255, green: 46/255, blue: 0/255, alpha: alpha)
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = liveIndicatorColor.cgColor
        liveIndicatorView.layer.addSublayer(shapeLayer)
        shapeLayer.frame = liveIndicatorView.bounds
        
        animatePulsatingLayer()
    }
    
    /// Creates pulsating opacity animation
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "opacity")
        
        animation.fromValue = 0 // starting opacity value
        animation.toValue = 0.6 // finishing opacity value
        animation.duration = 1.58
        animation.speed = 2
        animation.autoreverses = true // makes animation reversable
        animation.repeatCount = Float.infinity // repeat infinitely
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
}

