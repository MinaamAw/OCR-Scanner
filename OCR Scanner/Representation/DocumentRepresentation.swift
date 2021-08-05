/*
 DocumentRepresentation.swift
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 30/07/2021.
 
 Abstract:
 Document Representation: Parent & Abstract Class.
 */


protocol DocumentRepresentationProtocol {
    
    // Method:
    func representationHandler(_ imageKind: ImageKind) -> String? 
}


open class DocumentRepresentation: DocumentRepresentationProtocol {
    
    // Method:
    public func representationHandler(_ imageKind: ImageKind) -> String? {
        
        return nil
    }
}
