//
//  Workspace.swift
//  Mapper
//
//  Created by Никишин Ибрахим on 7/23/20.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

public struct Workspace: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, data
    }

    public let id: String
    public let type: WorkspaceType
    public let mcc: Mcc?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(WorkspaceType.self, forKey: .data)
        mcc = nil
    }
    
    init(id: String, type: WorkspaceType, mcc: Mcc? = nil) {
        self.id = id
        self.type = type
        self.mcc = mcc
    }
    
    var isIndividual: Bool {
        if case .individual = type {
            return true
        }
        return false
    }
}

public enum WorkspaceType: Decodable {
    enum CodingKeys: String, CodingKey {
        case type, name, bin, active, role
    }
    
    private enum StringType: String, Decodable {
        case individual = "INDIVIDUAL"
        case entrepreneur = "ENTREPRENEUR"
        case legal = "LEGAL"
    }
    
    case individual
    case entrepreneur(data: WorkspaceEntrepreneurData)
    case legal(data: WorkspaceLegalData)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let type = try container.decode(StringType.self, forKey: .type)
        switch type {
        case .individual:
            self = .individual
        case .entrepreneur:
            let name = try container.decode(String.self, forKey: .name)
            let data = WorkspaceEntrepreneurData(name: name)
            self = .entrepreneur(data: data)
        case .legal:
            let name = try container.decode(String.self, forKey: .name)
            let bin = try container.decode(String.self, forKey: .bin)
            let active = try container.decode(Bool.self, forKey: .active)
            let role = try container.decodeIfPresent(String.self, forKey: .role)
            let data = WorkspaceLegalData(name: name,
                                          bin: bin,
                                          active: active,
                                          role: role)
            self = .legal(data: data)
        }
    }
}

public struct WorkspaceEntrepreneurData {
    let name: String
}

public struct WorkspaceLegalData {
    let name: String
    let bin: String
    let active: Bool
    let role: String?
    
    var isActive: Bool {
        return active
    }
}

public struct Mcc : Decodable {
    public let name: String
    public let code: String
    public let category: String
    
    var fullTitle: String {
        return "\(code) \(name) \(category)"
    }
}
