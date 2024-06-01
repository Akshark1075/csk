//
//  TeamTableViewController.swift
//  csk
//
//  Created by Arvind K on 18/02/24.
//

import UIKit
import CoreData
class TeamTableViewController: UITableViewController, NSFetchedResultsControllerDelegate  {
    let cellName = "PlayerListCell"
    let cellReuseIdentifier = "playerCell"
    var userManagedObject:User!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pEntity : NSEntityDescription!
    var pManagedObject :TeamPlayer!
    let entityNames = ["WicketKeepers", "Batsmen", "Bowlers", "Allrounders", "Substitutes"]
    var frcs: [NSFetchedResultsController<TeamPlayer>] = []
    @IBOutlet weak var toggleFavouritesButton: UIBarButtonItem!
    var isFavouritesView=false
    @IBAction func toggleFavouritesView(_ sender: UIBarButtonItem) {
        if(!isFavouritesView){
            
            isFavouritesView=true
            toggleFavouritesButton.image=UIImage(systemName: "heart.fill")
   
            navigationController!.navigationBar.topItem?.title="Playing XI"
            tableView.reloadData()
        }
        else{
            isFavouritesView=false
            toggleFavouritesButton.image=UIImage(systemName: "heart")
            navigationController!.navigationBar.topItem?.title="Pick Your XI"
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userManagedObject = (self.tabBarController as! TabBarController).userManagedObject
        /**Fetching Player data **/
        for entityName in entityNames {
            
            let frc = NSFetchedResultsController(fetchRequest: (makeRequestForTeamPlayers(entityName: entityName)) , managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            frc.delegate = self
            frcs.append(frc)
            
            do {
                try frc.performFetch()
                
            } catch {
                print("Error fetching \(entityName): \(error)")
            }
        }
        //If all sections are empty, fetch data from xml
        if  frcs[0].sections!.allSatisfy({ $0.numberOfObjects==0 }) {
            xml2CD()
        }
        
        
        /**Table View**/
        tableView.dataSource=self
        tableView.delegate=self
        tableView.sectionHeaderTopPadding = 15
        tableView.sectionHeaderHeight=35
        tableView.sectionFooterHeight=0
        self.tableView.isEditing = true
        tableView.allowsSelectionDuringEditing=true
        /**Navigation Bar**/
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        /**Sheet Alert**/
        let alertController = UIAlertController(title: "Pick Your XI", message: "Your Playing XI should consist of:\nMinimum of 1 Wicket Keeper\n Minimum of 3 batsmen\nMinimum of 4 bowlers\nMinimum of 1 allrounder\nMaximum of 4 Overseas players\nMinimum of 1 uncapped player", preferredStyle: .actionSheet)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
    /**Fetch Team players and categorize them **/
    func makeRequestForTeamPlayers(entityName: String) -> NSFetchRequest<TeamPlayer> {
        let request: NSFetchRequest<TeamPlayer> = TeamPlayer.fetchRequest()
       
            var rolePredicate: NSPredicate?
        switch entityName {
        case "WicketKeepers":
            rolePredicate = NSPredicate(format: "role == %@ AND isSubstitute == false","Wicket Keeper / Batsman")
            
        case "Batsmen":
            
            rolePredicate = NSPredicate(format: "role == %@ AND isSubstitute == false", "Batsman")
            
        case "Bowlers":
            
            rolePredicate = NSPredicate(format:"role == %@ AND isSubstitute == false", "Bowler")
            
        case "Allrounders":
            
            rolePredicate = NSPredicate(format: "role == %@ AND isSubstitute == false", "Allrounder")
            
        case "Substitutes":
            rolePredicate = NSPredicate(format: "isSubstitute == true")
        default:
            rolePredicate=nil
        }
        if let team = userManagedObject?.team{
        let teamPredicate = NSPredicate(format: "team == %@", team)
               request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [teamPredicate, rolePredicate!])
           } else {
               request.predicate = rolePredicate
           }
        request.sortDescriptors = [NSSortDescriptor(key: "player.name", ascending: true)]
        
        return request
    }
    
    /**Fetching data from xml, creating player entity and creating a clone of player entity **/
    func xml2CD() {
        let parser = XMLPlayersParser(xmlName: "players.xml")
        parser.parsing()
        
        for entityName in entityNames {
            // Fetch corresponding data from the parser based on the entity name
            var data: [PlayerModel] = []
            switch entityName {
            case "WicketKeepers":
                data = parser.wicketKeepers
            case "Batsmen":
                data = parser.batsmen
            case "Bowlers":
                data = parser.bowlers
            case "Allrounders":
                data = parser.allrounders
            case "Substitutes":
                data = parser.substitutes
            default:
                break
            }
            
            for player in data {
                let entity = NSEntityDescription.entity(forEntityName: "Player", in: context)!
                let playerObject = Player(entity: entity, insertInto: context)
                playerObject.name = player.name
                playerObject.role = player.role
                playerObject.image = player.image
                playerObject.born = player.born
                playerObject.battingStyle = player.battingStyle
                playerObject.bowlingStyle = player.bowlingStyle
                playerObject.about = player.about
                playerObject.url = player.url
                playerObject.isSubstitute = false
              
                addTeamPlayer(for: playerObject, toNewCategory: entityName)
                do {
                    try context.save()
                } catch {
                    print("Core data cannot save")
                }
            }
        }
    }
    /**Creating a copy of player entity so that the role could be modified**/
    func addTeamPlayer(for player: Player, toNewCategory newCategory: String) {
        guard let team = userManagedObject.team else {
            print("Error: The user does not have an associated team.")
            return
        }

        let teamPlayer = TeamPlayer(context: context)
        teamPlayer.player = player
        teamPlayer.team = team
        switch newCategory {
        case "WicketKeepers":
            teamPlayer.role = "Wicket Keeper / Batsman"
            teamPlayer.isSubstitute = false
        case "Batsmen":
            teamPlayer.role = "Batsman"
            teamPlayer.isSubstitute = false
        case "Bowlers":
            teamPlayer.role = "Bowler"
            teamPlayer.isSubstitute = false
        case "Allrounders":
            teamPlayer.role = "Allrounder"
            teamPlayer.isSubstitute = false
        case "Substitutes":
            teamPlayer.isSubstitute = true
        default:
            print("Unexpected category: \(newCategory)")
            return
        }
        
        do {
            try context.save()
            print("Successfully added  TeamPlayer.")
        } catch {
            print("Could not save team player changes: \(error)")
        }
    }

    /**Reload tableview if data changes **/
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    /**Tableview datasource and  delegate methods**/
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if(isFavouritesView){
            return frcs.count-1
        }
        return  frcs.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = frcs[section].sections else {
            return 0
        }
        return sections[0].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Wicket Keepers"
        case 1:
            return "Batsmen"
        case 2:
            return "Bowlers"
        case 3:
            return "All Rounders"
        case 4:
            return "Substitutes"
        default:
            return "Unknown"
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerCell
        cell.prepareForReuse()
        let frc = frcs[indexPath.section]
        //Display fetched player
        let teamPlayer = frc.object(at:IndexPath(row: indexPath.row, section: 0)) as?  TeamPlayer
        let target = teamPlayer!.player
        let img = UIImage(named: target!.image!)
        // Adjust sizes for smaller screen
        let screenSize = UIScreen.main.bounds.size
        let isSmallerScreen = screenSize.height <= 700
        cell.viewProfile?.font = isSmallerScreen ? UIFont.systemFont(ofSize: 16.0, weight: .black) : UIFont.systemFont(ofSize: 18.0, weight: .black)
        cell.playerImage?.image = img
        cell.playerName.text=target?.name
        cell.playerRole.text=target?.role
        return cell
    }
    /**Table view Layout methods**/
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView=view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor=UIColor.white
        headerView.textLabel?.font=UIFont.boldSystemFont(ofSize: 22)
    }
    
    /**Tableview actions**/
    //Segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "profileSegue", sender: nil)
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="profileSegue"){
            let destination=segue.destination as! ProfileViewController
            let indexPath=tableView.indexPathForSelectedRow!
            let frc = frcs[indexPath.section]
            pManagedObject=frc.object(at:IndexPath(row: indexPath.row, section: 0)) as? TeamPlayer
            
            destination.player=pManagedObject.player
        }
    }
    //Rearrange table rows
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if(isFavouritesView){
            return false
        }
        return true
    }
    
    /**Modifying the role of the player to display him under different category**/
    func updateTeamPlayer(player: TeamPlayer, toNewCategory newCategory: String) {
        let team: Team = userManagedObject.team!
       
        let fetchRequest: NSFetchRequest<TeamPlayer> = TeamPlayer.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "player == %@ AND team == %@", player, team)
        var teamPlayer: TeamPlayer?
        if let existingTeamPlayer = (try? context.fetch(fetchRequest))?.first {
                   teamPlayer = existingTeamPlayer
               }
        switch newCategory {
        case "WicketKeepers":
            teamPlayer?.role = "Wicket Keeper / Batsman"
            teamPlayer?.isSubstitute = false
        case "Batsmen":
            teamPlayer?.role = "Batsman"
            teamPlayer?.isSubstitute = false
        case "Bowlers":
            teamPlayer?.role = "Bowler"
            teamPlayer?.isSubstitute = false
        case "Allrounders":
            teamPlayer?.role = "Allrounder"
            teamPlayer?.isSubstitute = false
        case "Substitutes":
            teamPlayer?.isSubstitute = true
        default:
            print("Unexpected category: \(newCategory)")
            return
        }
        
        do {
            try context.save()
            print("Successfully  updated TeamPlayer.")
        } catch {
            print("Could not save team player changes: \(error)")
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceFrc = frcs[sourceIndexPath.section]

        let movedPlayer=(sourceFrc.object(at:IndexPath(row: sourceIndexPath.row, section: 0)) as? TeamPlayer)!
   
        let sourceEntityName = entityNames[sourceIndexPath.section]
            let destinationEntityName = entityNames[destinationIndexPath.section]
    

        updateTeamPlayer(player: movedPlayer,  toNewCategory: destinationEntityName)
    }

    

}

