//
//  ViewController.swift
//  TaggAR
//  Copyright © 2018 Ari Herman. All rights reserved.


import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var draw: UIButton!
    
    @IBOutlet weak var arView: ARSCNView!
    
    @IBOutlet weak var hiddenButton: UIButton!
    
    //    IBOutlet-reference to storyboard/ IBAction- reference to an action
    
    let configuration = ARWorldTrackingConfiguration()
//    let for values that do not change/ var for values that do change
    var colorPicker = UIColor.black
    
    var showHiddenButton = false
    var canvasNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.arView.showsStatistics = true
        self.arView.session.run(configuration)
        self.arView.delegate = self
        self.arView.isUserInteractionEnabled = true
        arView.scene.rootNode.addChildNode(canvasNode)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointView = arView.pointOfView else {return}
        let transform = pointView.transform
        let cameraOrigin = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        let translation = SCNVector3(transform.m41, transform.m42, transform.m43)
        let cameraRelativePosition = cameraOrigin + translation
       
        DispatchQueue.main.async {
            
            if self.draw.isHighlighted {
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.position = cameraRelativePosition
                sphereNode.geometry?.firstMaterial?.diffuse.contents = self.colorPicker
               
                if self.showHiddenButton == false {
                    self.buttonIsVisible()
                }
                
                self.canvasNode.addChildNode(sphereNode)
//                self.arView.scene.rootNode.addChildNode(sphereNode)
                print("draw button is being pressed")
            }
        }
    }
    
    func buttonIsVisible() {
        self.showHiddenButton = true
        hiddenButton.isHidden = false
    }
    
    
    @IBAction func reset(_ sender: Any) {
        self.canvasNode.enumerateChildNodes { (node, _) in
           node.removeFromParentNode()
        }
        hiddenButton.isHidden = true
        self.showHiddenButton = false
    }
    
    @IBAction func red(_ sender: Any) {
        self.colorPicker = UIColor.red
    }
    
    @IBAction func blue(_ sender: Any) {
        self.colorPicker = UIColor.blue
    }
    
    @IBAction func black(_ sender: Any) {
        self.colorPicker = UIColor.black
    }
    
    @IBAction func green(_ sender: Any) {
        self.colorPicker = UIColor.green
    }
    
    @IBAction func white(_ sender: Any) {
        self.colorPicker = UIColor.white
    }
    
}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

//        translation is location translationally
//        cameraOrigin is the initial orientation of the camera

//            else {
//
//                let pointer = SCNNode(geometry: SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0.01/2))
//                pointer.name = "center"
//                pointer.position = cameraRelativePosition
//
//                self.arView.scene.rootNode.enumerateChildNodes({ (node, _) in
//                    if node.name == "center" {
//                        node.removeFromParentNode()
//                    }
//                })
//                self.arView.scene.rootNode.addChildNode(pointer)
//                pointer.geometry?.firstMaterial?.diffuse.contents = String("X")
//            }

