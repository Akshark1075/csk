//
//  Team+CoreDataProperties.swift
//  csk
//
//  Created by Arvind K on 03/04/24.
//
//

import Foundation
import CoreData


extension Team {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Team> {
        return NSFetchRequest<Team>(entityName: "Team")
    }

    @NSManaged public var players: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for players
extension Team {

    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: TeamPlayer)

    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: TeamPlayer)

    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: NSSet)

    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: NSSet)

}

extension Team : Identifiable {

}
