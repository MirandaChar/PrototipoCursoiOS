//
//  HeaderCodeAndNavigation.swift
//  WebServices
//
//  Created by Carlos on 09/11/21.
//

import Foundation
import  UIKit


class GenericViewController: UIViewController {
    
    let child = SpinnerViewController()
    var myNavigationController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public func goToRootViewController() {
        for vc in self.navigationController!.viewControllers {
            if vc.isKind(of: ViewController.self) {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    public func goToBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func createSpinnerView() {
        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

    }
    
    func hideActivity() {
        DispatchQueue.main.async {
            self.child.willMove(toParent: nil)
            self.child.view.removeFromSuperview()
            self.child.removeFromParent()
        }
    }
}

class FormViewController: GenericViewController, UISearchBarDelegate, HeaderProtocol {
    
    @IBOutlet weak var keyTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchController: UISearchBar?
    
    @IBOutlet weak var header: HeaderView!
    
    
    var alertLabel1: UILabel {
        let label = UILabel()
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    
    let alertLabel = UILabel()
    
    var listaActividades = [NewActivity]()
    var filteredActividades = [NewActivity]()
    
    //Activity indicator
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        table.delegate = self
        table.dataSource = self
        self.setupAlert()
        
        searchController?.delegate = self
        header.delegate = self
    }
    
    func goToLoginViewController() {
        super.goToRootViewController()
    }
    
   

    func setupAlert(){ alertLabel.translatesAutoresizingMaskIntoConstraints = false
        alertLabel.backgroundColor = .clear
        alertLabel.textColor = .red
        alertLabel.text = "Faltan campos por completar."
        alertLabel.textAlignment = .center
        view.addSubview(alertLabel)
        
        alertLabel.bottomAnchor.constraint(equalTo: table.topAnchor, constant: 25).isActive = true
        alertLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        alertLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        alertLabel.isHidden = true
        
    }
    
    func isFormComplete(textFields: [UITextField]) -> Bool{
        
        var flag = false
        
        for textField in textFields {
            if textField.text != "" {
                flag = true
            }
            else {
                flag = false
                break
            }
        }
        
        return flag
    }

    @IBAction func registrarUsuario(_ sender: Any) {
        
        if isFormComplete(textFields: [keyTextField, nameTextField, descriptionTextField]) {
            
            self.alertLabel.isHidden = true
            self.searchController?.isHidden = false
            super.createSpinnerView()
        Service.shared.createActividad(key: self.keyTextField.text ?? "CURSO_IOS", name: self.nameTextField.text ?? "Analisis de requerimiento.", description: self.descriptionTextField.text ?? "Descripción del analisis.", completion: { [self]
            res in
            
            switch res {
            case .success(let data):
            print(data)
                self.listaActividades = data
                self.filteredActividades = self.listaActividades
                table.reloadData()
            case .failure(let err):
            print("Error en la petición: ", err)
                self.listaActividades = []
                self.filteredActividades = []
                table.reloadData()
            }
            
            self.hideActivity()
            print(res)
        })
        }
        else {
            print("Faltan datos por completar. 👺")
            self.alertLabel.isHidden = false
            self.listaActividades = []
            self.table.reloadData()
        }
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredActividades = []
        
        for activity in listaActividades {
            if activity.name.lowercased().contains(searchText.lowercased()) {
                filteredActividades.append(activity)
            }
        }
        
        self.table.reloadData()
    }
    
    
}

extension FormViewController: UITableViewDelegate {
    
}

extension FormViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return filteredActividades.count
        
        
        
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let thisActivity: NewActivity!
        
        thisActivity = filteredActividades[indexPath.row]
        
        cell.textLabel?.text = thisActivity.name
        cell.detailTextLabel?.text = thisActivity.description
        cell.imageView?.image = UIImage(named: "icon_boy")
        return cell
    }
    
    
}


class KeyboardViewController: GenericViewController, UIPickerViewDelegate, UIPickerViewDataSource, HeaderProtocol {
    
    @IBOutlet weak var nombreTextfield: UITextField!
    @IBOutlet weak var puestoTextfield: UITextField!
    @IBOutlet weak var headerView: HeaderView!
    
    let listaPuestos = ["Desarrollador", "Lider de proyecto", "Tester", "Diseñador", "Técnico", "Analista", "Project Manager", "Director"]
    
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        puestoTextfield.inputView = pickerView
        puestoTextfield.textAlignment = .center
        puestoTextfield.placeholder = "Puesto"
        pickerView.delegate = self
        pickerView.dataSource = self
        headerView.delegate = self
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)
    }
    
    func goToLoginViewController () {
        super.goToRootViewController()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listaPuestos.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         return listaPuestos[row] + "💀"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        puestoTextfield.text = listaPuestos[row] + "👻"
        puestoTextfield.resignFirstResponder()
        
    }
}
