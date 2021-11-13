//
//  Tools.swift
//  WebServices
//
//  Created by Carlos on 09/11/21.
//

import Foundation
import UIKit
//Escribimos nuestra clase de Servicios y realizamos un Singleton de ella misma para gestionar nuestros servicios Web.
class Service: NSObject {
    
    static let shared = Service()
    
    func getJokes(completion: @escaping(Result<QuoteData, Error>) -> ()) {
        
        let typeAux = "twopart"
        guard let url = URL(string: "https://v2.jokeapi.dev/joke/Any?type=\(typeAux)") else {
            return
        }
        
        let urlSession = URLSession.shared.dataTask(with: url, completionHandler:{
            data, response, error in
            
            
            //Nos aseguramos que no exista algún error de lo contrario retornar.
            if let error = error {
                print("Error: ", error)
                return
            }
            
            //Si se pudo almacenar la informacion la guardamos, en caso contrario retornar
            guard let data = data else {
                return
            }
            
            print(String(data: data, encoding: .utf8) ?? "")
            
            //Ahora decodificar los Datos, sabemos que vienen en un formato Json así que podemos usar el decodificador  JSONDecoder
            
            do {
                
             let decodedData = try JSONDecoder().decode(QuoteData.self, from: data)
                completion(.success(decodedData))
            }
            catch {
                //Muestro mensaje de error en caso de un error de decodificacion
                print("Error en la descarga. ", error)
                completion(.failure(error))
            }
            
        })
        
        urlSession.resume()
    }
    
    
    
    func createActividad(key: String, name: String, description: String, completion: @escaping(Result<[NewActivity],Error>) -> ()) {
        guard let url = URL(string: "http://3.238.21.227:8080/activities") else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let newActivity = NewActivity(key: key, name: name, description: description)
        guard let newActivityJson = try? JSONEncoder().encode(newActivity) else {
            return
        }
        
        print(String(data: newActivityJson, encoding: .utf8) ?? "")
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //urlRequest.addValue("multipart/form-data; boundary=---BOUNDARY", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = newActivityJson
            
            /*"""
            -----BOUNDARY
            Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"
            Content-Type: image/jpeg

            Base64DeLaImagen

            -----BOUNDARY
            Content-Disposition: form-data; name=\"Curos iOS\"
            Content-Type: text/plain

            Encabezado de la noticia
            -----BOUNDARY

            Content-Disposition: form-data; name=\"summary\"
            Content-Type: text/plain

            Resumen de la noticia
            -----BOUNDARY

            Content-Disposition: form-data; name=\"body\"
            Content-Type: text/plain

            Cuerpo de la noticia
            -----BOUNDARY
            """.data(using: .utf8)*/
            
            
        /*urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("c28684740cf2156cee9541eb47d061f4570593110fc72f021686caba29dc6f72", forHTTPHeaderField: "Authorization")*/
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: {
          data, res, err in
            
            if let err = err {
                completion(.failure(err))
                return
            }
            
            guard let data = data else {
                return
            }
            print(String(data: data, encoding: .utf8)!)
            
            
            DispatchQueue.main.async {
            do {
                
             let decodedData = try JSONDecoder().decode([NewActivity].self, from: data)
                completion(.success(decodedData))
            }
            catch {
                //Muestro mensaje de error en caso de un error de decodificacion
                print("Error en la descarga. ", error)
                completion(.failure(error))
            }
            }
        }).resume()
    }
}

class UnderlinedLabel: UILabel {

    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSRange(location: 0, length: text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(.underlineStyle,
                                        value: NSUnderlineStyle.single.rawValue,
                                        range: textRange)
            // Add other attributes if needed
            self.attributedText = attributedText
        }
    }
}
