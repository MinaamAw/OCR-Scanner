/*
 ViewController.swift
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 11/07/2021.
 
 Abstract:
 Main View Controller: Handles Scan Button Action and Displays Saved Scans.
 */


import UIKit


class ViewController: UIViewController {
    
    
    // Handle Button Action:
    @IBAction func scanBtn(_ sender: UIBarButtonItem) {
        
        // Initialize:
        let cameraViewController =
            storyboard?.instantiateViewController(identifier: "modelProcessorVC") as! ModelProcessorViewController
        
        // Present:
        navigationController?.pushViewController(cameraViewController, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
