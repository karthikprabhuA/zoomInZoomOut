//
//  ViewController.swift
//  zoomInZoomOut
//
//  Created by Karthikprabhu Alagu on 6/18/17.
//  Copyright © 2017 Karthikprabhu Alagu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var actionView: UIView!
    var collectionView:UICollectionView!
    var numberOfItems = 1
    var zoomGestureLastScale:CGFloat = 0
    let mainScreenWidth = UIScreen.main.bounds.width
    let mainScreenHeight = UIScreen.main.bounds.height
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let flowLayout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: actionView.frame, collectionViewLayout: flowLayout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.cyan
        self.view.addSubview(collectionView)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(sender:)))
        collectionView.addGestureRecognizer(pinchGesture)
    }
    func pinchAction(sender:UIPinchGestureRecognizer){
        if sender.state == .began{
            print("Pinch Began")
            self.zoomGestureLastScale = sender.scale;
        }
        if sender.state == .changed{
            print(String(format:"Pinch scale: %1.3f",sender.scale))
            //zoomin
            if sender.scale > zoomGestureLastScale {
                if  self.collectionView.frame.width <= mainScreenWidth ||  self.collectionView.frame.height <= mainScreenHeight{
                    self.collectionView.frame = CGRect(x:max(self.collectionView.frame.origin.x - 5,0) ,y:max(self.collectionView.frame.origin.y - 5,0),width:min(self.collectionView.frame.size.width + 10,mainScreenWidth),height:min(self.collectionView.frame.size.height + 10,mainScreenHeight))
                    if self.collectionView.frame.size.height >= mainScreenHeight/2{
                        numberOfItems = 20
                        self.collectionView.reloadData()
                    }
                }
            }else{ //zoomout
                if  self.collectionView.frame.width <= mainScreenWidth ||  self.collectionView.frame.height <= mainScreenHeight{
                    self.collectionView.frame = CGRect(x:min(self.collectionView.frame.origin.x + 5,actionView.frame.origin.x) ,y:min(self.collectionView.frame.origin.y + 5,actionView.frame.origin.y),width:max(self.collectionView.frame.size.width - 10,actionView.frame.size.width),height:max(self.collectionView.frame.size.height - 10,actionView.frame.size.height))
                    if self.collectionView.frame.size.height <= mainScreenHeight/2{
                        numberOfItems = 1
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        if sender.state == .ended{
            print("Pinch Ended")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonTapped(){
        self.expandView()

    }
    
    func expandView()  {
        numberOfItems = 20
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.collectionView.frame = self.view.bounds
        }, completion: {(_ finished: Bool) -> Void in
            self.collectionView.reloadData()

        })
        }
}
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath)
        
        cell.backgroundColor = UIColor.green
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if   self.numberOfItems == 1{
            expandView()
        }
        else {self.numberOfItems = 1
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.collectionView.frame = self.actionView.frame
            self.collectionView.reloadData()
            
        }, completion: {(_ finished: Bool) -> Void in
        })
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}

