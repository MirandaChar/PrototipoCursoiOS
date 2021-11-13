//
//  SecondHeaderView.swift
//  WebServices
//
//  Created by Carlos on 09/11/21.
//

import UIKit

class SecondHeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    
    @IBOutlet weak var btnCambiar: UIButton!
    var delegate: SecondHeaderProtocol?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "SecondHeaderView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
                
        backgroundColor = .clear
        
        contentView.frame = bounds
        addSubview(contentView)
        
        setRoundCornersBottomView(view: view1)
        setRoundCornersBottomView(view: view2)
    }
    
    private func setRoundCornersBottomView(view: UIView) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = view.frame
        rectShape.position = view.center
        rectShape.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 15, height: 15)).cgPath

        view.layer.mask = rectShape
    }

    @IBAction func pressCambiar(_ sender: Any) {
        print("Ir hacia atrás..")
        delegate?.goToBackViewController()
    }
}

protocol SecondHeaderProtocol {
    func goToBackViewController()
}
