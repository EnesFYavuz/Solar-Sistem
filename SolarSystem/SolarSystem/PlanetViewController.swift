//
//  PlanetViewController.swift
//  SolarSystem
//
//  Created by Enes Yavuz on 25.06.2020.
//  Copyright © 2020 Enes Yavuz. All rights reserved.
//

import UIKit
import SceneKit



class PlanetViewController: UIViewController{

    @IBOutlet weak var PlanetView: SCNView!
     var sunNode:SCNNode!
    var plantRotationNode:SCNNode!
    var planetNme = ""
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
       let scene = SCNScene()
              // Set the scene to the view
              PlanetView.scene = scene

        PlanetView.scene?.background.contents = UIImage(named: "yildizlar.png")
      
      
        choosePlanet(plantName: planetNme)
        
    }
    func choosePlanet(plantName:String){
        switch plantName {
        case "Güneş":
           createSun()
            break
        case "Merkür":
            self.createPlant(plantname:planetName.mercury, radius:0.02, position: SCNVector3Make(0,0,0), contents: UIImage(named: "mercury.jpg")!,rotation: 59)
            break
        case "Venüs":
            self.createPlant(plantname: planetName.venus, radius:0.04, position: SCNVector3Make(0,0,0), contents: UIImage(named: "venus.jpg")!,rotation: 243)
            break
        case "Dünya":
              self.createPlant(plantname: planetName.earth, radius:0.05, position: SCNVector3Make(0,0,0), contents: UIImage(named: "earth.jpg")!,rotation: 1)
            break
        case "Mars":
            self.createPlant(plantname: planetName.mars, radius:0.03, position: SCNVector3Make(0,0,0), contents: UIImage(named: "mars.jpg")!,rotation: 1.02)
            break
        case "Jüpiter":
            self.createPlant(plantname: planetName.jupiter, radius:0.15, position: SCNVector3Make(0,0,0), contents: UIImage(named: "jupiter.jpg")!,rotation: 0.42)
            break
        case "Satürn":
            self.createPlant(plantname: planetName.saturn, radius:0.12, position: SCNVector3Make(0,0,0), contents: UIImage(named: "saturn.jpg")!,rotation: 0.44)
            break
        case "Uranüs":
            self.createPlant(plantname: planetName.uranus, radius:0.09, position: SCNVector3Make(0,0,0), contents: UIImage(named: "uranus.jpg")!,rotation: 0.46)
            break
        case "Neptün":
            self.createPlant(plantname: planetName.neptune, radius:0.08, position: SCNVector3Make(0,0,0), contents: UIImage(named: "neptune.jpg")!,rotation: 0.625)
            break
        default:
            break
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LabelController"{
            let destVC = segue.destination as! LabelViewController
            destVC.labelPlanetName = planetNme
        }
    }
    func createPlant(plantname:planetName,radius:CGFloat,position:SCNVector3,contents:UIImage,rotation:CFTimeInterval){
     self.plantRotationNode = SCNNode()
     let plant=SCNNode()
     plant.geometry=SCNSphere(radius: radius)
     plant.position=plantname == .saturn ? SCNVector3Make(0,0,0):position
     plant.geometry?.firstMaterial?.diffuse.contents = contents
     plant.geometry?.firstMaterial?.locksAmbientWithDiffuse=true
     plant.geometry?.firstMaterial?.shininess=0.1
     plant.geometry?.firstMaterial?.specular.intensity=0.5
     addAnimation(rotate: rotation, node: plant)
     
     if plantname == .saturn{
         let saturnGroub = SCNNode()
         saturnGroub.position = position
         saturnGroub.addChildNode(plant)
         saturnGroub.addChildNode(self.addRingToPlanet(contents: UIImage(named: "saturn_ring.jpg")!))
        
         plantRotationNode.addChildNode(saturnGroub)
     }else{
         plantRotationNode.addChildNode(plant)
     }
    
        self.PlanetView.scene?.rootNode.addChildNode(plantRotationNode)
    }
    func addAnimation(rotate:CFTimeInterval,node:SCNNode){
        node.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: rotate)))
        
    }
  
    func addRingToPlanet(contents:UIImage)->SCNNode{
        let planetRing=SCNNode()
        planetRing.opacity=0.4
        planetRing.geometry=SCNCylinder(radius: 0.13, height: 0.001)
        planetRing.eulerAngles=SCNVector3Make(-40,0,0)
        planetRing.geometry?.firstMaterial?.diffuse.contents=contents
        planetRing.geometry?.firstMaterial?.diffuse.mipFilter = .linear
        planetRing.geometry?.firstMaterial?.lightingModel = .constant
        return planetRing
    }
      func createSun(){
        self.sunNode=SCNNode()
        self.sunNode.geometry=SCNSphere(radius: 0.25)
        self.sunNode.position=SCNVector3Make(0, -0.1, -3)
        self.PlanetView.scene?.rootNode.addChildNode(sunNode)
        self.sunNode.geometry?.firstMaterial?.multiply.contents=UIImage(named: "sun.jpg")
        self.sunNode.geometry?.firstMaterial?.diffuse.contents=UIImage(named: "sun.jpg")
        self.sunNode.geometry?.firstMaterial?.lightingModel = .constant
        self.sunNode.geometry?.firstMaterial?.locksAmbientWithDiffuse=true
        sunAnimation()
    }
    
    func createspinAction(duration:CFTimeInterval)->SCNAction{
          let rotationValue = CGFloat.pi
          let rotate = SCNAction.rotateBy(x: 0, y: rotationValue, z: 0, duration: duration)
          let moveSequence = SCNAction.sequence([rotate])
          let moveLoop = SCNAction.repeatForever(moveSequence)
          return moveLoop
          
      }
    func sunAnimation(){
        let action = createspinAction(duration: 24.7)
        self.sunNode.runAction(action, forKey: "rotation")
    }
    
    @IBAction func cameraControl(_ sender: UISwitch) {
        if (sender.isOn == true)
        {
            PlanetView.allowsCameraControl = true
        }
        else{
            PlanetView.allowsCameraControl = false
        }
    }
  
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

