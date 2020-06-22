import SpriteKit
import GameplayKit

class RobotMoveComponent: GKComponent {
    
    private var node: SKSpriteNode {
        guard let node = entity?.component(ofType: SpriteComponent.self)?.node else {
            fatalError("This entity don't have node")
        }
        return node
    }
    
    var game: GameScene!
    var identifier: Int!
    
    var arrayClosures:[(String, Bool)->Void] = []
    var arrayDirection:[String] = []
    var arrayCheckerBox:[Bool] = []
    var arrayBox: [DefaultObject] = []
    
    var i = 0
    var arrayActualPosition: [CGPoint] = []
    var arrayPositionBox: [CGPoint] = []
    var boxFloor: DefaultObject!
    
    var robotInfected: DefaultObject!
    var stopButton: HudButton!
    var lightFloor: DefaultObject!
    
    var countBoxes: Int = 0
    var countInfected: Int = 0
    
    override init() {
        super.init()
    }
    
    func grabBox(direction: String, box: Bool){
        self.identifier += 1
        let textures: [SKTexture] = [SKTexture(imageNamed: "robot-grab-box-\(direction)")]
        let animate = SKAction.animate(with: textures, timePerFrame: 0.1, resize: false, restore: false)
        if let floor = self.lightFloor.component(ofType: SpriteComponent.self){
            floor.node.run(SKAction.wait(forDuration: 0.1))
        }
        node.run(animate){
            if self.identifier < self.arrayClosures.count{
                self.arrayClosures[self.identifier](self.arrayDirection[self.identifier], self.arrayCheckerBox[self.identifier])
            }else{
                self.stop()
            }
        }
        if let component = self.arrayBox[0].component(ofType: SpriteComponent.self){
            component.node.run(SKAction.fadeOut(withDuration: 0))
        }
        
    }
    
    func putBox(direction: String, box: Bool){
        self.identifier += 1
        let faseAtual = UserDefaults.standard.object(forKey: "selectedFase")
        let stageOptional = BaseOfStages.buscar(id: "\(faseAtual!)")
        
        guard let stage = stageOptional else {
            return
        }
        let textures: [SKTexture] = [SKTexture(imageNamed: "robot-idle-\(direction)-2")]
        let animate = SKAction.animate(with: textures, timePerFrame: 0.1, resize: false, restore: false)
        if let floor = self.lightFloor.component(ofType: SpriteComponent.self){
            floor.node.run(SKAction.wait(forDuration: 0.1))
        }
        
        if let component = self.arrayBox[0].component(ofType: SpriteComponent.self){
            
            component.node.position = self.arrayActualPosition[self.i]
            component.node.zPosition = self.node.zPosition - 0.1
            component.node.run(SKAction.fadeIn(withDuration: 0))
            
            for box in self.arrayPositionBox{

                for dropZone in stage.dropZones {
                    print(Int(box.x), dropZone[0],Int(box.y), dropZone[1], dropZone.count)
                    if Int(box.x) == dropZone[0] && Int(box.y) == dropZone[1] {
                        if let floor = self.boxFloor.component(ofType: SpriteComponent.self){
                            floor.node.zPosition = self.node.zPosition - 0.2
                            self.countBoxes -= 1
                            self.game.startDropBoxSound()
                        }
                    }
                    
                }
            }
            self.i += 1
        }
        node.run(animate){
            if self.countBoxes == 0 && self.countInfected == 0{
                self.winner()
            }else if self.identifier < self.arrayClosures.count{
                self.arrayClosures[self.identifier](self.arrayDirection[self.identifier], self.arrayCheckerBox[self.identifier])
            }else{
                self.stop()
            }
        }
        
        
        
    }
        
    
    
    func move(direction: String, box: Bool) -> Void {
        self.identifier += 1
        let move: SKAction
        let textures: [SKTexture]
        if box {
            switch direction {
               case "up":
                   move = SKAction.move(by: CGVector(dx: 32, dy: 16), duration: 0.8)
               case "left":
                   move = SKAction.move(by: CGVector(dx: -32, dy: 16), duration: 0.8)
               case "down":
                   move = SKAction.move(by: CGVector(dx: -32, dy: -16), duration: 0.8)
               case "right":
                   move = SKAction.move(by: CGVector(dx: 32, dy: -16), duration: 0.8)
               default:
                   move = SKAction.move(by: CGVector(dx: 0, dy: 0), duration: 0.8)
           }
            textures = [SKTexture(imageNamed: "robot-grab-box-\(direction)")]
        } else {
            switch direction {
            case "up":
                move = SKAction.move(by: CGVector(dx: 32, dy: 16), duration: 0.8)
                textures = [SKTexture(imageNamed: "robot-idle-up-1"), SKTexture(imageNamed: "robot-idle-up-2"), SKTexture(imageNamed: "robot-idle-up-3"), SKTexture(imageNamed: "robot-idle-up-2")]
            case "left":
                move = SKAction.move(by: CGVector(dx: -32, dy: 16), duration: 0.8)
                textures = [SKTexture(imageNamed: "robot-idle-left-1"), SKTexture(imageNamed: "robot-idle-left-2"), SKTexture(imageNamed: "robot-idle-left-3"), SKTexture(imageNamed: "robot-idle-left-2")]
            case "down":
                move = SKAction.move(by: CGVector(dx: -32, dy: -16), duration: 0.8)
                textures = [SKTexture(imageNamed: "robot-idle-down-1"), SKTexture(imageNamed: "robot-idle-down-2"), SKTexture(imageNamed: "robot-idle-down-3"), SKTexture(imageNamed: "robot-idle-down-2")]
            case "right":
                move = SKAction.move(by: CGVector(dx: 32, dy: -16), duration: 0.8)
                textures = [SKTexture(imageNamed: "robot-idle-right-1"), SKTexture(imageNamed: "robot-idle-right-2"), SKTexture(imageNamed: "robot-idle-right-3"), SKTexture(imageNamed: "robot-idle-right-2")]
            default:
                move = SKAction.move(by: CGVector(dx: 0, dy: 0), duration: 0.8)
                textures = []
            }
        }
        let animate = SKAction.animate(with: textures, timePerFrame: 0.2, resize: false, restore: false)
        if let floor = self.lightFloor.component(ofType: SpriteComponent.self){
            floor.node.run(SKAction.group([SKAction.wait(forDuration: 0.8), move]))
        }
        /* vai ter uma if aqui para saber se pode ou nao ser ativado o efeito*/
        node.run(SKAction.wait(forDuration: 0.4)){
            self.game.startMoveSound()
        }
        
        node.run(SKAction.group([move, animate])){
            if self.identifier < self.arrayClosures.count{
                self.arrayClosures[self.identifier](self.arrayDirection[self.identifier], self.arrayCheckerBox[self.identifier])
            }else{
                self.stop()
            }
        }
    }
    
    func moveComplete(game: GameScene, arrayBox: [DefaultObject], stopButton: HudButton, robotInfected: DefaultObject, lightFloor: DefaultObject){
        
        self.arrayBox = arrayBox
        self.stopButton = stopButton
        self.robotInfected = robotInfected
        self.lightFloor = lightFloor
        self.game = game
        self.identifier = 0
        if let floor = self.lightFloor.component(ofType: SpriteComponent.self){
            floor.node.zPosition = self.node.zPosition - 0.3
        }
        if !self.arrayClosures.isEmpty{
            self.arrayClosures[0](self.arrayDirection[0], self.arrayCheckerBox[0])
        }else{
            self.stop()
        }
        
    }
    
    func winner(){
        self.game.drawDialogues(won: true)
        self.identifier = self.arrayClosures.count
    }
    
    func stop(){
        self.identifier = self.arrayClosures.count
        if let sprite = self.stopButton.component(ofType: SpriteComponent.self){
            sprite.node.name = "stop"
            node.run(SKAction.wait(forDuration: 0.8)){
                sprite.node.zPosition = -1
                sprite.node.name = "stop-button"
                self.game.resetMoveRobot()
            }
        }
    }
    
    func turn(direction: String, box: Bool) -> Void{
        self.identifier += 1
        let textures: [SKTexture]
        if box {
            textures = [SKTexture(imageNamed: "robot-grab-box-\(direction)")]
        }else{
            textures = [SKTexture(imageNamed: "robot-idle-\(direction)-2")]
        }
        let animate = SKAction.animate(with: textures, timePerFrame: 0.6, resize: false, restore: false)
        if let floor = self.lightFloor.component(ofType: SpriteComponent.self){
            floor.node.run(SKAction.wait(forDuration: 0.6))
        }
        
        /* vai ter uma if aqui para saber se pode ou nao ser ativado o efeito*/
        self.game.startMoveSound()
        
        node.run(animate){
            if self.identifier < self.arrayClosures.count{
                self.arrayClosures[self.identifier](self.arrayDirection[self.identifier], self.arrayCheckerBox[self.identifier])
            }else{
                self.stop()
            }
        }
    }
    
    func saveRobot(direction: String, box: Bool){
        self.identifier += 1
        let textures: [SKTexture]
        textures = [SKTexture(imageNamed: "save-\(direction)")]
        let animate = SKAction.animate(with: textures, timePerFrame: 0.6, resize: false, restore: false)
        if let floor = self.lightFloor.component(ofType: SpriteComponent.self){
            floor.node.run(SKAction.wait(forDuration: 0.6))
        }
        self.countInfected -= 1
        node.run(animate){
            if self.countBoxes == 0 && self.countInfected == 0{
                self.winner()
            } else if self.identifier < self.arrayClosures.count{
                self.arrayClosures[self.identifier](self.arrayDirection[self.identifier], self.arrayCheckerBox[self.identifier])
            }else{
                self.stop()
            }
        }
        if let infected = robotInfected.component(ofType: SpriteComponent.self){
            /* vai ter uma if aqui para saber se pode ou nao ser ativado o efeito*/
            self.game.startSaveSound()
            infected.node.run(SKAction.fadeOut(withDuration: 0.9))
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
