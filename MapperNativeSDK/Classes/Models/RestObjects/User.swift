import Foundation
import UIKit

public struct User: Decodable {
    enum CodingKeys: String, CodingKey {
        case phone, firstName, lastName, iin, workspaces
    }
    
    public let phone: String
    public let firstName: String
    public let lastName: String
    public let iin: String
    public let workspaces: [Workspace]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        phone = try container.decode(String.self, forKey: .phone)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        iin = try container.decode(String.self, forKey: .iin)
        let workspaces = try container.decode([Workspace].self, forKey: .workspaces)
        var sortedWorkspaces = [Workspace]()
        workspaces.forEach { workspace in
            if case .individual = workspace.type {
                sortedWorkspaces.insert(workspace, at: 0)
            } else {
                sortedWorkspaces.append(workspace)
            }
        }
        self.workspaces = sortedWorkspaces
    }
    
    var fullname: String {
        return "\(firstName) \(lastName)"
    }
    
    func getName(for workspace: Workspace) -> String {
        switch workspace.type {
        case .individual:
            return fullname
        case let .entrepreneur(data):
            return "ИП \"\(data.name)\""
        case let .legal(data):
            return "ТОО \"\(data.name)\""
        }
    }
    
    func getWorkspace(with workspaceId: String) -> Workspace? {
        return workspaces.first(where: { $0.id == workspaceId }) ?? workspaces.first
    }
}

public struct UserResult: Decodable {
    public let fullName: String
    public let defaultOrganization: Bank?
}
