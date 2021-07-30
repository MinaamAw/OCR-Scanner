///*
// CreditCardExtractor.swift
// OCR Scanner
// 
// Created by Minaam Ahmed Awan on 11/07/2021.
// 
// Abstract:
// Credit Card Extractor: OCR Method to Detect Text by the use of Frames Extracted from Feed using Vision Framework.
// */
//
//
//import Reg
//
//
//
//final class CreditCardE {
//    
//    
//    // Enums:
//    enum Candidate: Hashable {
//        case number(String), name(String)
//        case issueDate(DateComponents)
//        case expireDate(DateComponents)
//    }
//    
//    
//    // Intialize:
//    typealias PredictedCount = Int
//    private var selectedCard = CreditCard()
//    
//    
//    // Properties:
//    private var predictedCardInfo: [Candidate: PredictedCount] = [:]
//    private var dateCount = 0
//    private var intYear = 0
//    private var intExpYear = 0
//    
//    
//    // Functions
//    private func extractInfo() {
//        
//        // Regex:
//        let creditCardNumber: Regex = #"(?:\d[ -]*?){13,16}"#
//        let month: Regex = #"(\d{2})\/\d{2}"#
//        let year: Regex = #"\d{2}\/(\d{2})"#
//        let wordsToSkip = ["mastercard", "jcb", "visa", "express", "bank", "card", "platinum", "reward", "credt", "card"]
//        let invalidNames = ["expiration", "valid", "since", "from", "until", "month", "year", "thru"]
//        let name: Regex = #"([A-z]{2,}\h([A-z.]+\h)?[A-z]{2,})"#
//        
//        
//        // OCR Text Request:
//        let maxCandidates = 1
//        textRequest = VNRecognizeTextRequest { textRequest, error in
//            guard let observations = textRequest.results as? [VNRecognizedTextObservation],
//                  error == nil else {
//                return
//                
//            }
//            
//            var creditCard = CreditCard(cardNumber: nil, issueDate: nil, expireDate: nil, holderName: nil)
//            
//            for result in observations {
//                guard let candidate = result.topCandidates(maxCandidates).first,
//                      candidate.confidence > 0.45
//                else { continue }
//                
//                let string = candidate.string
//                let containsWordToSkip = wordsToSkip.contains { string.lowercased().contains($0) }
//                if containsWordToSkip { continue }
//                
//                // Value Extractor:
//                if let cardNumber = creditCardNumber.firstMatch(in: string)?
//                    .replacingOccurrences(of: " ", with: " ")
//                    .replacingOccurrences(of: "-", with: " ") {
//                    creditCard.cardNumber = cardNumber
//                    
//                    
//                } else if let month = month.captures(in: string).last.flatMap(Int.init),
//                          let year = year.captures(in: string).last.flatMap({ Int("20" + $0) }) {
//                    
//                    if self.dateCount == 0 {
//                        creditCard.issueDate = DateComponents(year: year, month: month)
//                        self.dateCount = self.dateCount + 1
//                        self.intYear = year
//                    }
//                    else {
//                        if self.intYear == year {
//                            if self.intExpYear == 0 {
//                                creditCard.expireDate = DateComponents(year: year, month: month)
//                            } else {
//                                creditCard.issueDate = DateComponents(year: year, month: month)
//                            }
//                        } else {
//                            self.intExpYear = self.intExpYear + 1
//                            creditCard.expireDate = DateComponents(year: year, month: month)
//                        }
//                    }
//                } else if let name = name.firstMatch(in: string) {
//                    let containsInvalidName = invalidNames.contains { name.lowercased().contains($0) }
//                    if containsInvalidName { continue }
//                    creditCard.holderName = name
//                    
//                } else {
//                    continue
//                }
//            }
//            
//            
//            // Matching:
//            if let number = creditCard.cardNumber {
//                let count = self.predictedCardInfo[.number(number), default: 0]
//                self.predictedCardInfo[.number(number)] = count + 1
//                
//                if count > 1 {
//                    self.selectedCard.cardNumber = number
//                }
//            }
//            
//            if let issueDate = creditCard.issueDate {
//                let count = self.predictedCardInfo[.issueDate(issueDate), default: 0]
//                self.predictedCardInfo[.issueDate(issueDate)] = count + 1
//                
//                if count > 1 {
//                    self.selectedCard.issueDate = issueDate
//                }
//            }
//            
//            if let expireDate = creditCard.expireDate {
//                let count = self.predictedCardInfo[.expireDate(expireDate), default: 0]
//                self.predictedCardInfo[.expireDate(expireDate)] = count + 1
//                
//                if count > 1 {
//                    self.selectedCard.expireDate = expireDate
//                }
//            }
//            
//            if let name = creditCard.holderName {
//                let count = self.predictedCardInfo[.name(name), default: 0]
//                self.predictedCardInfo[.name(name)] = count + 1
//                
//                if count > 5 {
//                    self.selectedCard.holderName = name
//                }
//            }
//            if self.selectedCard.cardNumber != nil && self.selectedCard.holderName != nil {
//                print(self.selectedCard)
//                return
//            }
//        }
//    }
//}
