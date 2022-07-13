//
//  ViewController.swift
//  Divisibles
//
//  Created by Iván González on 1/2/22.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

//    Creo las diferentes variables
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var datos: UILabel!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var boton: UIButton!
    @IBOutlet weak var progresoBarra: UIProgressView!
    @IBOutlet weak var conteo: UILabel!
    var contador = 1
    var divisores = 0
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.datos.text = "Los numeros son: \(poner)"
//        Dejo el spinner oculto para que no se vea hasta que se haga el cálculo
        self.spinner.isHidden = true
        
        
//        Se pide permisos a la aplicación
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]){ (granted, error) in
            if granted{
                print("Permiso concedido")
            }else {
                print("permiso denegado")
                print(error)
            }
            
        }
    }

    @IBAction func numero(_ sender: UITextField) {
       
    }

    
    
    @IBAction func boton(_ sender: UIButton) {
        
        calculo()
        
      
    }
    
//    He creado una función para tenerlo todo más colocado
    func calculo(){

      
        var todo : [Int] = []
        let numerito = number.text!
        let progressBarr = progresoBarra

    
//        Lo meto de forma asíncrona
        DispatchQueue.global().async {
            if(Int(numerito) ?? 0 < 0){
                    DispatchQueue.main.async {
                        self.datos.text = "Debe de introducir un número válido"
                    }
                }else{
                    while (self.contador <= Int(numerito) ?? 0){
                        if(Int(numerito)!%self.contador == 0){
                            print(self.contador)
//                            Meto los datos en un array para poder mostrarlos
                            todo.append(self.contador)
                            self.divisores += 1
                            self.contador += 1
                            DispatchQueue.main.async {
//                                Se deja ver el spinner y comienza la animación
                                self.spinner?.isHidden = false
                                self.spinner?.startAnimating()
//                                realizo el cálculo para que la barra de progreso vaya avanzando
                                self.datos.text = "Cargando... \(round(Float(self.contador - 1) / Float(numerito)! * 100))%"
                                progressBarr?.isHidden = false
                                progressBarr?.progress = Float(self.contador - 1) / Float(numerito)!
                            }
                        }else{
                            self.contador += 1
                        }
                    }
//                    Se realiza la notificación
                    let content = UNMutableNotificationContent()
                    content.title = "Proceso Acabado al \(Int(self.contador - 1) / (Int(numerito) ?? 1) * 100) %"
                    content.subtitle = "Ya tiene el resultado"
                    content.body = "los divisores del número \(numerito) son : \(self.divisores)"
                    content.sound = .default
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    var request = UNNotificationRequest(identifier: "idnotificacion", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request){ (error) in
                        print(error)
//                        Termino el proceo parando el spinner, mostrando el array y volviendo a ocultar la barra de progreso
//                        Oculto también el Keyboard cuando acaba el cálculo
                        DispatchQueue.main.async {
                            self.datos.text = "Proceso acabado al \(Int(self.contador - 1) / (Int(numerito) ?? 1) * 100) %, Introduce otro número"
                            progressBarr?.isHidden = true
                            self.spinner.stopAnimating()
                            self.spinner.isHidden = true
                            self.view.endEditing(true)
                            self.conteo.isHidden = false
                            self.conteo.text = "\(todo)"
                        }
                    }
                }
        }
//        Reseteo tanto los divisores como el contador
        self.contador = 1
        self.divisores = 0
    }
}

