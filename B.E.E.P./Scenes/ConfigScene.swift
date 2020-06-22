
import SpriteKit
import GameplayKit

class ConfigScene:SKScene, UITextFieldDelegate {
    
    lazy var backName:String = {return self.userData?["backSaved"] as? String ?? "configScene"}()
    
    let defalts = UserDefaults.standard
    var soundText = SKLabelNode()
    var userName: String? = ""
    var configAnchor: CGPoint!
    
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
        
        //Verifica teclado 
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.view?.addGestureRecognizer(tapGesture)
        
        // cria uma instância do gerenciador de entidades
        entityManager = EntityManager(scene: self)
        
        //implementa persistência
        
        if  defalts.object(forKey: "userGame") != nil {
            userName = defalts.object(forKey: "userGame") as? String
            // add check
            let checkName = HudButton(name: "confirm-checkmark")
            if let spriteComponent = checkName.component(ofType: SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: configAnchor.x + 160, y: configAnchor.y - 18)
                spriteComponent.node.zPosition = ZPositionsCategories.configOptions
            }
            entityManager.add(checkName)
           
        }
        
        if  defalts.object(forKey: "SettingsSound") != nil {
            soundText.text = defalts.object(forKey: "SettingsSound") as? String
        } else {
            soundText.text = "Sim"
        }
        defalts.set(soundText.text, forKey: "SettingsSound")
        soundText.name = soundText.text
        
        drawView(configAnchor)
        
        // add uitextfild
        textFieldName.delegate = self
        textFieldName.text = userName
        self.view!.addSubview(textFieldName)
        
        checkNotification()

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
                default:
                    soundText.text = "Sim"
                    soundText.name = "Sim"
                }
                defalts.set(soundText.text, forKey: "SettingsSound")
                
            }
            
            if (self.atPoint(location).name == "settings-reset-progress-button") {
                
                let alert = UIAlertController(title: "Resetar progresso", message: "Você tem certeza?", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Sim", style: .destructive, handler: .some({ (alert: UIAlertAction!) in
                    self.defalts.set(0 , forKey: "indexStage")
                    self.defalts.synchronize()
                    print("estou aqui")
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
            
        //verifica se clicou no botão voltar
        for touch in touches {
            let nodes = self.nodes(at: touch.location(in: self))
            let returnButtonOptional = self.childNode(withName: "return-button")
            
            if let returnButton = returnButtonOptional {
                if nodes.contains(returnButton) {
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
                }
            }
            //removeNotification()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // aplico persitência de nome
        let userName = textField.text
        defalts.set(userName , forKey: "userGame")
        
        let checkName = HudButton(name: "confirm-checkmark")
        if let spriteComponent = checkName.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: configAnchor.x + 160, y: configAnchor.y - 18)
            spriteComponent.node.zPosition = ZPositionsCategories.configOptions
        }
        entityManager.add(checkName)
        
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
           textFieldName.resignFirstResponder()
       }
    
    @objc func onKeyboardHide (notification: Notification ) {
        let screenBounds = UIScreen.main.bounds
            let info = notification.userInfo!
            let keyboardFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let height = screenBounds.height - keyboardFrame.origin.y
        UIView.animate(withDuration: 0.2, delay: 0.0, animations: {

               self.view?.frame.origin.y = -height/2
            })

    }

    @objc func onKeyboardShow (notification: Notification ) {
        let screenBounds = UIScreen.main.bounds
            let info = notification.userInfo!
            let keyboardFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let height = screenBounds.height - keyboardFrame.origin.y
        UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
            self.view?.frame.origin.y = height/2
            })
       }
    

    func checkNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHide(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
  
    }

    func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    
}

