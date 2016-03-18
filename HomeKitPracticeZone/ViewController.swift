//
//  ViewController.swift
//  HomeKitPracticeZone
//
//  Created by Nam (Nick) N. HUYNH on 3/18/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit
import HomeKit

class ViewController: UIViewController {
    
    let bedroomKeyword = "bedroom"
    var numberOfBedroomsAdded = 0
    let numberOfBedroomsToAdd = 2
    var home: HMHome!
    var bedroomZone: HMZone!
    var randomHomeName: String = {
        
        return "Home \(arc4random_uniform(UInt32.max))"
        
        }()
    var homeManager: HMHomeManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeManager = HMHomeManager()
        homeManager.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addZoneCompletionHandler(zone: HMZone!, error: NSError!) {
        
        if error != nil {
            
            println("Failed to add zone: \(error.description)")
            return
            
        }
        
        println("Success to add zone")
        bedroomZone = zone
        home.addRoomWithName("Master bedroom", completionHandler: roomAddedToHomeCompletionHandler)
        home.addRoomWithName("Kid's bedroom", completionHandler: roomAddedToHomeCompletionHandler)
        home.addRoomWithName("Gaming Room", completionHandler: roomAddedToHomeCompletionHandler)
        
    }
    
    func roomAddedToHomeCompletionHandler(room: HMRoom!, error: NSError!) {
        
        if error != nil {
            
            println("Failed to add room: \(error)")
            return
            
        }
        
        if (room.name as NSString).rangeOfString(bedroomKeyword, options: NSStringCompareOptions.CaseInsensitiveSearch).location != NSNotFound {
            
            println("Success to add room to home")
            println("Adding room to zone")
            bedroomZone.addRoom(room, completionHandler: { (error) -> Void in
                
                if error != nil {
                    
                    println("Failed to add room to zone. Error = \(error)")
                    return
                    
                }
                
                println("Successfully added a bedroom to the Bedroom zone")
                self.numberOfBedroomsAdded++
                
                if self.numberOfBedroomsAdded == self.numberOfBedroomsToAdd {
                    
                    self.home.removeZone(self.bedroomZone, completionHandler: { (error: NSError!) -> Void in
                    
                    if error != nil {
                    
                    println("Failed to remove the zone")
                    return
                    
                    }
                    
                    println("Successfully removed the zone")
                    println("Removing the home now...")
                    self.homeManager.removeHome(self.home, completionHandler: { (error: NSError!) -> Void in
                        
                        if error != nil {
                        
                        println("Failed to remove the home")
                        return
                        
                        }
                        
                        println("Removed the home")
                        
                        })
                    
                    })
                    
                }
                
                })
            
        } else {
            
            println("The room that is added is not a bedroom")
            
        }
        
    }
    
}

extension ViewController: HMHomeManagerDelegate {
                        
    func homeManagerDidUpdateHomes(manager: HMHomeManager!) {
                    
        manager.addHomeWithName(randomHomeName, completionHandler: { (home, error) -> Void in
                    
        if error != nil {
            
            println("Failed to add home: \(error.description)")
            return
            
        }
                    
        println("Added home: \(home.name)")
        self.home = home
        home.addZoneWithName("Bedrooms", completionHandler: self.addZoneCompletionHandler)
                    
        })
                    
    }
                        
}