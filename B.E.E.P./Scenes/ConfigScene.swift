
import SpriteKit
import GameplayKit

class ConfigScene:SKScene, UITextFieldDelegate {
    
    lazy var backName:String = {return self.userData?["backSaved"] as? String ?? "configScene"}()

    let backgroundSound = SKAudioNode(fileNamed: "telecom-leeRosevere")
    
    let defaults = UserDefaults.standard
    var soundText = SKLabelNode()
    var userName: String? = ""
    var configAnchor: CGPoint!
    let totalDeFases = 6
    
    //  UITextFild do Name
    private lazy  var textFieldName: UITextField = {
        let textArchor = CGPoint(x: size.width/2, y: size.height/2)
        let textFieldFrame = CGRect(origin:.init(x: textArchor.x + 25, y: textArchor.y + 2), size: CGSize(width: 110, height: 30))
        let textFieldName = UITextField(frame: textFieldFrame)
        textFieldName.borderStyle = UITextField.BorderStyle.roundedRect
        textFieldName.backgroundColor = UIColor.clear
        textFieldName.textColor = UIColor(displayP3Red: 73/255, green: 64/255, blue: 115/255, alpha: 1.0)
        textFieldName.placeholder = "Name"
        textFieldName.font = UIFont(name: "8bitoperator", size: 14)
        textFieldName.autocorrectionType = UITextAutocorrectionType.yes
        textFieldName.keyboardType = UIKeyboardType.alphabet
        textFieldName.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        return textFieldName
    }()
    
    // criamos a referência o gerenciador de entidades
    var entityManager: EntityManager!
    
    override func didMove(to view: SKView) {

        //Set Anchor
        configAnchor = CGPoint(x: size.width/2, y: size.height/2)
        
        
        // cria uma instância do gerenciador de entidades
        entityManager = EntityManager(scene: self)
        
        //implementa persistência
        if  (defaults.object(forKey: "userGame") != nil) && (defaults.object(forKey: "userGame") as? String != ""){
            userName = defaults.object(forKey: "userGame") as? String
            drawCheck()
        }
        
        if  defaults.object(forKey: "SettingsSound") != nil {
            soundText.text = defaults.object(forKey: "SettingsSound") as? String
        } else {
            soundText.text = "Sim"
        }
        if soundText.text == "Sim" {
            startBackgroundSound()
        }
        defaults.set(soundText.text, forKey: "SettingsSound")
        soundText.name = soundText.text
        
        drawView(configAnchor)
        
        // add uitextfild
        textFieldName.delegate = self
        textFieldName.text = userName
        self.view!.addSubview(textFieldName)
        
        checkNotification()
        
        let checkName = SKSpriteNode(imageNamed: "confirm-checkmark")
        checkName.name = "confirm-checkmark"
        checkName.position = CGPoint(x: configAnchor.x + 160, y: configAnchor.y - 18)
        checkName.zPosition = ZPositionsCategories.configOptions


 }

    func drawView(_ configArchor: CGPoint){
        //adiciona background
        let background = SKSpriteNode(imageNamed: "background")
        background.name = "background"
        background.position = CGPoint(x: configAnchor.x, y: configAnchor.y)
        background.size = CGSize(width: size.width, height: size.height)
        addChild(background)

   
        //adiciona botão return
        let returnButton = HudButton(name: "return-button")
        if let spriteComponent = returnButton.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: frame.minX + 50, y: frame.maxY - 50)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(returnButton)

        
        // adiciona a aba de configurações
        let settingsTab = DefaultObject(name: "settings-tab")
        if let spriteComponent = settingsTab.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: configAnchor.x, y: configAnchor.y)
            spriteComponent.node.zPosition = ZPositionsCategories.tab
        }
        entityManager.add(settingsTab)
        
        //adiciona botão sound left
        let settingsLeft = HudButton(name: "settings-sound-button-left")
        if let spriteComponent = settingsLeft.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: configAnchor.x, y: configAnchor.y + 27)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(settingsLeft)
        
        //adiciona barra sound
        let settingsSound = HudButton(name: "settings-sound-button")
        if let spriteComponent = settingsSound.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: configAnchor.x + 80, y: configAnchor.y + 27)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(settingsSound)
        
        //adiciona botão sound right
        let settingsRight = HudButton(name: "settings-sound-button-right")
        if let spriteComponent = settingsRight.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: configAnchor.x + 160, y: configAnchor.y + 27)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(settingsRight)
        
        //adiciona nameImput
        let settingsName = HudButton(name: "settings-name-input-text")
        if let spriteComponent = settingsName.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: configAnchor.x + 80, y: configAnchor.y - 18)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(settingsName)
        
        //adiciona container Name
        let confirmContainerName = HudButton(name: "confirm-container")
        if let spriteComponent = confirmContainerName.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: configAnchor.x + 160, y: configAnchor.y - 18)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(confirmContainerName)
        
        //adiciona check Name
        let checkName = HudButton(name: "confirm-checkmark")
        if let spriteComponent = checkName.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: configAnchor.x + 160, y: configAnchor.y - 18)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(checkName)
        
        //adiciona botão de reset progresso
        let resetProgress = HudButton(name: "settings-reset-progress-button")
        if let spriteComponent = resetProgress.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: configAnchor.x - 95, y: configAnchor.y - 60)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(resetProgress)
        
        //adiciona soundText
        soundText.fontColor = UIColor(displayP3Red: 116/255, green: 255/255, blue: 234/255, alpha: 1.0)
        soundText.fontSize = 14
        soundText.fontName = "8bitoperator"
        soundText.verticalAlignmentMode = .center
        soundText.horizontalAlignmentMode = .center
        soundText.position = CGPoint(x: configAnchor.x + 80, y: configAnchor.y + 27)
        soundText.zPosition = ZPositionsCategories.configOptions
        addChild(soundText)
   }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if (self.atPoint(location).name == "settings-sound-button-left") || (self.atPoint(location).name == "settings-sound-button-right") {
                switch soundText.name {
                case "Sim":
                    soundText.name = "Não"
                    soundText.text = "Não"
                    self.pauseBackgroundSound()
                default:
                    soundText.text = "Sim"
                    soundText.name = "Sim"
                    self.startBackgroundSound()
                }
                defaults.set(soundText.text, forKey: "SettingsSound")
                
            }
            
            if (self.atPoint(location).name == "settings-reset-progress-button") {
                
                let alert = UIAlertController(title: "Resetar progresso", message: "Você tem certeza?", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Sim", style: .destructive, handler: .some({ (alert: UIAlertAction!) in

                    

                    UserDefaults.standard.set(true, forKey: "isFirstTime")
                    UserDefaults.standard.set(1, forKey: "lastStageAvailable")
                    

                   

                    for i in 1...self.totalDeFases {
                        let stage = BaseOfStages.buscar(id: "\(i)")
                        if i == 1 {
                            stage?.status = "available"
                            stage?.isAtualFase = true
                            self.defaults.set(i, forKey: "selectedFase")
                            self.defaults.synchronize()
                        } else {
                            stage?.status = "unavailable"
                            stage?.isAtualFase = false
                        }
                        BaseOfStages.salvar(stage: stage!)
                    }
                })))
                
                alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
               
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view?.bounds.midX ?? 17, y: self.view?.bounds.midY ?? 0, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                
                if let vc = self.scene?.view?.window?.rootViewController {
                    vc.present(alert, animated: true, completion: nil)
                }
         
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if (self.atPoint(location).name == "return-button") {
                switch self.backName {
                case "mapScene":
                    textFieldName.removeFromSuperview()
                    let mapScene = MapScene(size: view!.bounds.size)
                    view!.presentScene(mapScene)
                case "gameScene":
                    textFieldName.removeFromSuperview()
                    let gameScene = GameScene(size: view!.bounds.size)
                    view!.presentScene(gameScene)
                default:
                    textFieldName.removeFromSuperview()
                    let mapScene = MapScene(size: view!.bounds.size)
                    view!.presentScene(mapScene)
                }
                removeNotification()
            }
            
        }
    }
    func drawCheck(){
        let checkName = HudButton(name: "confirm-checkmark")
        if let spriteComponent = checkName.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: configAnchor.x + 160, y: configAnchor.y - 18)
            spriteComponent.node.zPosition = ZPositionsCategories.configOptions
        }
        entityManager.add(checkName)
    }

    func removeCheck() {
        if (self.atPoint(CGPoint(x: configAnchor.x + 160, y: configAnchor.y - 18)).name == "confirm-checkmark") {
            //self.atPoint(CGPoint(x: configAnchor.x + 160, y: configAnchor.y - 18)).removeFromParent() //.removeComponent(ofType: SpriteComponent.self)
            let checkName = (self.atPoint(CGPoint(x: configAnchor.x + 160, y: configAnchor.y - 18)))
            checkName.removeFromParent()
        }
 
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // aplico persitência de nome
        let userName = textField.text
        if userName != "" {
            defaults.set(userName , forKey: "userGame")
            drawCheck()
        } else {
            defaults.set("" , forKey: "userGame")
             removeCheck()
            self.reloadInputViews()
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let checkFrame = CGRect(origin: CGPoint(x: self.configAnchor.x + 140, y: self.configAnchor.y - 3), size: CGSize(width: 40, height: 40))
        let checkView = UIView(frame: checkFrame)
        checkView.backgroundColor = .clear
        self.view?.addSubview(checkView)
        // add gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        checkView.addGestureRecognizer(tapGesture)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let userName = textField.text
        if userName != "" {
            defaults.set(userName , forKey: "userGame")
            drawCheck()
        } else {
            defaults.set("" , forKey: "userGame")
            removeCheck()
            self.reloadInputViews()
        }
    }
   
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
              textFieldName.resignFirstResponder()
          }
  
    @objc func onKeyboardHide (notification: Notification) {
        let screenBounds = UIScreen.main.bounds
            let info = notification.userInfo!
            let keyboardFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let height = screenBounds.height - keyboardFrame.origin.y
        UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
            self.view?.frame.origin.y = height/2
            self.view?.layoutIfNeeded()
      })

    }

    @objc func onKeyboardShow (notification: Notification) {
        let screenBounds = UIScreen.main.bounds
            let info = notification.userInfo!
            let keyboardFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let height = screenBounds.height - keyboardFrame.origin.y
        UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
            self.view?.frame.origin.y = -height/2
            self.view?.layoutIfNeeded()
           })
       }
    
    func checkNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
   }

    func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
}



