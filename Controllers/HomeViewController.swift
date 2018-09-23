//
//  HomeViewController.swift
//  Tindog
//
//  Created by Maiqui Cedeño on 9/21/18.
//  Copyright © 2018 PosetoStudio. All rights reserved.
//

import UIKit

//Se crea esta clase para configurar la imagen del titulo.
class NavigationImageView: UIImageView {
    
    //sizeThatFits solicita la vista para poder calcular el tamaño que mejor se adapta a ella.
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        return CGSize(width: 76, height: 39)     // 76 y 39 son las medidas del icono en Sketch.
    }
    
}

class HomeViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!            //Referencia al objeto Cards.
    @IBOutlet weak var homeWrapper: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Imagen del titulo
        let tittleView = NavigationImageView()          //Objeto de la clase NavigationImageView.
        tittleView.image = UIImage(named: "Actions")    //Inicializamos la imagen.
        self.navigationItem.titleView = tittleView      //Agregamos la imagen al Navigation bar
        
        //UIPanGestureRecognizer es una clase para el manejo de gestos en la pantalla.
        //self significa que el target sera todo el objeto Cards.
        //#selector es una directiva del preprocesador, el cual representa el nombre de un metodo mas no su implementacion.
        //cardDragged es la funcion que configura las acciones del gesto en pantalla.
        let homeGR = UIPanGestureRecognizer(target: self, action: #selector(cardDragged(gestureRecognizer:)))
        
        //Adjunta un Gesture Recognizer a la vista, su parametro es la variable que contiene el gesto.
        self.cardView.addGestureRecognizer(homeGR)
        
        
    }
    
    //cardDragged es la funcion que configura las acciones del gesto en pantalla.
    //@objc es una directiva del compilador, que debe ser utlizada cuando se utlizan clases, protocolos o directivas heredadas de Objective-C, como #selector por ejemplo.
    @objc func cardDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        //translation es un metodo de instancia que retorna la nueva localizacion de una vista despues de haberse trasladado.
        //print("Drag \(gestureRecognizer.translation(in: view))" )
        
        //Variable que contiene el punto donde se movio la cardView.
        //translation es un metodo de instancia que retorna la nueva localizacion de una vista despues de haberse trasladado.
        let cardPoint = gestureRecognizer.translation(in: view)
        
        //Modificamos el centro de la cardView dinamicamente.
        //Sumamos la traslacion a cada una de las componentes del centro de la vista.
        //self.view.bounds representa el rectangulo de la vista.
        self.cardView.center = CGPoint(x: self.view.bounds.width / 2 + cardPoint.x, y: self.view.bounds.height / 2 + cardPoint.y)
        
        /********* Efecto de rotacion ************/
        //Distancia entre el centro de la vista y el centro del cardView.
        let xFromCenter = self.view.bounds.width / 2 - self.cardView.center.x
        //CGAffineTransform es una matriz 3x3 de tipo estructura, usada para rotar, escalar o trasladar cualquier vista.
        //Se divide entre 1000 para dismuniur el valor.
        var rotate = CGAffineTransform(rotationAngle: xFromCenter / 1000)
        
        //min compara dos valores y retorna el menor.
        //(100 / abs(xFromCenter) retornara un valor menor que 1, dado que la distancia minima de Like o disLike es 100.
        let scale = min(100 / abs(xFromCenter), 1)
        var finalTransform = rotate.scaledBy(x: scale, y: scale)
        
        self.cardView.transform = finalTransform
        
        //UIGestureRecognizer.State es una enumeracion que contiene los eventos discretos y define el estado del gesto.
        //ended es cuando el evento continuo ha terminado.
        if gestureRecognizer.state == .ended {
            
            //Para saber si se movio a la izquierdad o a la derecha.
            //print(self.cardView.center.x)
            
            print(xFromCenter)
            
            //Si es Like o disLike...
            if self.cardView.center.x < self.view.bounds.width / 2 - 100 {
                
                print("disLike")
            }
            
            if self.cardView.center.x > self.view.bounds.width / 2 + 100 {
                
                print("Like")
            }
            
            //Se reinicia la rotacion.
            rotate = CGAffineTransform(rotationAngle: 0)
            
            //Se reinicia la transform
            finalTransform = rotate.scaledBy(x: 1, y: 1)
            
            //Se actualiza el transform de la vista.
            self.cardView.transform = finalTransform
            
            
            
            //Se reinicia la vista.
            //Se restan 30 puntos de la componente en y por un desfase que tenemos, cuanso se reposiciona la vista queda muy abajo.
            self.cardView.center = CGPoint(x: self.homeWrapper.bounds.width / 2, y: self.homeWrapper.bounds.height / 2 - 30)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
