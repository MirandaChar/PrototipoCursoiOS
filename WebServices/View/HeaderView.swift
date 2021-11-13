//
//  Header.swift
//  WebServices
//
//  Created by Carlos on 09/11/21.
//

import UIKit

class HeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var saludoLabel: UILabel!
    @IBOutlet weak var signOutView: UIView!
    @IBOutlet weak var perfilPic: UIImageView!
    
    @IBOutlet weak var labelSignOut: UnderlinedLabel!
    
    var delegate: HeaderProtocol?
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubviews()
        setupImageView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
        setupImageView()
    }
    
    private func setupImageView(imageName: String = "foto") {
        perfilPic.image = UIImage(named: imageName)
        perfilPic.layer.cornerRadius = perfilPic.bounds.height / 2
        labelSignOut.sizeToFit()
        
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "HeaderView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
                
        backgroundColor = .clear
        
        contentView.frame = bounds
        addSubview(contentView)
        
        
        let layer = UIView(frame: CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: 100))
        let gradient = CAGradientLayer()
        gradient.frame = contentView.frame
        gradient.colors = [
          UIColor(red:1, green:0.51, blue:0.33, alpha:1).cgColor,
          UIColor(red:1, green:0.27, blue:0.52, alpha:1).cgColor
        ]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0, y: -0.11)
        gradient.endPoint = CGPoint(x: 0.99, y: 1.11)
        layer.layer.addSublayer(gradient)
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = contentView.frame
        rectShape.position = contentView.center
        rectShape.path = UIBezierPath(roundedRect: contentView.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 15, height: 15)).cgPath

        layer.layer.mask = rectShape
        
        
        self.contentView.addSubview(layer)
        self.contentView.sendSubviewToBack(layer)
        
        
        labelSignOut.text = "Cerrar sesión"
    }
    
    @IBAction func signOutAction(_ sender: Any) {
        delegate?.goToLoginViewController()
        
    }

}

protocol HeaderProtocol {
    func goToLoginViewController()
}



