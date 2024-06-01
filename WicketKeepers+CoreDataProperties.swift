//
//  WicketKeepers+CoreDataProperties.swift
//  csk
//
//  Created by Arvind K on 03/04/24.
//
//

import Foundation
import CoreData


extension WicketKeepers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WicketKeepers> {
        return NSFetchRequest<WicketKeepers>(entityName: "WicketKeepers")
    }

    @NSManaged public var players: NSSet?

}

// MARK: Generated accessors for players
extension WicketKeepers {

    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: Player)

    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: Player)

    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: NSSet)

    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: NSSet)

}

extension WicketKeepers : Identifiable {

}
