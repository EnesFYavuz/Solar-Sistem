//
//  LabelViewController.swift
//  SolarSystem
//
//  Created by Enes Yavuz on 1.09.2020.
//  Copyright © 2020 Enes Yavuz. All rights reserved.
//

import UIKit
import FirebaseDatabase
import AVFoundation

class LabelViewController: UIViewController {

    @IBOutlet weak var PlanetName: UILabel!
    @IBOutlet weak var PlanetInform: UILabel!
    @IBOutlet weak var DistanceSun: UILabel!
    @IBOutlet weak var DistanceSunInform: UILabel!
    @IBOutlet weak var DayLength: UILabel!
    @IBOutlet weak var DayLengthInform: UILabel!
    @IBOutlet weak var Radius: UILabel!
    @IBOutlet weak var RadiusInform: UILabel!
    @IBOutlet weak var PlanetAge: UILabel!
    @IBOutlet weak var PlanetAgeInform: UILabel!
    @IBOutlet weak var OrbitTime: UILabel!
    @IBOutlet weak var OrbitTimeInform: UILabel!
    @IBOutlet weak var PlanetArea: UILabel!
    @IBOutlet weak var PlanetAreaInform: UILabel!
    @IBOutlet weak var PlanetGravity: UILabel!
    @IBOutlet weak var PlanetGravityInform: UILabel!
    var labelPlanetName = ""
    var ref: DatabaseReference!
    var FirePlanetAbout = [String]()
   var FirePlanetSnap = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
         ref = Database.database().reference()
        
        readFirebaseData(planetName: labelPlanetName)
       
    }
    func readFirebaseData(planetName:String){
                  // Set the view's delegate
         PlanetName.skeletonLabel(text: planetName)
       
        self.ref.child("Gezegenler").child(planetName).observe(DataEventType.value, with: { [self] (snapshot) in
                        for child in snapshot.children {
                            let snap = child as! DataSnapshot
                            FirePlanetSnap.append(snap.key)
                            let fireplanetInform = snap.value as! String
                            FirePlanetAbout.append(fireplanetInform)
                        }
                if(planetName=="Güneş"){
                    self.PlanetInform.skeletonLabel(text: FirePlanetAbout[0])
                    self.DistanceSun.skeletonLabel(text:FirePlanetSnap[1])
                    self.DistanceSunInform.skeletonLabel( text:FirePlanetAbout[1])
                    self.DayLength.skeletonLabel(text:FirePlanetSnap[2])
                    self.DayLengthInform.skeletonLabel(text: FirePlanetAbout[2])
                    self.Radius.skeletonLabel(text:FirePlanetSnap[3])
                    self.RadiusInform.skeletonLabel(text:FirePlanetAbout[3])
                    self.PlanetAge.skeletonLabel(text:FirePlanetSnap[4])
                    self.PlanetAgeInform.skeletonLabel(text: FirePlanetAbout[4])
                    self.OrbitTime.skeletonLabel(text:FirePlanetSnap[5])
                    self.OrbitTimeInform.skeletonLabel(text: FirePlanetAbout[5])
                    self.PlanetArea.text=""
                    self.PlanetAreaInform.text=""
                    self.PlanetGravity.text = ""
                    self.PlanetGravityInform.text = ""
                }
                else{
                    self.PlanetInform.skeletonLabel(text: FirePlanetAbout[0])
                    self.DistanceSun.skeletonLabel(text:FirePlanetSnap[1])
                    self.DistanceSunInform.skeletonLabel( text:FirePlanetAbout[1])
                    self.DayLength.skeletonLabel(text:FirePlanetSnap[2])
                    self.DayLengthInform.skeletonLabel(text: FirePlanetAbout[2])
                    self.Radius.skeletonLabel(text:FirePlanetSnap[3])
                    self.RadiusInform.skeletonLabel(text:FirePlanetAbout[3])
                    self.PlanetAge.skeletonLabel(text:FirePlanetSnap[4])
                    self.PlanetAgeInform.skeletonLabel(text: FirePlanetAbout[4])
                    self.OrbitTime.skeletonLabel(text:FirePlanetSnap[5])
                    self.OrbitTimeInform.skeletonLabel(text: FirePlanetAbout[5])
                    self.PlanetArea.skeletonLabel(text:FirePlanetSnap[6])
                    self.PlanetAreaInform.skeletonLabel(text: FirePlanetAbout[6])
                    self.PlanetGravity.skeletonLabel(text:FirePlanetSnap[7])
                    self.PlanetGravityInform.skeletonLabel(text: FirePlanetAbout[7])
                    
            }
                  })
           
       }
    @IBAction func ReadLabel(_ sender: Any) {
        var konusmaMetni=""
        var gunesMetni=""
        var digerGezegenlerMetni=""
        if(labelPlanetName=="Güneş"){
            for i in 0...FirePlanetAbout.count-1{
                if(i==0){
                gunesMetni+=FirePlanetAbout[i]
                }
                else{
                    gunesMetni+="Gezegenimizin "+FirePlanetSnap[i]+FirePlanetAbout[i]
                }
            }
            konusmaMetni="Gezengenimizin adi \(labelPlanetName)"+gunesMetni
            
        }
        else{
            for i in 0...FirePlanetAbout.count-1{
                if(i==0){
                    digerGezegenlerMetni+=FirePlanetAbout[i]
                }
                else{
                    digerGezegenlerMetni+="Gezegenimizin "+FirePlanetSnap[i]+FirePlanetAbout[i]
                }
            }
            konusmaMetni="Gezengenimizin adi \(labelPlanetName)"+digerGezegenlerMetni
        }
        let voice = AVSpeechSynthesizer()
        let toSay = AVSpeechUtterance(string: konusmaMetni)
        toSay.voice = AVSpeechSynthesisVoice(language: "tr-TR")
        voice.speak(toSay)
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
