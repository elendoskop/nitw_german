//
//  Asset.swift
//  NITW
//
//  Created by Alexey Averkin on 30.09.2023.
//

import Foundation

struct TextAsset: Codable {

    enum CodingKeys: String, CodingKey {
        case name = "m_Name"
        case script = "m_Script"
        case pathName = "m_PathName"
    }

    var name: String
    var script: String
    var pathName: String

}
