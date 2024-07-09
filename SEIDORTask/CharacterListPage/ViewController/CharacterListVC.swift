//
//  CharacterListVC.swift
//  SEIDORTask
//
//  Created by Sundhar on 06/07/24.
//

import UIKit
import Alamofire

class CharacterListVC: UIViewController {

    
    @IBOutlet weak var searchTxt: UITextField!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBOutlet weak var characterListCollectionView: UICollectionView!
    
    var charaterlist: CharacterListModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       registerCell()
        callAPI()
        self.logoutBtn.addTarget(self, action: #selector(LogoutTapped), for: .touchUpInside)
        
    }
    
    func registerCell(){
        
        self.characterListCollectionView.delegate = self
        self.characterListCollectionView.dataSource = self
        self.characterListCollectionView.register(UINib(nibName: "CharacterListCVC", bundle: nil), forCellWithReuseIdentifier: "CharacterListCVC")
    }

    func callAPI() {
            CharacterListService.shared.characterListAPI { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let characterList):
                    self.charaterlist = characterList
                    self.characterListCollectionView.reloadData()
                case .failure(let error):
                    print("Error fetching character list: \(error)")
                }
            }
        }
    
    @objc func LogoutTapped(){
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else {
            fatalError("Unable to instantiate LoginVC from storyboard")
        }
        UIApplication.shared.windows.first?.rootViewController = loginVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()

    }
    
   

}

extension CharacterListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.charaterlist?.results.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterListCVC", for: indexPath) as! CharacterListCVC
        
        // Check if indexPath.item is within bounds of charaterlist
        if let character = self.charaterlist?.results[indexPath.item] {
            cell.listNameLbl.text = character.name
            
            // Load image asynchronously
             let imageUrlString = character.image
              if let imageUrl = URL(string: imageUrlString) {
                
                URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                    if let error = error {
                        print("Error loading image: \(error)")
                        // Handle error: e.g., set placeholder image
                        DispatchQueue.main.async {
                            cell.listImg.image = UIImage(named: "placeholder") // Placeholder image or default image
                        }
                        return
                    }
                    
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            // Update cell's image view with the loaded image
                            cell.listImg.image = image
                        }
                    }
                }.resume()
            } else {
                // Handle invalid URL case
                cell.listImg.image = UIImage(named: "placeholder") // Placeholder image or default image
            }
        } else {
            // Handle case where charaterlist or character at indexPath.item is nil
            cell.listNameLbl.text = "Unknown"
            cell.listImg.image = UIImage(named: "placeholder") // Placeholder image or default image
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let results = self.charaterlist?.results else {
            return
        }
        
        let character = results[indexPath.item] // Get selected character
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let characterDetailsVC = storyboard.instantiateViewController(withIdentifier: "CharacterDetailsVC") as? CharacterDetailsVC else {
            fatalError("Unable to instantiate CharacterDetailsVC from storyboard")
        }
        
        // Assign data to the destination view controller
        characterDetailsVC.characterID = character.id
        characterDetailsVC.characterName = character.name
        characterDetailsVC.characterImageURL = character.image
        characterDetailsVC.modalPresentationStyle = .overFullScreen
        self.present(characterDetailsVC, animated: true)
        
    }


    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width/2) - 10, height: 200)
    }

}
