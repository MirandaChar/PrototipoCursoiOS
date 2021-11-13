//
//  RegistarHorasViewController.swift
//  WebServices
//
//  Created by Carlos on 09/11/21.
//

import UIKit

class RegistarHorasViewController: GenericViewController, HeaderProtocol, SecondHeaderProtocol {
    
    @IBOutlet weak var header: HeaderView!
    @IBOutlet weak var secondHeader: SecondHeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        header.delegate = self
        secondHeader.delegate = self
    }

    
    func goToBackViewController() {
        super.goToBack()
    }
    
    func goToLoginViewController() {
        super.goToRootViewController()
    }
    
}
