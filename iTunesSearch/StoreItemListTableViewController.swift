
import UIKit

class StoreItemListTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    
    // add item controller property
    
    var ituneItems: [Item] = []
    var currentSection: String!
    let queryOptions = ["movie", "music", "software", "ebook"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func fetchMatchingItems() {
        
        self.ituneItems = []
        self.tableView.reloadData()
        
        let searchTerm = searchBar.text ?? ""
        let mediaType = queryOptions[filterSegmentedControl.selectedSegmentIndex]
        currentSection = mediaType
        
        if !searchTerm.isEmpty {
            
            // set up query dictionary
            let query: [String: String] = [
                "term": searchTerm,
                "country": "US",
                "media": mediaType,
                "limit": "20",
                "explicit": "Yes"
            ]
            
            ItemController.fetchData(with: query) { (storeItems) in
                guard let stores = storeItems else {
                    print("Couldn't fetch")
                    return
                }
                
                DispatchQueue.main.async {
                    for item in stores.results {
                        let oneItem = Item(artist: item.itemAuthor, title: item.itemTitle, kind: item.kind, albumTitle: item.albumTitle, description: item.description, price: item.price, artwork: item.artworkUrl, preview: item.previewUrl)
                        
                        self.ituneItems.append(oneItem)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func configure(cell: ItemTableViewCell, forItemAt indexPath: IndexPath) {
        
        let item = ituneItems[indexPath.row]
        cell.item = item
        
        // set title
        cell.titleLabel.text = item.title ?? ""
        // cell.priceButton.widthAnchor.constraint(equalToConstant: 50)
        cell.priceButton.layer.cornerRadius = 2.2
        
        // set price
        if let price = item.price {
            if price > 0 {
                let formatedPrice = String(format: "$%.2f", price)
                cell.priceButton.setTitle(formatedPrice, for: .normal)
            } else {cell.priceButton.setTitle("Free", for: .normal)}
        } else {
            cell.priceButton.setTitle("Free", for: .normal)
        }
        
        if currentSection == "music" {
            cell.previewView.isHidden = false
            cell.previewView.isOpaque = true
        } else {
            cell.previewView.isHidden = true
            cell.previewView.isOpaque = false
        }
        
        //music cell custom
        if currentSection == "music" {
            cell.descriptionLabel.isHidden = true
            cell.descriptionLabel.isEnabled = false
            
            // change imagesize per type
            updateImageSize(of: cell.artworkImageView, width: 59, height: 59)
            cell.artworkImageView.layer.cornerRadius = 1
            
            let artist = item.artist ?? ""
            let album = item.albumTitle ?? ""
            cell.creatorLabel.text = "\(artist) - \(album)"
        
        // app cell custom
        } else if currentSection == "software" {
            cell.descriptionLabel.isHidden = true
            cell.descriptionLabel.isEnabled = false
            
            // cell.priceButton.widthAnchor.constraint(equalToConstant: 58)
            cell.priceButton.layer.cornerRadius = 11
            cell.artworkImageView.layer.cornerRadius = 10
            updateImageSize(of: cell.artworkImageView, width: 69, height: 69)
            
            let author = item.artist ?? ""
            cell.creatorLabel.text = author
        
        // book and movie custom
        } else {
            cell.descriptionLabel.isHidden = false
            cell.descriptionLabel.isEnabled = true
            
            updateImageSize(of: cell.artworkImageView, width: 62, height: 80)
            cell.artworkImageView.layer.cornerRadius = 0
            
            let author = item.artist ?? ""
            let description = item.description ?? ""
            cell.creatorLabel.text = author
            cell.descriptionLabel.text = description
        }
        
        cell.artworkImageView.clipsToBounds = true
        cell.artworkImageView.image = UIImage(named: "gray")
        
        ItemController.fetchData(with: item.artwork) { (DLimage) in
            if let image = DLimage{
                DispatchQueue.main.async {
                    cell.artworkImageView.image = image
                }
            }
        }
    }
    
    func updateImageSize(of image: UIImageView, width: CGFloat, height: CGFloat) {
        var newFrame: CGRect = image.frame
        newFrame.size.height = height
        newFrame.size.width = width
        
        for contraint in image.constraints {
            if contraint.identifier == "imageWidthConstraint" {
                contraint.constant = width
            }
            if contraint.identifier == "imageHeightContraint" {
                contraint.constant = height
            }
        }
        
        image.frame = newFrame
    }
    
    @IBAction func filterOptionUpdated(_ sender: UISegmentedControl) {
        
        fetchMatchingItems()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return ituneItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension StoreItemListTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        fetchMatchingItems()
        searchBar.resignFirstResponder()
    }
}
