//
//  CharacterDetailsVC.swift
//  SEIDORTask
//
//  Created by Sundhar on 06/07/24.
//

import UIKit

class CharacterDetailsVC: UIViewController {
    
    @IBOutlet weak var detailCharacterImg: UIImageView!
    
    @IBOutlet weak var characterNameLbl: UILabel!
    
    @IBOutlet weak var characterIDLbl: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    
    var characterID:Int = 0
    var characterName:String = ""
    var characterImageURL:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        self.characterIDLbl?.text = "\(characterID)"
        self.characterNameLbl.text  = characterName
        if let url = URL(string: characterImageURL) {
            downloadImage(from: url)
        } else {
            // Handle invalid URL case
            print("Invalid URL for character image")
        }
    }
    
    func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    self.detailCharacterImg.image = UIImage(data: data)
                }
            }
        }.resume()
    }
    
    @objc func backTapped() {
        navigationController?.popToRootViewController(animated: true)
        self.characterNameLbl.text = ""
        self.detailCharacterImg.image = UIImage(named: "")
        dismiss(animated: true)
    }
}
