
import SpriteKit
import GameplayKit

class ConfigScene:SKScene {
    
    lazy var backName:String = {return self.userData?["backSaved"] as? String ?? "configScene"}()
    var soundText = SKLabelNode(text: "Sim")
   
    let backgroundSound = SKAudioNode(fileNamed: "telecom-leeRosevere")
    
     // criamos a referência o gerenciador de entidades
     var entityManager: EntityManager!
    
    override func didMove(to view: SKView) {
        startBackgroundSound()
        // cria uma instância do gerenciador de entidades
        entityManager = EntityManager(scene: self)

        
        drawView()
        
 }

    func drawView(){
        //adiciona background
        let background = SKSpriteNode(imageNamed: "background")
        background.name = "background"
        background.position = CGPoint(x: size.width/2, y: size.height/2)
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
            spriteComponent.node.position = CGPoint(x: size.width/2, y: size.height/2)
            spriteComponent.node.zPosition = ZPositionsCategories.tab
        }
        entityManager.add(settingsTab)
        
        //adiciona botão sound left


        let settingsLeft = HudButton(name: "settings-sound-button-left")
        if let spriteComponent = settingsLeft.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: size.width/2, y: size.height/2 + 27)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(settingsLeft)
        
        //adiciona barra sound


        let settingsSound = HudButton(name: "settings-sound-button")
        if let spriteComponent = settingsSound.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: size.width/2 + 80, y: size.height/2 + 27)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(settingsSound)
        
        //adiciona botão sound right


        let settingsRight = HudButton(name: "settings-sound-button-right")
        if let spriteComponent = settingsRight.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: size.width/2 + 160, y: size.height/2 + 27)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(settingsRight)
        
        //adiciona nameImput


        let settingsName = HudButton(name: "settings-name-input-text")
        if let spriteComponent = settingsName.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: size.width/2 + 80, y: size.height/2 - 18)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(settingsName)
        
        //adiciona container Name


        let confirmContainerName = HudButton(name: "confirm-container")
        if let spriteComponent = confirmContainerName.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: size.width/2 + 160, y: size.height/2 - 18)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(confirmContainerName)
        
        //adiciona check Name


        let checkName = HudButton(name: "confirm-checkmark")
        if let spriteComponent = checkName.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: size.width/2 + 160, y: size.height/2 - 18)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(checkName)
        
        //adiciona botão de reset progresso
        let resetProgress = HudButton(name: "settings-reset-progress-button")
        if let spriteComponent = resetProgress.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: size.width/2 - 95, y: size.height/2 - 60)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(resetProgress)
        
        //adiciona soundText
        soundText.name = "Sim"
        soundText.fontColor = UIColor(displayP3Red: 116/255, green: 255/255, blue: 234/255, alpha: 1.0)
        soundText.fontSize = 14
        soundText.fontName = "8bitoperator"
        soundText.verticalAlignmentMode = .center
        soundText.horizontalAlignmentMode = .center
        soundText.position = CGPoint(x: size.width/2 + 80, y: size.height/2 + 27)
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
                if soundText.name == "Sim" {
                    UserDefaults.standard.set(true, forKey: "SettingsSound")
                }else{
                    UserDefaults.standard.set(true, forKey: "SettingsSound")
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
 //       for touch in touches {
//            let location = touch.location(in: self)
//            if locationAnterior.x < location.x {
//                if self.posicao > 0 {
//                    moveMap(direction: Direction.backward)
//                    self.posicao -= 1
//                }
//            } else {
//                if self.posicao < 150 {
//                    moveMap(direction: Direction.forward)
//                    self.posicao += 1
//                }
//            }
//            locationAnterior = location
//        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let location = touch.location(in: self)
//            if location == touchesBeganLocation {
//                let nodes = self.nodes(at: location)
//                if nodes[0].name?.contains("stage-available") ?? false {
//                    let gameScene = GameScene(size: view!.bounds.size)
//                    view!.presentScene(gameScene)
//                }
//            }
//        }
            
        //verifica se clicou no botão voltar
        for touch in touches {
            let nodes = self.nodes(at: touch.location(in: self))
            let returnButtonOptional = self.childNode(withName: "return-button")
            
            if let returnButton = returnButtonOptional {
                if nodes.contains(returnButton) {
                    switch self.backName {
                    case "mapScene":
                        let mapScene = MapScene(size: view!.bounds.size)
                        view!.presentScene(mapScene)
                    case "gameScene":
                        let gameScene = GameScene(size: view!.bounds.size)
                        view!.presentScene(gameScene)
                    default:
                        let mapScene = MapScene(size: view!.bounds.size)
                        view!.presentScene(mapScene)
                    }
                }
            }
        }
    }
    
}


