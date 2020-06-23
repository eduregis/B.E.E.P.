import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    lazy var backName:String = {return self.userData?["backSaved"] as? String ?? "gameScene"}()
    

    let backgroundSound = SKAudioNode(fileNamed: "garage-monplaisir")

    //progresso de fase
    var indexStage: Int = 3
    let defalts = UserDefaults.standard
    

    
    // variáveis que irão receber os valores da API
    var actualPosition = CGPoint(x: 1, y: 1)
    var stageDimensions = CGSize(width: 5, height: 3)
    var gameplayAnchor: CGPoint!
    var auxiliaryAnchor: CGPoint!
    var actualDirection = "right"
    var tabStyle = "conditional"

    var boxes: [CGPoint] = []
    
    // Os objetivoss do jogo o boxfloor é aciondo quando o box e clocado no lugar indicado
    // e robot infected e cured sao pera fazer a transicao quando o save for acionado
    let boxFloor = DefaultObject(name: "box-fill-floor")
    let robotInfected = DefaultObject(name:  "robotInfected")
    let robotCured = DefaultObject(name:  "robotCured")
    
    var identifierBox: Int?
    var verificationBox = false
    var boxesCopy: [DefaultObject] = []
    

    var boxDropZones: [CGPoint] = []
    var infectedRobots: [CGPoint] = []
    // array de falas do B.E.E.P.
    var dialogues: [String] = []
    
    var dialogueIndex = 0
    var dialogueBackground: DefaultObject!
    var beep: DefaultObject!
    var dialogueTab: DefaultObject!
    var dialogueText = SKLabelNode(text: "")
    var dialogueButton: DefaultObject!
    var dialogueSkip: DefaultObject!
    
    
    // criamos a referência o gerenciador de entidades
    var entityManager: EntityManager!
    
    // instanciamos esse aqui fora porque precisamos deles depois que são desenhados
    let robot = Robot()
    let lightFloor = DefaultObject(name: "light-floor")
    
    var functionBlocks: [DraggableBlock] = []
    var emptyFunctionBlocks: [EmptyBlock] = []
    var functionDropZoneIsTouched: Bool = false
    
    var loopValue = 1
    var loopArrows: [DefaultObject] = []
    var loopText = SKLabelNode(text: "")
    
    var loopBlocks: [DraggableBlock] = []
    var emptyLoopBlocks: [EmptyBlock] = []
    var loopDropZoneIsTouched: Bool = false
    
    var conditionalValue = 0
    var conditions = ["Inimigo\nà frente", "Caixa\nà frente", "Abismo\nà frente", "Encaixe\nà frente"]
    var conditionalArrows: [DefaultObject] = []
    var conditionalText = SKLabelNode(text: "")
    
    var conditionalIfBlocks: [DraggableBlock] = []
    var emptyConditionalIfBlocks: [EmptyBlock] = []
    var conditionalIfDropZoneIsTouched: Bool = false
    
    var conditionalElseBlocks: [DraggableBlock] = []
    var emptyConditionalElseBlocks: [EmptyBlock] = []
    var conditionalElseDropZoneIsTouched: Bool = false
    
    var commandBlocks: [DraggableBlock] = []
    var stopButton = HudButton(name: "stop-button")
    
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
        if  UserDefaults.standard.object(forKey: "SettingsSound") != nil {
            if (UserDefaults.standard.object(forKey: "SettingsSound") as? String) == "Sim"{
                startBackgroundSound()
            }
        }else{
            startBackgroundSound()
        }
        
        let faseAtual = UserDefaults.standard.object(forKey: "selectedFase")
        
        let dialoguesOpt = BaseOfDialogues.buscar(id: "stage-\(faseAtual!)")
        
        guard let dialogues = dialoguesOpt else { return  }
        
        self.dialogues = dialogues.text
        
        let stageOptional = BaseOfStages.buscar(id: "\(faseAtual!)")
        
        guard let stage = stageOptional else {
            return
        }
        
        actualPosition = CGPoint(x: stage.initialPosition[0], y: stage.initialPosition[1])
        stageDimensions = CGSize(width: stage.width, height: stage.height)
        actualDirection = stage.initialDirection
        tabStyle = stage.tabStyle
        if !stage.boxes[0].isEmpty {
            for box in stage.boxes {
                boxes.append(CGPoint(x: box[0], y: box[1]))
            }
        }
        
        if !stage.dropZones[0].isEmpty {
            for dropZone in stage.dropZones {
                boxDropZones.append(CGPoint(x: dropZone[0], y: dropZone[1]))
            }
            
        }
        
        if !stage.infectedRobots[0].isEmpty {
            for infectedRobot in stage.infectedRobots {
                infectedRobots.append(CGPoint(x: infectedRobot[0], y: infectedRobot[1]))
            }
        }
        
        // posiciona os elementos de acordo como tipo de fase
        switch tabStyle {
        case "default":
            gameplayAnchor = CGPoint(x: size.width/2, y: size.height/2)
            auxiliaryAnchor = CGPoint(x: size.width/2, y: size.height/2)
        case "function", "antivirus", "loop", "conditional":
            gameplayAnchor = CGPoint(x: size.width/3, y: size.height/2)
            auxiliaryAnchor = CGPoint(x: 3*size.width/4, y: (size.height/2) - 39)
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
        
        //setup persistência de fases
        if  defalts.object(forKey: "indexStage") != nil {
            indexStage = defalts.integer(forKey: "indexStage")
        }
            defalts.set(indexStage, forKey: "indexStage")
        
        drawnReturnButton()
        
        drawTilesets(width: Int(stageDimensions.width), height: Int(stageDimensions.height))
        drawRobot(xPosition: Int(actualPosition.x), yPosition: Int(actualPosition.y))
      
        if !infectedRobots.isEmpty {
            
            for infectedRobot in infectedRobots {
                drawRobotInfected(xPosition: Int(infectedRobot.x), yPosition: Int(infectedRobot.y))

            }
          if let addElement = robot.component(ofType: RobotMoveComponent.self){
                addElement.countInfected = infectedRobots.count
          }
        }
        drawTabs()
        drawAuxiliaryTab()
        
        drawnConfigButton()
        drawnHintButton()
        
        if (boxes.count > 0){
            drawBoxes()
            if let addElement = robot.component(ofType: RobotMoveComponent.self){
                addElement.countBoxes = boxes.count
            }
        }
        if (boxDropZones.count > 0){ drawBoxDropZones() }

        drawDialogues(won: false)
    }
    
    func addElementFunc(){
        for block in functionBlocks{
            if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                // usando o trecho "-dropped-" para separar obtermos o nome original e seu índice
                let name = spriteComponent.node.name?.components(separatedBy: "-dropped-")
                // com o nome original será escolhido o tipo de movimento que o robot irá fazer
                switch name![0] {
                case "walk-block":
                    if !moveRobot() {
                        print("nao deu")
                    }
                case "turn-right-block":
                    turnRobot(direction: "right")
                case "turn-left-block":
                    turnRobot(direction: "left")
                case "grab-block":
                    if verificationBox {
                        if !putBox(){
                             print("nao deu")
                        }
                    }else{
                        if !grabBox(){
                             print("nao deu")
                        }
                    }
                case "save-block":
                    if !save(){
                        print("nao deu")
                    }
                default:
                    break;
                }
                
            }
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let location = touches.first?.location(in: self) {
            // Checamos o nome do SpriteNode que foi detectado pela função
            if (self.atPoint(location).name == "walk-block") || (self.atPoint(location).name == "turn-left-block") || (self.atPoint(location).name == "turn-right-block") || (self.atPoint(location).name == "grab-block") || (self.atPoint(location).name == "save-block") || (self.atPoint(location).name == "function-block") || (self.atPoint(location).name == "loop-block") || (self.atPoint(location).name == "conditional-block") {
                // passamos o objeto detectado para dentro do selectedItem
                selectedItem = self.atPoint(location) as? SKSpriteNode
            }
            else {
                // caso não seja o objeto que queremos, esvaziamos o selectedItem
                selectedItem = nil
                if self.atPoint(location).name == "play-button" {
                    if  UserDefaults.standard.object(forKey: "SettingsSound") != nil {
                        if (UserDefaults.standard.object(forKey: "SettingsSound") as? String) == "Sim"{
                            startPlaySound()
                        }
                    }else{
                        startPlaySound()
                    }
                    /*verificar se o array commandBlocks está vazio
                     - Se tem algum block na dropZone*/
                    if !commandBlocks.isEmpty {
                        // rodamos commandBlocks para guardar as SKAction referente a cada block colocado na dropZone
                        for block in commandBlocks{
                            if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                                // usando o trecho "-dropped-" para separar obtermos o nome original e seu índice
                                let name = spriteComponent.node.name?.components(separatedBy: "-dropped-")
                                // com o nome original será escolhido o tipo de movimento que o robot irá fazer
                                switch name![0] {
                                case "walk-block":
                                    if !moveRobot() {
                                        print("nao deu")
                                    }
                                case "turn-right-block":
                                    turnRobot(direction: "right")
                                case "turn-left-block":
                                    turnRobot(direction: "left")
                                case "function-block":
                                    addElementFunc()
                                case "grab-block":
                                    if verificationBox {
                                        if !putBox(){
                                             print("nao deu")
                                        }
                                    }else{
                                        if !grabBox(){
                                             print("nao deu")
                                        }
                                    }
                                case "save-block":
                                    if !save(){
                                        print("nao deu")
                                    }
                                case "loop-block":
                                    addElementLoop()
                                case "conditional-block":
                                    addElementConditional()
                                default:
                                    break;
                                }
                                
                            }
                            
                        }
                        if let stopButton = stopButton.component(ofType: SpriteComponent.self){
                            stopButton.node.zPosition = ZPositionsCategories.button + 1
                        }
                        //execução do array actionMove que permitirar uma movimentação linear sem desvios
                        moveCompleteRobotLightFloor()
                    }
                } else if (self.atPoint(location).name == "stop-button") {
                    if let stop = robot.component(ofType: RobotMoveComponent.self){
                        stop.stop()
                        /*if let pause = robot.component(ofType: SpriteComponent.self){
                            pause.node.run(SKAction.wait(forDuration: 0.8)){
                                self.resetMoveRobot()
                            }
                        }*/
                    }
                } else if (self.atPoint(location).name == "play-dialogue") {
                    updateText()
                } else if (self.atPoint(location).name == "skip-button") {
                    skipText(next: false)
                } else if (self.atPoint(location).name == "next-button") {
                    skipText(next: true)
                }else if (self.atPoint(location).name == "hint-button") {
                    hintStage()
                } else if (self.atPoint(location).name == "command-clear-tab") {
                    clearTab(tabName: "command")
                } else if (self.atPoint(location).name == "function-clear-tab") {
                    clearTab(tabName: "function")
                } else if (self.atPoint(location).name == "loop-clear-tab") {
                    clearTab(tabName: "loop")
                } else if (self.atPoint(location).name == "loop-arrow-left") {
                    if loopValue > 1 {
                        loopValue = loopValue - 1
                    }
                    if let spriteComponent = loopArrows[1].component(ofType: SpriteComponent.self) {
                        spriteComponent.node.alpha = 1
                    }
                    if loopValue == 1 {
                        if let spriteComponent = loopArrows[0].component(ofType: SpriteComponent.self) {
                            spriteComponent.node.alpha = 0.3
                        }
                    } else {
                        if let spriteComponent = loopArrows[0].component(ofType: SpriteComponent.self) {
                            spriteComponent.node.alpha = 1
                        }
                    }
                    updateLoopText()
                } else if (self.atPoint(location).name == "loop-arrow-right") {
                    if loopValue < 4 {
                        loopValue = loopValue + 1
                    }
                    if let spriteComponent = loopArrows[0].component(ofType: SpriteComponent.self) {
                        spriteComponent.node.alpha = 1
                    }
                    if loopValue == 4 {
                        if let spriteComponent = loopArrows[1].component(ofType: SpriteComponent.self) {
                            spriteComponent.node.alpha = 0.3
                        }
                    } else {
                        if let spriteComponent = loopArrows[1].component(ofType: SpriteComponent.self) {
                            spriteComponent.node.alpha = 1
                        }
                    }
                    updateLoopText()
                } else if (self.atPoint(location).name == "conditional-clear-tab") {
                    clearTab(tabName: "conditional")
                } else if (self.atPoint(location).name == "conditional-arrow-left") {
                    if conditionalValue > 0 {
                        conditionalValue = conditionalValue - 1
                    }
                    if let spriteComponent = conditionalArrows[1].component(ofType: SpriteComponent.self) {
                        spriteComponent.node.alpha = 1
                    }
                    if conditionalValue == 0 {
                        if let spriteComponent = conditionalArrows[0].component(ofType: SpriteComponent.self) {
                            spriteComponent.node.alpha = 0.3
                        }
                    } else {
                        if let spriteComponent = conditionalArrows[0].component(ofType: SpriteComponent.self) {
                            spriteComponent.node.alpha = 1
                        }
                    }
                    updateConditionalText()
                } else if (self.atPoint(location).name == "conditional-arrow-right") {
                    if conditionalValue < 3 {
                        conditionalValue = conditionalValue + 1
                    }
                    if let spriteComponent = conditionalArrows[0].component(ofType: SpriteComponent.self) {
                        spriteComponent.node.alpha = 1
                    }
                    if conditionalValue == 3 {
                        if let spriteComponent = conditionalArrows[1].component(ofType: SpriteComponent.self) {
                            spriteComponent.node.alpha = 0.3
                        }
                    } else {
                        if let spriteComponent = conditionalArrows[1].component(ofType: SpriteComponent.self) {
                            spriteComponent.node.alpha = 1
                        }
                    }
                    updateConditionalText()
                }
            }
            if let oldName = self.atPoint(location).name {
                // testa se selecionamos um bloco dentro da aba de comandos
                if oldName.contains("-dropped-") {
                    // se sim, utilizamos o trecho "-dropped-" para separar obtermos o nome original e seu índice
                    var newName: [String] = []
                    var arrayName: String = ""
                    if oldName.contains("-dropped-command-") {
                        newName = self.atPoint(location).name!.components(separatedBy: "-dropped-command-")
                        arrayName = "command-"
                    } else if oldName.contains("-dropped-function-") {
                        newName = self.atPoint(location).name!.components(separatedBy: "-dropped-function-")
                        arrayName = "function-"
                    } else if oldName.contains("-dropped-loop-") {
                        newName = self.atPoint(location).name!.components(separatedBy: "-dropped-loop-")
                        arrayName = "loop-"
                    } else if oldName.contains("-dropped-conditional-if-") {
                        newName = self.atPoint(location).name!.components(separatedBy: "-dropped-conditional-if-")
                        arrayName = "conditional-if-"
                    } else if oldName.contains("-dropped-conditional-else-") {
                        newName = self.atPoint(location).name!.components(separatedBy: "-dropped-conditional-else-")
                        arrayName = "conditional-else-"
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
                        case "loop-":
                            loopBlocks.remove(at: indexToRemove)
                            // trazemos os blocos para a esquerda, ajustando tanto a posição do sprite quanto seu índice no final do nome
                            for index in indexToRemove..<loopBlocks.count {
                                if let spriteComponent = loopBlocks[index].component(ofType: SpriteComponent.self) {
                                    spriteComponent.node.position = CGPoint(x: spriteComponent.node.position.x - 50, y: spriteComponent.node.position.y)
                                    // a partir do nome antigo, remontamos dessa forma
                                    let oldIndex = spriteComponent.node.name?.components(separatedBy: "-dropped-loop-")
                                    let newIndex = Int(oldIndex![1])! - 1
                                    spriteComponent.node.name = "\(oldIndex![0])-dropped-loop-\(newIndex)"
                                }
                            }
                        case "conditional-if-":
                            conditionalIfBlocks.remove(at: indexToRemove)
                            // trazemos os blocos para a esquerda, ajustando tanto a posição do sprite quanto seu índice no final do nome
                            for index in indexToRemove..<conditionalIfBlocks.count {
                                if let spriteComponent = conditionalIfBlocks[index].component(ofType: SpriteComponent.self) {
                                    spriteComponent.node.position = CGPoint(x: spriteComponent.node.position.x - 50, y: spriteComponent.node.position.y)
                                    // a partir do nome antigo, remontamos dessa forma
                                    let oldIndex = spriteComponent.node.name?.components(separatedBy: "-dropped-conditional-if-")
                                    let newIndex = Int(oldIndex![1])! - 1
                                    spriteComponent.node.name = "\(oldIndex![0])-dropped-conditional-if-\(newIndex)"
                                }
                            }
                        case "conditional-else-":
                            conditionalElseBlocks.remove(at: indexToRemove)
                            // trazemos os blocos para a esquerda, ajustando tanto a posição do sprite quanto seu índice no final do nome
                            for index in indexToRemove..<conditionalElseBlocks.count {
                                if let spriteComponent = conditionalElseBlocks[index].component(ofType: SpriteComponent.self) {
                                    spriteComponent.node.position = CGPoint(x: spriteComponent.node.position.x - 50, y: spriteComponent.node.position.y)
                                    // a partir do nome antigo, remontamos dessa forma
                                    let oldIndex = spriteComponent.node.name?.components(separatedBy: "-dropped-conditional-else-")
                                    let newIndex = Int(oldIndex![1])! - 1
                                    spriteComponent.node.name = "\(oldIndex![0])-dropped-conditional-else-\(newIndex)"
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
                // detecta a dropzone da aba de função
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
                // detecta a dropzone da aba de repetição
                if(loopBlocks.count < 4) && (emptyLoopBlocks.count > 0) {
                    if (location.y > auxiliaryAnchor.y + 1) && (location.y < auxiliaryAnchor.y + 51) && (location.x > auxiliaryAnchor.x - 55 + 50*CGFloat(loopBlocks.count)) && (location.x < auxiliaryAnchor.x + 155){
                        for i in 0...loopBlocks.count {
                            if let spriteComponent = emptyLoopBlocks[i].component(ofType: SpriteComponent.self) {
                                spriteComponent.node.alpha = 0.6
                            }
                        }
                        loopDropZoneIsTouched = true
                    } else {
                        for i in 0...loopBlocks.count {
                            if let spriteComponent = emptyLoopBlocks[i].component(ofType: SpriteComponent.self) {
                                spriteComponent.node.alpha = 0.1
                            }
                        }
                        loopDropZoneIsTouched = false
                    }
                }
                // detecta a dropzone da aba de condicional
                if(conditionalIfBlocks.count < 4) && (emptyConditionalIfBlocks.count > 0) {
                    if (location.y > auxiliaryAnchor.y - 185) && (location.y < auxiliaryAnchor.y - 135) && (location.x > auxiliaryAnchor.x - 55 + 50*CGFloat(conditionalIfBlocks.count)) && (location.x < auxiliaryAnchor.x + 155){
                        for i in 0...conditionalIfBlocks.count {
                            if let spriteComponent = emptyConditionalIfBlocks[i].component(ofType: SpriteComponent.self) {
                                spriteComponent.node.alpha = 0.6
                            }
                        }
                        conditionalIfDropZoneIsTouched = true
                    } else {
                        for i in 0...conditionalIfBlocks.count {
                            if let spriteComponent = emptyConditionalIfBlocks[i].component(ofType: SpriteComponent.self) {
                                spriteComponent.node.alpha = 0.1
                            }
                        }
                        conditionalIfDropZoneIsTouched = false
                    }
                }
                // detecta a dropzone da aba de condicional
                if(conditionalElseBlocks.count < 4) && (emptyConditionalElseBlocks.count > 0) {
                    if (location.y > auxiliaryAnchor.y - 247) && (location.y < auxiliaryAnchor.y - 197) && (location.x > auxiliaryAnchor.x - 55 + 50*CGFloat(conditionalElseBlocks.count)) && (location.x < auxiliaryAnchor.x + 155){
                        for i in 0...conditionalElseBlocks.count {
                            if let spriteComponent = emptyConditionalElseBlocks[i].component(ofType: SpriteComponent.self) {
                                spriteComponent.node.alpha = 0.6
                            }
                        }
                        conditionalElseDropZoneIsTouched = true
                    } else {
                        for i in 0...conditionalElseBlocks.count {
                            if let spriteComponent = emptyConditionalElseBlocks[i].component(ofType: SpriteComponent.self) {
                                spriteComponent.node.alpha = 0.1
                            }
                        }
                        conditionalElseDropZoneIsTouched = false
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        draggingItem?.removeFromParent()
        if let location = touches.first?.location(in: self) {
            // checa se o local onde o objeto está send solto é um boco branco, que funciona como uma dropzone
            if (self.atPoint(location).name == "white-block") {
                if let draggingItem = draggingItem {
                    // checa qual area de contato está sendo acionada, e se aquele array tem espaço
                    if (commandBlocks.count < 6) && commandDropZoneIsTouched {
                        // usamos o nome do array para identificar o bloco, além de um índice
                        let block = DraggableBlock(name: "\(draggingItem.name ?? "")-dropped-command-\(commandBlocks.count)" , spriteName: draggingItem.name ?? "")
                        if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                            // devolve ao objeto seu tamanho e opacidade
                            spriteComponent.node.size = CGSize(width: draggingItem.size.width / 1.5, height: draggingItem.size.height / 1.5)
                            spriteComponent.node.position = CGPoint(x: gameplayAnchor.x - 175 + CGFloat(commandBlocks.count)*50, y: gameplayAnchor.y - 115)
                            spriteComponent.node.zPosition = ZPositionsCategories.draggableBlock
                        }
                        // adiciona o bloco no gerenciador de entidades, e também no array
                        commandBlocks.append(block)
                        entityManager.add(block)
                    }
                    if (functionBlocks.count < 4) && functionDropZoneIsTouched && draggingItem.name != "function-block" && draggingItem.name != "loop-block" && draggingItem.name != "conditional-block" {
                        let block = DraggableBlock(name: "\(draggingItem.name ?? "")-dropped-function-\(functionBlocks.count)" , spriteName: draggingItem.name ?? "")
                        if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                            spriteComponent.node.size = CGSize(width: draggingItem.size.width / 1.5, height: draggingItem.size.height / 1.5)
                            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x - 25 + CGFloat(functionBlocks.count)*50, y: auxiliaryAnchor.y + 210)
                            spriteComponent.node.zPosition = ZPositionsCategories.draggableBlock
                        }
                        functionBlocks.append(block)
                        entityManager.add(block)
                    }
                    if (loopBlocks.count < 4) && loopDropZoneIsTouched && draggingItem.name != "function-block" && draggingItem.name != "loop-block" && draggingItem.name != "conditional-block" {
                        let block = DraggableBlock(name: "\(draggingItem.name ?? "")-dropped-loop-\(loopBlocks.count)" , spriteName: draggingItem.name ?? "")
                        if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                            spriteComponent.node.size = CGSize(width: draggingItem.size.width / 1.5, height: draggingItem.size.height / 1.5)
                            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x - 25 + CGFloat(loopBlocks.count)*50, y: auxiliaryAnchor.y + 30)
                            spriteComponent.node.zPosition = ZPositionsCategories.draggableBlock
                        }
                        loopBlocks.append(block)
                        entityManager.add(block)
                    }
                    if (conditionalIfBlocks.count < 4) && conditionalIfDropZoneIsTouched && draggingItem.name != "function-block" && draggingItem.name != "loop-block" && draggingItem.name != "conditional-block" {
                        let block = DraggableBlock(name: "\(draggingItem.name ?? "")-dropped-conditional-if-\(conditionalIfBlocks.count)" , spriteName: draggingItem.name ?? "")
                        if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                            spriteComponent.node.size = CGSize(width: draggingItem.size.width / 1.5, height: draggingItem.size.height / 1.5)
                            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x - 25 + CGFloat(conditionalIfBlocks.count)*50, y: auxiliaryAnchor.y - 151)
                            spriteComponent.node.zPosition = ZPositionsCategories.draggableBlock
                        }
                        conditionalIfBlocks.append(block)
                        entityManager.add(block)
                    }
                    if (conditionalElseBlocks.count < 4) && conditionalElseDropZoneIsTouched && draggingItem.name != "function-block" && draggingItem.name != "loop-block" && draggingItem.name != "conditional-block" {
                        let block = DraggableBlock(name: "\(draggingItem.name ?? "")-dropped-conditional-else-\(conditionalElseBlocks.count)" , spriteName: draggingItem.name ?? "")
                        if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                            spriteComponent.node.size = CGSize(width: draggingItem.size.width / 1.5, height: draggingItem.size.height / 1.5)
                            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x - 25 + CGFloat(conditionalElseBlocks.count)*50, y: auxiliaryAnchor.y - 213)
                            spriteComponent.node.zPosition = ZPositionsCategories.draggableBlock
                        }
                        conditionalElseBlocks.append(block)
                        entityManager.add(block)
                    }
                }
            }
            // coloca todos os dropzones com opacidade 0.1
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
            for i in 0..<emptyLoopBlocks.count {
                if let whiteBlock = emptyLoopBlocks[i].component(ofType: SpriteComponent.self) {
                    whiteBlock.node.alpha = 0.1
                }
            }
            for i in 0..<emptyConditionalIfBlocks.count {
                if let whiteBlock = emptyConditionalIfBlocks[i].component(ofType: SpriteComponent.self) {
                    whiteBlock.node.alpha = 0.1
                }
            }
            for i in 0..<emptyConditionalElseBlocks.count {
                if let whiteBlock = emptyConditionalElseBlocks[i].component(ofType: SpriteComponent.self) {
                    whiteBlock.node.alpha = 0.1
                }
            }
            draggingItem = nil
        }
        //verifica se clicou no botão voltar
        for touch in touches {
            let nodes = self.nodes(at: touch.location(in: self))
            let returnButtonOptional = self.childNode(withName: "return-button")
            if let returnButton = returnButtonOptional {
                if nodes.contains(returnButton) {
                    returnToMap()
                }
            }
            if nodes[0].name?.contains("config-button") ?? false {
               let configScene = ConfigScene(size: view!.bounds.size)
               configScene.userData = configScene.userData ?? NSMutableDictionary()
               configScene.userData!["backSaved"] = backName
               view!.presentScene(configScene)
            }
        }
    }
    
    func returnToMap() {
        let mapScene = MapScene(size: view!.bounds.size)
        view!.presentScene(mapScene)
    }
}
