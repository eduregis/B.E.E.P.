import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // variáveis que irão receber os valores da API
    var actualPosition = CGPoint(x: 1, y: 1)
    var stageDimensions = CGSize(width: 5, height: 6)
    var gameplayAnchor: CGPoint!
    var auxiliaryAnchor: CGPoint!
    var actualDirection = "right"
    var tabStyle = "function"
    
    // criamos a referência o gerenciador de entidades
    var entityManager: EntityManager!
    
    // instanciamos esse aqui fora porque precisamos deles depois que são desenhados
    let robot = Robot()
    let lightFloor = LightFloor()
    
    var functionBlocks: [DraggableBlock] = []
    var emptyFunctionBlocks: [EmptyBlock] = []
    var functionDropZoneIsTouched: Bool = false
    
    var commandBlocks: [DraggableBlock] = []
    var emptyBlocks: [EmptyBlock] = []
    var commandDropZoneIsTouched: Bool = false
    
    // variáveis de controle
    var selectedItem: SKSpriteNode? {
        didSet {
            if let selectedPlayer = self.selectedItem {
                draggingItem = SKSpriteNode(imageNamed: "\(selectedPlayer.name ?? "")")
                draggingItem?.name = selectedPlayer.name
                draggingItem?.position = CGPoint(x: selectedPlayer.position.x, y: selectedPlayer.position.y)
                draggingItem?.size = CGSize(width: selectedPlayer.size.width * 1.5, height: selectedPlayer.size.height * 1.5)
                draggingItem?.zPosition = ZPositionsCategories.draggableBlock
                draggingItem?.alpha = 0.5
                addChild(draggingItem!)
            }
        }
    }
    var draggingItem: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        // posiciona os elementos de acordo como tipo de fase
        switch tabStyle {
        case "default":
            gameplayAnchor = CGPoint(x: size.width/2, y: size.height/2)
            auxiliaryAnchor = CGPoint(x: size.width/2, y: size.height/2)
        case "function", "antivirus", "loop", "conditional":
            gameplayAnchor = CGPoint(x: size.width/3, y: size.height/2)
            auxiliaryAnchor = CGPoint(x: 3*size.width/4, y: size.height/2)
        default:
            gameplayAnchor = CGPoint(x: size.width/2, y: size.height/2)
            auxiliaryAnchor = CGPoint(x: size.width/2, y: size.height/2)
        }
        
        // adiciona o background
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.size = CGSize(width: size.width, height: size.height)
        background.zPosition = ZPositionsCategories.background
        addChild(background)
        
        // cria uma instância do gerenciador de entidades
        entityManager = EntityManager(scene: self)
        
        drawnReturnButton()
        
        drawTilesets(width: Int(stageDimensions.width), height: Int(stageDimensions.height))
        drawRobot(xPosition: Int(actualPosition.x), yPosition: Int(actualPosition.y))
        drawTabs()
        drawAuxiliaryTab()
        drawnConfigButton()
        drawnHintButton()
        
    }
    
    // desenha o tileset e seu corredor de luz de acordo com sua posição
    func drawTilesets(width: Int, height: Int) {
        for i in 1...width {
            for j in 1...height {
                
                // desenha o tileset
                let tileset = Tileset()
                if let spriteComponent = tileset.component(ofType: SpriteComponent.self) {
                    let x = gameplayAnchor.x + CGFloat(32 * (i - 1)) - CGFloat(32 * (j - 1))
                    let y = gameplayAnchor.y + 200 - CGFloat(16 * (i - 1)) - CGFloat(16 * (j - 1))
                    spriteComponent.node.position = CGPoint(x: x, y: y)
                    spriteComponent.node.zPosition = CGFloat(i + j)
                }
                entityManager.add(tileset)
                
                // desenha a luz do tileset
                let light = Light(xPosition: i, yPosition: j, maxX: width, maxY: height)
                if let spriteComponent = light.component(ofType: SpriteComponent.self) {
                    let x = gameplayAnchor.x + CGFloat(32 * (i - 1)) - CGFloat(32 * (j - 1))
                    let y = gameplayAnchor.y + 200 - CGFloat(16 * (i - 1)) - CGFloat(16 * (j - 1))
                    spriteComponent.node.position = CGPoint(x: x, y: y)
                    spriteComponent.node.zPosition = CGFloat(i + j + 2)
                }
                entityManager.add(light)
            }
        }
    }
    
    func drawRobot (xPosition: Int, yPosition: Int) {
        // desenha o chão iluminado embaixo do robô
        if let spriteComponent = lightFloor.component(ofType: SpriteComponent.self) {
            let x = gameplayAnchor.x + CGFloat(32 * (xPosition - 1)) - CGFloat(32 * (yPosition - 1))
            let y = gameplayAnchor.y + 200 - CGFloat(16 * (xPosition - 1)) - CGFloat(16 * (yPosition - 1))
            spriteComponent.node.position = CGPoint(x: x, y: y)
            spriteComponent.node.zPosition = CGFloat(actualPosition.x + actualPosition.y + 1)
            spriteComponent.node.alpha = 0.7
        }
        entityManager.add(lightFloor)
        
        // desenha o robô
        if let spriteComponent = robot.component(ofType: SpriteComponent.self) {
            let x = gameplayAnchor.x + CGFloat(32 * (xPosition - 1)) - CGFloat(32 * (yPosition - 1))
            let y = gameplayAnchor.y + 236 - CGFloat(16 * (xPosition - 1)) - CGFloat(16 * (yPosition - 1))
            spriteComponent.node.position = CGPoint(x: x, y: y)
            spriteComponent.node.zPosition = stageDimensions.width + stageDimensions.height + CGFloat(xPosition + yPosition + 1)
        }
        entityManager.add(robot)
    }
    
    func drawTabs () {
        // adiciona a aba de comandos
        let commandTab = DefaultObject(name: "command-tab")
        if let spriteComponent = commandTab.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: gameplayAnchor.x, y: gameplayAnchor.y - 100)
            spriteComponent.node.zPosition = ZPositionsCategories.tab
        }
        entityManager.add(commandTab)
        
        // adiciona a aba de limpar
        let clearTab = ClearTab(name: "command-clear-tab", spriteName: "clear-tab")
        if let spriteComponent = clearTab.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: gameplayAnchor.x - 20, y: gameplayAnchor.y - 65)
            spriteComponent.node.zPosition = ZPositionsCategories.clearTabButton
        }
        entityManager.add(clearTab)
        
        // container de drop
        let commandTabDropZone = DefaultObject(name: "command-tab-drop-zone")
        if let spriteComponent = commandTabDropZone.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: gameplayAnchor.x - 50, y: gameplayAnchor.y - 115)
            spriteComponent.node.zPosition = ZPositionsCategories.dropZone
        }
        entityManager.add(commandTabDropZone)
        
        // drop zones individuais
        for i in 1...6 {
            let block = EmptyBlock(name: "white-block")
            if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: gameplayAnchor.x - 175 + CGFloat(i - 1)*50, y: gameplayAnchor.y - 115)
                spriteComponent.node.zPosition = ZPositionsCategories.emptyBlock
                spriteComponent.node.alpha = 0.1
                spriteComponent.node.size = CGSize(width: 60, height: 50)
            }
            emptyBlocks.append(block)
            entityManager.add(block)
        }
        
        // botão de play
        let playButton = DefaultObject(name: "play-button")
        if let spriteComponent = playButton.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: gameplayAnchor.x + 170, y: gameplayAnchor.y - 115)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(playButton)
        
        // adiciona a aba de ações
        let actionTab = DefaultObject(name: "action-tab")
        if let spriteComponent = actionTab.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: gameplayAnchor.x, y: gameplayAnchor.y - 240)
            spriteComponent.node.zPosition = ZPositionsCategories.tab
        }
        entityManager.add(actionTab)
        
        // adiciona os blocos de ações
        for i in 1...blockTypes.count {
            let block = DraggableBlock(name: blockTypes[i - 1])
            if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: gameplayAnchor.x - 150 + CGFloat(i - 1)*75, y: gameplayAnchor.y - 255)
                spriteComponent.node.zPosition = ZPositionsCategories.draggableBlock
                spriteComponent.node.size = CGSize(width: 60, height: 50)
            }
            entityManager.add(block)
        }
    }
    
    func drawAuxiliaryTab() {
        let size: Int
        let yAjust: CGFloat
        if tabStyle != "default" {
            switch tabStyle {
            case "function","antivirus":
                size = 1
                yAjust = 240
            case "loop":
                size = 2
                yAjust = 148
            default:
                size = 3
                yAjust = 0
            }
            let auxiliaryTab = AuxiliaryTab(size: size)
            if let spriteComponent = auxiliaryTab.component(ofType: SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x, y: auxiliaryAnchor.y + yAjust)
                spriteComponent.node.zPosition = ZPositionsCategories.tab
            }
            entityManager.add(auxiliaryTab)
            drawFunctionTab()
        }
    }
    
    func drawFunctionTab() {
        // adiciona a aba de comandos
        let functionTab = DefaultObject(name: "function-tab")
        if let spriteComponent = functionTab.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x, y: auxiliaryAnchor.y + 225)
            spriteComponent.node.zPosition = ZPositionsCategories.subTab
        }
        entityManager.add(functionTab)
        
        // adiciona a aba de limpar
        let clearTab = ClearTab(name: "function-clear-tab", spriteName: "clear-tab")
        if let spriteComponent = clearTab.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x - 10, y: auxiliaryAnchor.y + 260)
            spriteComponent.node.zPosition = ZPositionsCategories.clearTabButton
        }
        entityManager.add(clearTab)
        
        // container de drop
        let functionTabDropZone = DefaultObject(name: "auxiliary-tab-drop-zone")
        if let spriteComponent = functionTabDropZone.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x + 50, y: auxiliaryAnchor.y + 210)
            spriteComponent.node.zPosition = ZPositionsCategories.dropZone
        }
        entityManager.add(functionTabDropZone)
        
        // drop zones individuais
        for i in 1...4 {
            let block = EmptyBlock(name: "white-block")
            if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x - 25 + CGFloat(i - 1)*50, y: auxiliaryAnchor.y + 210)
                spriteComponent.node.zPosition = ZPositionsCategories.emptyBlock
                spriteComponent.node.alpha = 0.1
                spriteComponent.node.size = CGSize(width: 60, height: 50)
            }
            emptyFunctionBlocks.append(block)
            entityManager.add(block)
        }
    }
    
    func clearTab (tabName: String) {
        switch tabName {
        case "command":
            for block in commandBlocks {
                if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                    spriteComponent.node.removeFromParent()
                }
            }
            commandBlocks.removeAll()
        case "function":
            for block in functionBlocks {
                if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                    spriteComponent.node.removeFromParent()
                }
            }
            functionBlocks.removeAll()
        default:
            break
        }
        
    }
    
    func turnRobot(direction: String) {
        // checa para qual lado o robô irá girar
        switch direction {
        case "left":
            // gira de acordo com a direção do robô
            switch actualDirection {
            case "up":
                actualDirection = "left"
            case "left":
                actualDirection = "down"
            case "down":
                actualDirection = "right"
            case "right":
                actualDirection = "up"
            default:
                break
            }
        case "right":
            switch actualDirection {
            case "up":
                actualDirection = "right"
            case "left":
                actualDirection = "up"
            case "down":
                actualDirection = "left"
            case "right":
                actualDirection = "down"
            default:
                break
            }
        default:
            break
        }
        if let robotMoveComponent = robot.component(ofType: RobotMoveComponent.self) {
            robotMoveComponent.turn(direction: actualDirection)
        }
    }
    
    func moveRobot() -> Bool {
        // checa se o robô pode andar para a posição apontada
        switch actualDirection {
        case "up":
            if (actualPosition.y == 1) {
                return false
            } else {
                actualPosition = CGPoint(x: actualPosition.x, y: actualPosition.y - 1)
            }
        case "left":
            if (actualPosition.x == 1) {
                return false
            } else {
                actualPosition = CGPoint(x: actualPosition.x - 1, y: actualPosition.y)
            }
        case "down":
            if (actualPosition.y == stageDimensions.height) {
                return false
            } else {
                actualPosition = CGPoint(x: actualPosition.x, y: actualPosition.y + 1)
            }
        case "right":
            if (actualPosition.x == stageDimensions.width) {
                return false
            } else {
                actualPosition = CGPoint(x: actualPosition.x + 1, y: actualPosition.y)
            }
        default:
            actualPosition = CGPoint(x: actualPosition.x, y: actualPosition.y)
        }
        
        // move o robô caso ele possa, fazendo a sua animação também
        if let robotMoveComponent = robot.component(ofType: RobotMoveComponent.self) {
            robotMoveComponent.move(direction: actualDirection)
        }
        
        // move o bloco luminoso embaixo do robô, quando ele termina o movimento
        if let lightFloorMoveComponent = lightFloor.component(ofType: LightFloorMoveComponent.self) {
            lightFloorMoveComponent.move(direction: actualDirection)
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // moveRobot()
        // turnRobot(direction: "left")
        if let location = touches.first?.location(in: self) {
            // Checamos o nome do SpriteNode que foi detectado pela função
            if (self.atPoint(location).name == "walk-block") || (self.atPoint(location).name == "turn-left-block") || (self.atPoint(location).name == "turn-right-block") || (self.atPoint(location).name == "grab-block") || (self.atPoint(location).name == "save-block") {
                // passamos o objeto detectado para dentro do selectedItem
                selectedItem = self.atPoint(location) as? SKSpriteNode
            }
            else {
                // caso não seja o objeto que queremos, esvaziamos o selectedItem
                selectedItem = nil
                if (self.atPoint(location).name == "play-button") {
                    // moveRobot()
                } else if (self.atPoint(location).name == "command-clear-tab") {
                    clearTab(tabName: "command")
                } else if (self.atPoint(location).name == "function-clear-tab") {
                    clearTab(tabName: "function")
                }
            }
            if let oldName = self.atPoint(location).name {
                // testa se selecionamos um bloco dentro da aba de comandos
                if oldName.contains("-dropped-") {
                    // se sim, ituilizamos o trecho "-dropped-" para separar obtermos o nome original e seu índice
                    var newName: [String] = []
                    var arrayName: String = ""
                    if oldName.contains("-dropped-command-") {
                        newName = self.atPoint(location).name!.components(separatedBy: "-dropped-command-")
                        arrayName = "command-"
                    } else if oldName.contains("-dropped-function-") {
                        newName = self.atPoint(location).name!.components(separatedBy: "-dropped-function-")
                        arrayName = "function-"
                    }
                    let newBlock = self.atPoint(location) as? SKSpriteNode
                    // removemos o sprite do bloco na tela, este passando a existir apenas no selectedItem à seguir
                    self.atPoint(location).removeFromParent()
                    // passamos apenas o nome original para o selectedItem
                    newBlock?.name = newName[0]
                    selectedItem = newBlock
                    // caso ele não seja o último da fila, precisamos trazer tudo à direita dele um passo para a esquerda.
                    if let indexToRemove = Int(newName[1]) {
                        // removemos o o bloco do array
                        switch arrayName {
                        case "command-":
                            commandBlocks.remove(at: indexToRemove)
                            // trazemos os blocos para a esquerda, ajustando tanto a posição do sprite quanto seu índice no final do nome
                            for index in indexToRemove..<commandBlocks.count {
                                if let spriteComponent = commandBlocks[index].component(ofType: SpriteComponent.self) {
                                    spriteComponent.node.position = CGPoint(x: spriteComponent.node.position.x - 50, y: spriteComponent.node.position.y)
                                    // a partir do nome antigo, remontamos dessa forma
                                    let oldIndex = spriteComponent.node.name?.components(separatedBy: "-dropped-command-")
                                    let newIndex = Int(oldIndex![1])! - 1
                                    spriteComponent.node.name = "\(oldIndex![0])-dropped-command-\(newIndex)"
                                }
                            }
                        case "function-":
                            functionBlocks.remove(at: indexToRemove)
                            // trazemos os blocos para a esquerda, ajustando tanto a posição do sprite quanto seu índice no final do nome
                            for index in indexToRemove..<functionBlocks.count {
                                if let spriteComponent = functionBlocks[index].component(ofType: SpriteComponent.self) {
                                    spriteComponent.node.position = CGPoint(x: spriteComponent.node.position.x - 50, y: spriteComponent.node.position.y)
                                    // a partir do nome antigo, remontamos dessa forma
                                    let oldIndex = spriteComponent.node.name?.components(separatedBy: "-dropped-function-")
                                    let newIndex = Int(oldIndex![1])! - 1
                                    spriteComponent.node.name = "\(oldIndex![0])-dropped-function-\(newIndex)"
                                }
                            }
                        default:
                            break
                        }
                        
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if draggingItem != nil {
            for touch in touches {
                let location = touch.location(in: self)
                draggingItem?.position.x = location.x
                draggingItem?.position.y = location.y
                // detecta a dropzone da aba de comandos
                if(commandBlocks.count < 6) {
                    if (location.y > gameplayAnchor.y - 143) && (location.y < gameplayAnchor.y - 93) && (location.x > gameplayAnchor.x - 200 + 50*CGFloat(commandBlocks.count)) && (location.x < gameplayAnchor.x + 120){
                        for i in 0...commandBlocks.count {
                            if let spriteComponent = emptyBlocks[i].component(ofType: SpriteComponent.self) {
                                spriteComponent.node.alpha = 0.6
                            }
                        }
                        commandDropZoneIsTouched = true
                    } else {
                        for i in 0...commandBlocks.count {
                            if let spriteComponent = emptyBlocks[i].component(ofType: SpriteComponent.self) {
                                spriteComponent.node.alpha = 0.1
                            }
                        }
                        commandDropZoneIsTouched = false
                    }
                }
                // detecta a dropzone da aba de comandos
                
                if(functionBlocks.count < 4) && (emptyFunctionBlocks.count > 0) {
                    
                    if (location.y > auxiliaryAnchor.y + 183) && (location.y < auxiliaryAnchor.y + 233) && (location.x > auxiliaryAnchor.x - 55 + 50*CGFloat(functionBlocks.count)) && (location.x < auxiliaryAnchor.x + 155){
                        for i in 0...functionBlocks.count {
                            if let spriteComponent = emptyFunctionBlocks[i].component(ofType: SpriteComponent.self) {
                                spriteComponent.node.alpha = 0.6
                            }
                        }
                        functionDropZoneIsTouched = true
                    } else {
                        for i in 0...functionBlocks.count {
                            if let spriteComponent = emptyFunctionBlocks[i].component(ofType: SpriteComponent.self) {
                                spriteComponent.node.alpha = 0.1
                            }
                        }
                        functionDropZoneIsTouched = false
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        draggingItem?.removeFromParent()
        if let location = touches.first?.location(in: self) {
            if (self.atPoint(location).name == "white-block") {
                if let draggingItem = draggingItem {
                    if (commandBlocks.count < 6) && commandDropZoneIsTouched {
                        let block = DraggableBlock(name: "\(draggingItem.name ?? "")-dropped-command-\(commandBlocks.count)" , spriteName: draggingItem.name ?? "")
                        if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                            spriteComponent.node.size = CGSize(width: draggingItem.size.width / 1.5, height: draggingItem.size.height / 1.5)
                            spriteComponent.node.position = CGPoint(x: gameplayAnchor.x - 175 + CGFloat(commandBlocks.count)*50, y: gameplayAnchor.y - 115)
                            spriteComponent.node.zPosition = ZPositionsCategories.draggableBlock
                        }
                        commandBlocks.append(block)
                        entityManager.add(block)
                    }
                    if (functionBlocks.count < 4) && functionDropZoneIsTouched {
                        let block = DraggableBlock(name: "\(draggingItem.name ?? "")-dropped-function-\(functionBlocks.count)" , spriteName: draggingItem.name ?? "")
                        if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                            spriteComponent.node.size = CGSize(width: draggingItem.size.width / 1.5, height: draggingItem.size.height / 1.5)
                            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x - 25 + CGFloat(functionBlocks.count)*50, y: auxiliaryAnchor.y + 210)
                            spriteComponent.node.zPosition = ZPositionsCategories.draggableBlock
                        }
                        functionBlocks.append(block)
                        entityManager.add(block)
                    }
                }
            }
            for i in 0..<emptyBlocks.count {
                if let whiteBlock = emptyBlocks[i].component(ofType: SpriteComponent.self) {
                    whiteBlock.node.alpha = 0.1
                }
            }
            for i in 0..<emptyFunctionBlocks.count {
                if let whiteBlock = emptyFunctionBlocks[i].component(ofType: SpriteComponent.self) {
                    whiteBlock.node.alpha = 0.1
                }
            }
            draggingItem = nil
        }
        //verfica se clicou no botão voltar
        for touch in touches {
            let nodes = self.nodes(at: touch.location(in: self))
            let returnButtonOptional = self.childNode(withName: "return-button")
            
            if let returnButton = returnButtonOptional {
                if nodes.contains(returnButton) {
                    returnToMap()
                }
            }
        }
    }
    
    func drawnReturnButton() {
        let returnButton = HubButton(name: "return-button")
        if let spriteComponent = returnButton.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: frame.minX + 50, y: frame.maxY - 50)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(returnButton)
    }
    func drawnConfigButton() {
        let configButton = HubButton(name: "config-button")
        if let spriteComponent = configButton.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: frame.maxX - 150, y: frame.maxY - 50)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(configButton)
    }
    func drawnHintButton() {
        let hintButton = HubButton(name: "hint-button")
        if let spriteComponent = hintButton.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: frame.maxX - 100, y: frame.maxY - 50)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(hintButton)
    }
    
    func returnToMap() {
        let mapScene = MapScene(size: view!.bounds.size)
        view!.presentScene(mapScene)
    }
}
