//
//  ViewController.swift
//  WebServices
//
//  Created by Carlos on 07/11/21.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController {
    
    var gidConfiguration: GIDConfiguration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Root ViewController")
        //setUpMenuButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        gidConfiguration = GIDConfiguration.init(clientID: "740192889507-5brfijj1g0javi3uaonnfp2hlsj42a51.apps.googleusercontent.com")
    }
    
    @IBAction func signInBtnAction(_ sender: Any) {
        trySignInWithGoogleAcount()
    }
    
    func trySignInWithGoogleAcount() {
        GIDSignIn.sharedInstance.signIn(with: gidConfiguration!, presenting: self, callback: {
            user, err in
            guard let user = user else { return }
            
            print("Email: ", user.profile?.email ?? "No email")
        })
    }
    
    func setUpMenuButton(){
        let perfilPicButton = UIButton(type: .custom)
        perfilPicButton.frame = CGRect(x: 0.0, y: 0.0, width: 34, height: 34)
        perfilPicButton.setImage(UIImage(named:"splash"), for: .normal)
        perfilPicButton.imageView?.layer.cornerRadius = perfilPicButton.imageView!.bounds.height / 2
        
        let perfilPicBarItem = UIBarButtonItem(customView: perfilPicButton)
        let currWidth = perfilPicBarItem.customView?.widthAnchor.constraint(equalToConstant: 34)
        currWidth?.isActive = true
        let currHeight = perfilPicBarItem.customView?.heightAnchor.constraint(equalToConstant: 34)
        currHeight?.isActive = true
        self.navigationItem.rightBarButtonItem = perfilPicBarItem
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueJokes" {
            let vc = segue.destination as! JokesViewController
            vc.fetchJokes()
        }
        
        if segue.identifier == "tabSegue" {
            let vc = segue.destination as! NaatTabBarViewController
            vc.hideTabBar()
        }
    }
    
    
    @IBAction func goToMethodPost(_ sender: Any) {
        performSegue(withIdentifier: "tabSegue", sender: nil)
    }

}





class JokesViewController: GenericViewController {

    @IBOutlet weak var setup: UILabel!
    @IBOutlet weak var delivery: UILabel!
    
    private var quoteData: QuoteData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func fetchJokes() {
        createSpinnerView()
        Service.shared.getJokes(completion: { [self]
            res in
            
            switch res {
            case .success(let decodedData):
                self.quoteData = decodedData
                hideActivity()
                DispatchQueue.main.async {
                    
                    self.quoteData = decodedData
                    
                    if self.quoteData?.type == "single" {
                        self.setup.text = self.quoteData?.joke
                        self.delivery.text = ""
                        
                        print("🤡: \(self.quoteData?.joke ?? "")")
                        
                    }
                    else {
                        self.delivery.text = self.quoteData?.delivery
                        self.setup.text = self.quoteData?.setup
                        
                        print("""
                            👽: \(self.quoteData?.setup ?? "")
                            🤡: \(self.quoteData?.delivery ?? "")
    """)
                    }
                    
                    }
                
            case .failure(let err):
                print("ERROR AL OBTENER DATOS: ", err)
                hideActivity()
            }
        })
    }
    
    @IBAction func getNewJoke(_ sender: Any) {
        self.fetchJokes()
    }
    

}


class SpinnerViewController: UIViewController {
    
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}






