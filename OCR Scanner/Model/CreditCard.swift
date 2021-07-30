/*
 CreditCard.swift
 OCR Scanner

 Created by Minaam Ahmed Awan on 11/07/2021.

 Abstract:
 Model for Credit Card.
*/


import Foundation


public struct CreditCard {
    
    public var cardNumber: String
    
    public var issueDate: DateComponents
    
    public var expireDate: DateComponents
    
    public var holderName: String
}
