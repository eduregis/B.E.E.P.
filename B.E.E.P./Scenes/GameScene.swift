import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    lazy var backName:String = {return self.userData?["backSaved"] as? String ?? "gameScene"}()
    

    let backgroundSound = SKAudioNode(fileNamed: "garage-monplaisir")

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
    
    var identifierBox: Int?
    var verificationBox = false
    var boxesCopy: [DefaultObject] = []
    

    var boxDropZones: [CGPoint] = []
    var infectedRobots: [CGPoint] = []
    var arrayInfectedRobot: [DefaultObject] = []
    var infectedDirections: [String] = []
    
    // array de falas do B.E.E.P.
    var dialogues: [String] = []
    
    var dialogueIndex = 0
    var dialogueBackground: SKSpriteNode!
    var beep: SKSpriteNode!
    var dialogueTab: SKSpriteNode!
    var dialogueText = SKLabelNode(text: "")
    var dialogueButton: SKSpriteNode!
    var dialogueSkip: SKSpriteNode!
    
    
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
        
        guard let dialogues = dialoguesOpt else { return }
        
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
            for infectedDirection in stage.infectedDirections{
                infectedDirections.append(infectedDirection)
            }
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

        let lastStageAvailable = UserDefaults.standard.object(forKey: "lastStageAvailable") as! Int
        
        if (faseAtual as! Int == lastStageAvailable) {
            drawDialogues(won: false)
        }
    }


    


    func returnToMap() {
        let mapScene = MapScene(size: view!.bounds.size)
        view!.presentScene(mapScene)
    }
}
