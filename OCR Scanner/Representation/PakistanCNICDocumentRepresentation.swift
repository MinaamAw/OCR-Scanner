/*
 PakistanCNICDocumentRepresentation.swift
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 11/07/2021.
 
 Abstract:
 Pakistan CNIC Document Representation: Represent Results to ViewController.
 */


class PakistanCNICDocumentRepresentationViewController: UITableViewController {
    
    // Initialize:
    static let tableCellIdentifier = "cnicContentCell"
    var documentArray = [CNIC]()
    var imgView: UIImage?
    
    
    @IBOutlet weak var containerImageView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print(documentArray)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLoad()
}
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Generate Model Array:
    private func generateModelArray(_ documentModel: CNIC) -> Any? {
        return [documentModel]
    }
}


// MARK: Extensions:
extension PakistanCNICDocumentRepresentationViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PakistanCNICDocumentRepresentationViewController.tableCellIdentifier, for: indexPath) as! CustomTableViewCell
        
        // Assign Values:
        cell.titleText?.text = "Name"
        cell.detailText?.text = documentArray[indexPath.row].holderName
        
        cell.fatherLabel?.text = "Father"
        cell.fatherText?.text = documentArray[indexPath.row].fatherName

        cell.genderLabel?.text = "Gender"
        cell.genderText?.text = documentArray[indexPath.row].gender
        
        cell.countryLabel?.text = "Country"
        cell.countryText?.text = documentArray[indexPath.row].countryStay
        
        cell.identityLabel?.text = "CNIC"
        cell.identityText?.text = documentArray[indexPath.row].identityNumber
        
        cell.dobLabel?.text = "DOB"
        cell.dobText?.text = documentArray[indexPath.row].birthDate

        cell.doiLabel?.text = "DOI"
        cell.doiText?.text = documentArray[indexPath.row].issueDate
        
        cell.doeLabel?.text = "DOE"
        cell.doeText?.text = documentArray[indexPath.row].expireDate
        
        
        return cell;
    }
    
}
