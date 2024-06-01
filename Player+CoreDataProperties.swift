//
//  Player+CoreDataProperties.swift
//  csk
//
//  Created by Arvind K on 03/04/24.
//
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }

    @NSManaged public var about: String?
    @NSManaged public var battingStyle: String?
    @NSManaged public var born: String?
    @NSManaged public var bowlingStyle: String?
    @NSManaged public var image: String?
    @NSManaged public var isSubstitute: Bool
    @NSManaged public var name: String?
    @NSManaged public var role: String?
    @NSManaged public var url: String?
    @NSManaged public var teamPlayer: NSSet?

}

// MARK: Generated accessors for teamPlayer
extension Player {

    @objc(addTeamPlayerObject:)
    @NSManaged public func addToTeamPlayer(_ value: TeamPlayer)

    @objc(removeTeamPlayerObject:)
    @NSManaged public func removeFromTeamPlayer(_ value: TeamPlayer)

    @objc(addTeamPlayer:)
    @NSManaged public func addToTeamPlayer(_ values: NSSet)

    @objc(removeTeamPlayer:)
    @NSManaged public func removeFromTeamPlayer(_ values: NSSet)

}

extension Player : Identifiable {

}
