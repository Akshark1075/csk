////
////  xmlPlayersParser.swift
////  CSK
////
////  Created by Arvind K on 23/02/24.
////
//
import Foundation


class XMLPlayersParser: NSObject, XMLParserDelegate {
    var xmlName: String
    
    init(xmlName: String) {
        self.xmlName = xmlName
    }
    
    // Parsed variable definitions
    var name, role, image, born, battingStyle, bowlingStyle, about, url: String!
    var currentCategory: String?
    let tags = ["name", "role", "image", "born", "battingStyle", "bowlingStyle", "about", "url"]
    
    // Variables for spying
    var elementId = -1
    var passData = false
    var playerData: PlayerModel!
    var wicketKeepers = [PlayerModel]()
    var batsmen = [PlayerModel]()
    var bowlers = [PlayerModel]()
    var allrounders = [PlayerModel]()
    var substitutes=[PlayerModel]()
    // Parser Object
    var parser: XMLParser!
    
    // MARK: - Parsing methods
    
    // didStartElement
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        if tags.contains(elementName) {
            // Spying
            passData = true  // Check which tag to spy
            switch elementName {
            case "name":
                elementId = 0
            case "role":
                elementId = 1
            case "image":
                elementId = 2
            case "born":
                elementId = 3
            case "battingStyle":
                elementId = 4
            case "bowlingStyle":
                elementId = 5
            case "about":
                elementId = 6
            case "url":
                elementId = 7
            default:
                break
            }
        } else if elementName == "player" {
            currentCategory = elementName
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if tags.contains(elementName) {
            passData = false
            elementId = -1
        }
       
        if elementName == "player" {
            playerData = PlayerModel(name: name, role: role, image: image, born: born, battingStyle: battingStyle, bowlingStyle: bowlingStyle, about: about, url: url)
         
            appendPlayerToCategory()
            
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if passData {
            switch elementId {
            case 0:
                name = string
            case 1:
                role = string
            case 2:
                image = string
            case 3:
                born = string
            case 4:
                battingStyle = string
            case 5:
                bowlingStyle = string
            case 6:
                about = string
            case 7:
                url = string
            default:
                break
            }
        }
    }

    func appendPlayerToCategory() {
        guard let currentCategory = currentCategory else {
            return
        }
     
        switch currentCategory {
        case "player":
            // Check the player's role and assign to the corresponding category
            switch playerData.role {
            case "Wicket Keeper / Batsman":
                wicketKeepers.append(playerData!)
            case "Batsman":
                batsmen.append(playerData!)
            case "Bowler":
                bowlers.append(playerData!)
            case "Allrounder":
                allrounders.append(playerData!)
            case "Substitute":
                substitutes.append(playerData!)
            default:
                break
            }
        default:
            break
        }
        
        // Reset currentCategory after appending
        self.currentCategory = nil
    }
    func parsing() {
        let bundle = Bundle.main.bundleURL
        let bundleURL = NSURL(fileURLWithPath: self.xmlName, relativeTo: bundle)
        parser = XMLParser(contentsOf: bundleURL as URL)
        parser.delegate = self
        parser.parse()
    }
}
