//
//  CharacterDetailModel.swift
//  Marvel
//
//  Created by Diego Rogel on 14/3/22.
//

import Foundation

struct CharacterDetailModel: Hashable {
    let info: CharacterInfoModel?
    let comics: [ComicCellModel]
}
