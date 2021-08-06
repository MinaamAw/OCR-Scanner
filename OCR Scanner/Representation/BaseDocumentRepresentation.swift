/*
 BaseDocumentRepresentation.swift
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 30/07/2021.
 
 Abstract:
 Base Document Representation: Base Representation Class.
 */


open class BaseDocumentRepresentation: DocumentRepresentation {
    
    // Initialize:
    static let cnicRepresentation = "cnicVC"
    static let creditCardRepresentation = "ccvC"
    
    
    // Handle Document Representation:
    public override func representationHandler(_ imageKind: ImageKind) -> String? {
        
        // Initialize:
        var vcID: String?
        
        // Handle Image Type:
        switch imageKind {
        case .cnic:
            vcID = BaseDocumentRepresentation.cnicRepresentation
        case .creditCard:
            vcID = BaseDocumentRepresentation.creditCardRepresentation
        default:
            print("Representation not matched")
        }
        
        return vcID
    }
    
}
