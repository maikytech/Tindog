//
//  HomeViewController.swift
//  Tindog
//
//  Created by Maiqui Cedeño on 9/21/18.
//  Copyright © 2018 PosetoStudio. All rights reserved.
//

import UIKit
import RevealingSplashView          //Libreria para la configuracion del LaunchScreen tipo twitter.
import Firebase

//Se crea esta clase para configurar la imagen del titulo.
class NavigationImageView: UIImageView {
    
    //se sobreescribe sizeThatFits, esta funcion pregunta a la vista para poder calcular el tamaño que mejor se adapta a ella, su implementacion es por default.
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        return CGSize(width: 76, height: 39)     // 76 y 39 son las medidas del icono en Sketch..
    }
}

class HomeViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var homeWrapper: UIStackView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var nopeImage: UIImageView!
    
    let leftBtn = UIButton(type: .custom)       //Boton de acceso al area de Login, se crea por codigo.
    
    //Varible para crear el efecto del Launchscreen tipo twitter.
    let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "splash_icon")!, iconInitialSize: CGSize(width: 80, height: 80), backgroundColor: UIColor.white)
    
    var currentUserProfile: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.launchScreenConfig(revealingSplashView: revealingSplashView)
        self.tittleViewConfig()
        self.UIGestureConfig()
        self.buttonLoginConfig(leftBtn: leftBtn)
        self.observeData()
    }
    
    func launchScreenConfig(revealingSplashView: RevealingSplashView) {
        
        self.view.addSubview(revealingSplashView)
        self.revealingSplashView.animationType = SplashAnimationType.popAndZoomOut
        self.revealingSplashView.startAnimation()
    }
    
    //Manual creation of the tittle image of app.
    func tittleViewConfig() {
        
        let tittleView = NavigationImageView()
        tittleView.image = UIImage(named: "Actions")    //Inicializamos la imagen.
        self.navigationItem.titleView = tittleView      //Agregamos la imagen al Navigation bar en el centro.
    }
    
    //Configuration of the gesture of sliding the image
    func UIGestureConfig() {
        
        //UIPanGestureRecognizer es una clase para el manejo de gestos en la pantalla.
        //self significa que el target es toda la pantalla.
        //#selector es una directiva del preprocesador, el cual representa el nombre de un metodo mas no su implementacion.
        //cardDragged es la funcion que configura las acciones del gesto en pantalla.
        let homeGR = UIPanGestureRecognizer(target: self, action: #selector(cardDragged(gestureRecognizer:)))
        
        //Adjunta un Gesture Recognizer a la vista, su parametro es la variable que contiene el gesto.
        self.cardView.addGestureRecognizer(homeGR)
    }
    
    //Funcion que configura las acciones del gesto en pantalla.
    //@objc es una directiva del compilador, que debe ser utlizada cuando se utlizan clases, protocolos o directivas heredadas de Objective-C, como #selector por ejemplo.
    @objc func cardDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        //Variable que contiene el punto donde se movio la cardView.
        //translation es un metodo de instancia que retorna la nueva localizacion de una vista despues de haberse trasladado.
        let cardPoint = gestureRecognizer.translation(in: view)
        
        //Modificamos el centro de la cardView dinamicamente.
        //Sumamos la traslacion a cada una de las componentes del centro de la vista.
        //self.view.bounds representa el rectangulo de la vista.
        self.cardView.center = CGPoint(x: self.view.bounds.width / 2 + cardPoint.x, y: self.view.bounds.height / 2 + cardPoint.y)
        
        //Efecto de rotacion.
        //Distancia entre el centro de la vista y el centro del cardView.
        let xFromCenter = self.view.bounds.width / 2 - self.cardView.center.x
        
        //CGAffineTransform es una matriz 3x3 de tipo estructura, usada para rotar, escalar o trasladar cualquier vista.
        //Se divide entre 1000 para dismuniur el valor.
        var rotate = CGAffineTransform(rotationAngle: xFromCenter / 500)
        
        //Con scale hacemos mas pequeña la fotografia a medida que rota.
        //min compara dos valores y retorna el menor.
        //(100 / abs(xFromCenter) retornara un valor menor que 1, dado que la distancia minima de Like o disLike es 100.
        let scale = min(100 / abs(xFromCenter), 1)
        var finalTransform = rotate.scaledBy(x: scale, y: scale)
        
        self.cardView.transform = finalTransform
        
        //Si es Like o disLike...
        if self.cardView.center.x < self.view.bounds.width / 2 - 100 {
            
            self.nopeImage.alpha = min(abs(xFromCenter) / 100, 1)
            self.likeImage.alpha = 0
        }
        
        if self.cardView.center.x > self.view.bounds.width / 2 + 100 {
            
            self.likeImage.alpha = min(abs(xFromCenter) / 100, 1)
            self.nopeImage.alpha = 0
        }
        
        //Configuracion cuando el evento ha terminado.
        //UIGestureRecognizer.State es una enumeracion que contiene los eventos discretos y define el estado del gesto.
        if gestureRecognizer.state == .ended {
            
            //Condiciones iniciales.
            rotate = CGAffineTransform(rotationAngle: 0)
            finalTransform = rotate.scaledBy(x: 1, y: 1)
            self.cardView.transform = finalTransform
            self.likeImage.alpha = 0
            self.nopeImage.alpha = 0
            
            //Se reinicia la vista.
            //Se restan 30 puntos de la componente en y por un desfase que tenemos, cuando se reposiciona la vista queda muy abajo.
            self.cardView.center = CGPoint(x: self.homeWrapper.bounds.width / 2, y: self.homeWrapper.bounds.height / 2 - 30)
        }
    }
    
    //Manual creation of Login button
    func buttonLoginConfig(leftBtn: UIButton) {
        
        //Se crea el contenMode que contendra el boton.
        self.leftBtn.imageView?.contentMode = .scaleAspectFit
        
        //Creacion del Button Item para poder agregarlo al Navigation Bar en el lado izquierdo.
        //UIBarButtonItem is a button specialized for placement on a toolbar or tab bar.
        let leftBarButton = UIBarButtonItem(customView: self.leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func observeData() {
        
        //Se crea la instancia singleton llamando a la funcion observeUserProfile definida en el DataBaseService.
        //El @escaping es una variable UserModel que retornara al final de la funcion.
        DataBaseService.instance.observeUserProfile {(UserDic) in
            
            //currentUserProfile recibe toda la informacion del usuario parseada.
            self.currentUserProfile = UserDic
        }
    }
    
    //Funcion de configuracion cuando esta vista vuelve a ser la vista principal.
    override func viewDidAppear(_ animated: Bool) {
        
        loginModalViewConfig(leftBtn: leftBtn)
    }
    
    func loginModalViewConfig(leftBtn: UIButton) {
        
        if Auth.auth().currentUser != nil {
            
            //Boton de login en rojo.
            self.leftBtn.setImage(UIImage(named: "login_active"), for: .normal)
            self.leftBtn.removeTarget(nil, action: nil, for: .allEvents)
            self.leftBtn.addTarget(self, action: #selector(goToProfile(sender:)), for: .touchUpInside)
            
        }else {
            
            //Boton de login en gris.
            self.leftBtn.setImage(UIImage(named: "login"), for: .normal)
            self.leftBtn.removeTarget(nil, action: nil, for: .allEvents)
            self.leftBtn.addTarget(self, action: #selector(goToLogin(sender:)), for: .touchUpInside)
        }
    }
    
    //Configuration of modal view of pofile.
    @objc func goToProfile(sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let profileViewController = storyBoard.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
        
        //profileViewController.currentUserProfile es la variable declarada en la clase ProfileViewController.
        //self.currentUserProfile es la variable declarada en HomeViewController.
        profileViewController.currentUserProfile = self.currentUserProfile
        present(profileViewController, animated: true, completion: nil)
    }
    
    //Configuration of modal view of Login.
    @objc func goToLogin(sender: UIButton) {
        
        //Referencia al Main.storyboard
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        //instantiateViewController instancia la vista cuyo identificador es loginVC y lo presenta modalmente.
        //LoginVC es el ID del view controller de la vista de login.
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "loginVC")
        present(loginViewController, animated: true, completion: nil)
    }
}
