//
//  ViewController.swift
//  SolarSystem
//
//  Created by Enes Yavuz on 13.05.2020.
//  Copyright © 2020 Enes Yavuz. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import FirebaseDatabase
import Network

enum planetName:String {
    case mercury="Merkür"
    case earth="Dünya"
    case jupiter="Jüpiter"
    case mars="Mars"
    case neptune="Neptün"
    case saturn="Satürn"
    case uranus="Uranüs"
    case venus="Venüs"
}

class ViewController: UIViewController, ARSCNViewDelegate {
 
    @IBOutlet var sceneView: ARSCNView!

    
    var sunNode:SCNNode!
    var sunhaloNode:SCNNode!
    var nameToPlanet = ""
    var ref: DatabaseReference!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.allowsCameraControl = true
        let scene = SCNScene()
        
        sceneView.scene = scene
        self.createSun()
        self.createPlanets()
        self.monitorNetwork()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        

        // Run the view's session
        sceneView.session.run(configuration)
    }
  
    func createPlanets(){
        self.createPlant(plantname: planetName.mercury, radius:0.02, position: SCNVector3Make(0.4,0,0), contents: UIImage(named: "mercury.jpg")!, rotationDuration: 25/*87.969*/,rotationAroundSelf: 59, orbitRadius: 0.4,textPosition: SCNVector3Make(0.4, 0.06, 0))
        self.createPlant(plantname: planetName.venus, radius:0.04, position: SCNVector3Make(0.6,0,0), contents: UIImage(named: "venus.jpg")!, rotationDuration: 40 /*224.698*/,rotationAroundSelf: 243, orbitRadius: 0.6,textPosition: SCNVector3Make(0.6, 0.06, 0))
        self.createPlant(plantname: planetName.earth, radius:0.05, position: SCNVector3Make(0.8,0,0), contents: UIImage(named: "earth.jpg")!, rotationDuration: 30 /*365.25*/,rotationAroundSelf: 1, orbitRadius: 0.8,textPosition: SCNVector3Make(0.8, 0.06, 0))
        self.createPlant(plantname: planetName.mars, radius:0.03, position: SCNVector3Make(1.0,0,0), contents: UIImage(named: "mars.jpg")!, rotationDuration: 35 /*686.960*/,rotationAroundSelf: 1.02, orbitRadius: 1.0,textPosition: SCNVector3Make(1.0, 0.06, 0))
        self.createPlant(plantname: planetName.jupiter, radius:0.15, position: SCNVector3Make(1.4,0,0), contents: UIImage(named: "jupiter.jpg")!, rotationDuration: 90 /*4333.28*/,rotationAroundSelf: 0.42, orbitRadius: 1.4,textPosition: SCNVector3Make(1.4, 0.15, 0))
        self.createPlant(plantname: planetName.saturn, radius:0.12, position: SCNVector3Make(1.68,0,0), contents: UIImage(named: "saturn.jpg")!, rotationDuration: 80 /*10755.7*/,rotationAroundSelf: 0.44, orbitRadius: 1.68,textPosition: SCNVector3Make(1.68, 0.15, 0))
        self.createPlant(plantname: planetName.uranus, radius:0.09, position: SCNVector3Make(1.95,0,0), contents: UIImage(named: "uranus.jpg")!, rotationDuration: 55 /*30685.4*/,rotationAroundSelf: 0.46, orbitRadius: 1.95,textPosition: SCNVector3Make(1.95, 0.15, 0))
        self.createPlant(plantname: planetName.neptune, radius:0.08, position: SCNVector3Make(2.14,0,0), contents: UIImage(named: "neptune.jpg")!, rotationDuration: 50 /*30685.4*/,rotationAroundSelf: 0.625, orbitRadius: 2.14,textPosition: SCNVector3Make(2.14, 0.15, 0))
    }
    func createPlant(plantname:planetName,radius:CGFloat,position:SCNVector3,contents:UIImage,rotationDuration:CFTimeInterval,
    rotationAroundSelf:CFTimeInterval,orbitRadius:CGFloat,textPosition:SCNVector3){
        let plant=SCNNode()
        plant.geometry=SCNSphere(radius: radius)
        plant.position=plantname == .saturn ? SCNVector3Make(0, 0, 0) : position
        plant.geometry?.firstMaterial?.diffuse.contents = contents
        plant.geometry?.firstMaterial?.locksAmbientWithDiffuse=true
        plant.geometry?.firstMaterial?.shininess=0.1
        plant.geometry?.firstMaterial?.specular.intensity=0.5
        plant.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: rotationAroundSelf)))
       
        let plantRotationNode=SCNNode()
        if plantname == .saturn{
            let saturnGroub = SCNNode()
            saturnGroub.position = position
            saturnGroub.addChildNode(plant)
            saturnGroub.addChildNode(self.addRingToPlanet(contents: UIImage(named: "saturn_ring.jpg")!))
            plantRotationNode.addChildNode(saturnGroub)
        }else{
            plantRotationNode.addChildNode(plant)
        }
       
        addTextPlanet(textname: plantname.rawValue, textposition: textPosition, nodes: plantRotationNode)
       planetAnimation(rotationduration:rotationDuration,node:plantRotationNode,planetName:"\(plantname.rawValue)")

        //orbit
        let planetOrbit = SCNNode()
        planetOrbit.geometry=SCNTorus(ringRadius: orbitRadius, pipeRadius: 0.001)
        planetOrbit.geometry?.firstMaterial?.diffuse.contents=UIColor.white
        planetOrbit.geometry?.firstMaterial?.diffuse.mipFilter = .linear
        planetOrbit.rotation=SCNVector4Make(0,1,0,Float.pi/2)
        self.sunNode.addChildNode(planetOrbit)
        
    }
    func planetAnimation(rotationduration:CFTimeInterval,node:SCNNode,planetName:String){
           let animation=CABasicAnimation(keyPath: "rotation")
           animation.duration=rotationduration
           animation.toValue=NSValue.init(scnVector4: SCNVector4Make(0,1,0,Float.pi*2))
           animation.repeatCount=Float.greatestFiniteMagnitude
           node.addAnimation(animation, forKey: planetName)
           self.sunNode.addChildNode(node)
       }
    func addRingToPlanet(contents:UIImage)->SCNNode{
        let planetRing=SCNNode()
        planetRing.opacity=0.4
        planetRing.geometry=SCNCylinder(radius: 0.3, height: 0.001)
        planetRing.eulerAngles=SCNVector3Make(-45, 0, 0)
        planetRing.geometry?.firstMaterial?.diffuse.contents=contents
        planetRing.geometry?.firstMaterial?.diffuse.mipFilter = .linear
        planetRing.geometry?.firstMaterial?.lightingModel = .constant
        return planetRing
    }
    func createSun(){
        self.sunNode=SCNNode()
        self.sunNode.geometry=SCNSphere(radius: 0.25)
        self.sunNode.position=SCNVector3Make(0, -0.1, -3)
        self.sceneView.scene.rootNode.addChildNode(self.sunNode)
        self.sunNode.geometry?.firstMaterial?.multiply.contents=UIImage(named: "sun.jpg")
        self.sunNode.geometry?.firstMaterial?.diffuse.contents=UIImage(named: "sun.jpg")
        self.sunNode.geometry?.firstMaterial?.lightingModel = .constant
       
        self.sunNode.geometry?.firstMaterial?.locksAmbientWithDiffuse=true

        
        self.addText(textname: "Güneş", textposition: SCNVector3Make(-0.16, 0.24,0.02))
        //gunes icin animasyon
        self.sunAnimation()
        
    }
    func addText(textname:String,textposition:SCNVector3){
        let text = SCNText(string: textname, extrusionDepth: 1)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.black
        text.materials = [material]
        let node = SCNNode()
        node.position = textposition
        node.scale = SCNVector3(x:0.01,y:0.01,z:0.01)
        node.geometry = text
        self.sunNode.addChildNode(node)
    }
    func addTextPlanet(textname:String,textposition:SCNVector3,nodes:SCNNode){
           let text = SCNText(string: textname, extrusionDepth: 1)
           let material = SCNMaterial()
           material.diffuse.contents = UIColor.black
           text.materials = [material]
           let node = SCNNode()
           node.position = textposition
           node.scale = SCNVector3(x:0.007,y:0.007,z:0.007)
           node.geometry = text
        nodes.addChildNode(node)
        self.sunNode.addChildNode(nodes)
       }
    
    func sunAnimation(){
        let action = createspinAction(duration: 24.7)
        self.sunNode.runAction(action, forKey: "rotation")
    }
    func createspinAction(duration:CFTimeInterval)->SCNAction{
        let rotationValue = CGFloat.pi
        let rotate = SCNAction.rotateBy(x: 0, y: rotationValue, z: 0, duration: duration)
        let moveSequence = SCNAction.sequence([rotate])
        let moveLoop = SCNAction.repeatForever(moveSequence)
        return moveLoop
        
    }
    func monitorNetwork(){
        let monitor = NWPathMonitor( )
        monitor.pathUpdateHandler={
            path in if path.status == .satisfied{
                DispatchQueue.main.async {
                    print("internet connection")
                }
            }else{
                DispatchQueue.main.async{
                let alert = UIAlertController(title: "Uyarı", message: "İnternet bağlantınız bulunmamaktadır", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "TAMAM", style: .cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            }
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
    
    
    @IBAction func SUN(_ sender: UIButton) {  
        self.nameToPlanet = "Güneş"
        performSegue(withIdentifier: "AboutPlanetSegue", sender: self)
    }
    @IBAction func MERCURY(_ sender: UIButton) {
        self.nameToPlanet = "Merkür"
        performSegue(withIdentifier: "AboutPlanetSegue", sender: self)
    }
    @IBAction func VENUS(_ sender: UIButton) {
        self.nameToPlanet = "Venüs"
        performSegue(withIdentifier: "AboutPlanetSegue", sender: self)
    }
    @IBAction func EARTH(_ sender: UIButton) {
        self.nameToPlanet = "Dünya"
        performSegue(withIdentifier: "AboutPlanetSegue", sender: self)
    }
    @IBAction func MARS(_ sender: UIButton) {
        self.nameToPlanet = "Mars"
        performSegue(withIdentifier: "AboutPlanetSegue", sender: self)
    }
    @IBAction func JUPITER(_ sender: UIButton) {
        self.nameToPlanet = "Jüpiter"
        performSegue(withIdentifier: "AboutPlanetSegue", sender: self)
    }
    @IBAction func SATURN(_ sender: UIButton) {
        self.nameToPlanet = "Satürn"
        performSegue(withIdentifier: "AboutPlanetSegue", sender: self)
    }
    @IBAction func URANUS(_ sender: UIButton) {
        self.nameToPlanet = "Uranüs"
        performSegue(withIdentifier: "AboutPlanetSegue", sender: self)
    }
    @IBAction func NEPTUNE(_ sender: UIButton) {
        self.nameToPlanet = "Neptün"
        performSegue(withIdentifier: "AboutPlanetSegue", sender: self)
    }    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PlanetViewController
        vc.planetNme = self.nameToPlanet
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.
    

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}


