//
//  MapScene.swift
//  B.E.E.P.
//
//  Created by Nathália Cardoso on 09/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import SpriteKit
import GameplayKit

class MapScene:SKScene {
    
    var entityManager:EntityManager!
    var filamentScale:CGFloat = -1
    var posicao:Int = 0
    var locationAnterior:CGPoint = CGPoint(x: 0, y: 0)
    var touchesBeganLocation = CGPoint(x: 0, y: 0)
    let totalDeFases = 4
    
    lazy var backName:String = {return self.userData?["backSaved"] as? String ?? "mapScene"}()
    
    override func didMove(to view: SKView) {

        entityManager = EntityManager(scene: self)
        
        drawBackground()
        
        //drawn hint button

        addEntity(entity: HudButton(name: "hint-button"), nodeName: "hint-button", position: CGPoint(x: frame.maxX-100, y: frame.maxY-50), zPosition: 2, alpha: 1.0)
        //drawn config button
        addEntity(entity: HudButton(name: "config-button"), nodeName: "config-button", position: CGPoint(x: frame.maxX-150, y: frame.maxY-50), zPosition: 2, alpha: 1.0)

        while true {
            if UserDefaults.standard.bool(forKey: "buildMap") == true {
                buildMap()
                break
            }
        }
        
        updatePosition()
        
    }
    
    func updatePosition() {
        let faseAtual = UserDefaults.standard.object(forKey: "selectedFase") as! Int
        
        switch faseAtual {
        case 1:
            self.posicao = 0
        case 2:
            self.posicao = 0
        case 3:
            self.posicao = 50
        case 4:
            self.posicao = 100
        default:
            self.posicao = 0
        }
        
        moveMap(direction: Direction.forward, x: CGFloat(self.posicao*5))
        
    }
    
    func drawBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.name = "background"
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.size = CGSize(width: size.width, height: size.height)
        addChild(background)
    }
    
    func drawnMaps(height:Int, width:Int, tilesetReference: CGPoint, status:String, showRobot:Bool, numberFase: Int) {
        var lightFloorPosition = CGPoint(x: 0, y: 0)
        var stageUnavailablePosition = CGPoint(x: 0, y: 0)
        for i in 1...width {
            for j in 1...height {
                // posição do tileset
                let x = (CGFloat(32*(i - 1)) - CGFloat(32*(j - 1))) + tilesetReference.x
                let y = (CGFloat(-16*(i - 1)) - CGFloat(16*(j - 1))) + tilesetReference.y
                
                addEntity(entity:Tileset(status: status), nodeName: "stage-\(status)\(numberFase)", position: CGPoint(x: x, y: y), zPosition: CGFloat(i + j), alpha: 1.0)
    
                if (i-1) == (width-1)/2 && (j-1) == (height-1)/2 {
                    if showRobot {
                        lightFloorPosition = CGPoint(x: x, y: y)
                        //desenhando o robo
                        addEntity(entity:Robot(), nodeName: "stage-\(status)\(numberFase)", position: CGPoint(x: lightFloorPosition.x, y: lightFloorPosition.y+31), zPosition: 101, alpha: 1.0)
                        //desenhando o light floor
                        addEntity(entity: LightFloor(), nodeName: "stage-\(status)\(numberFase)", position: lightFloorPosition, zPosition: 100, alpha: 0.7)
                    } else {
                        stageUnavailablePosition = CGPoint(x: x, y: y+21)
                      }
                }
            }
        }
        if status == "unavailable" {
            addEntity(entity: StageUnavailable(), nodeName: "stage-\(status)\(numberFase)", position: stageUnavailablePosition, zPosition: 100, alpha: 1.0)
        }
    }
    
    func addEntity(entity:GKEntity, nodeName:String, position:CGPoint, zPosition:CGFloat, alpha: CGFloat) {
        
        if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = position
            spriteComponent.node.zPosition = zPosition
            spriteComponent.node.name = nodeName
            spriteComponent.node.alpha = alpha
            
            if nodeName.contains("filament") {
                filamentScale *= -1
                spriteComponent.node.xScale = filamentScale
            }
            
        }
        
        entityManager.add(entity)
    }
    
    func buildMap() {
        let tilesetReferences = [CGPoint(x: frame.midX-280, y: frame.midY+170),CGPoint(x: frame.midX+101.5, y: frame.midY-28),CGPoint(x: frame.midX+393, y: frame.midY+155),CGPoint(x: frame.midX+741, y: frame.midY-59)]
        
        let filamentReferences = [CGPoint(x: frame.midX-69, y: frame.midY+16),CGPoint(x: frame.midX+278, y: frame.midY+16), CGPoint(x: frame.midX+602, y: frame.midY+2)]
        
        for i in 1...totalDeFases {
            let stage = BaseOfStages.buscar(id: "\(i)")
            
            let height = stage?.height ?? 0
            let width = stage?.width ?? 0
            let status = stage?.status ?? ""
            let showRobot = stage?.isAtualFase ?? false
            let number = stage?.number ?? 1
            
            drawnMaps(height: height, width: width, tilesetReference: tilesetReferences[i-1], status: status, showRobot: showRobot, numberFase: number)
            
            if i != totalDeFases {
                let stage = BaseOfStages.buscar(id: "\(i+1)")
                if stage?.status == "unavailable" {
                    addEntity(entity: Filament(status: "unavailable"), nodeName: "filament", position: filamentReferences[i-1], zPosition: 2, alpha: 0.35)
                } else {
                    addEntity(entity: Filament(status: "available"), nodeName: "filament", position: filamentReferences[i-1], zPosition: 2, alpha: 1)
                }
            }
        }

    }
    
    func moveMap(direction: Direction, x: CGFloat) {
        
        self.enumerateChildNodes(withName: "stage-available[1-4]", using: ({
            (node,error) in
            if direction == Direction.backward {
                node.position.x += x
            } else {
                node.position.x -= x
            }
        }))
        
        self.enumerateChildNodes(withName: "stage-unavailable[1-4]", using: ({
            (node,error) in
            if direction == Direction.backward {
                node.position.x += x
            } else {
                node.position.x -= x
            }
        }))
        
        self.enumerateChildNodes(withName: "filament", using: ({
            (node,error) in
            if direction == Direction.backward {
                node.position.x += x
            } else {
                node.position.x -= x
            }
        }))
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            touchesBeganLocation = location
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if locationAnterior.x < location.x {
                if self.posicao > 0 {
                    moveMap(direction: Direction.backward, x: 5)
                    self.posicao -= 1
                }
            } else {
                if self.posicao < 105 {
                    moveMap(direction: Direction.forward, x: 5)
                    self.posicao += 1
                }
            }
            locationAnterior = location
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if location == touchesBeganLocation {
                let nodes = self.nodes(at: location)
                if nodes[0].name?.contains("stage-available") ?? false {
                    for i in 1...totalDeFases {
                        let stage = BaseOfStages.buscar(id: "\(i)")
                        stage?.isAtualFase = false
                        
                        if nodes[0].name?.contains("\(i)") ?? false {
                            stage?.isAtualFase = true
                            UserDefaults.standard.set(i, forKey: "selectedFase")
                        }
                        BaseOfStages.salvar(stage: stage!)
                    }
                    let gameScene = GameScene(size: view!.bounds.size)
                    view!.presentScene(gameScene)
                }
                if nodes[0].name?.contains("config-button") ?? false {
                    let configScene = ConfigScene(size: view!.bounds.size)
                    configScene.userData = configScene.userData ?? NSMutableDictionary()
                    configScene.userData!["backSaved"] = backName
                    view!.presentScene(configScene)
                }
            }
        }
        
    }
    
}

