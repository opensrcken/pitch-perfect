//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Ken Hahn on 3/29/15.
//  Copyright (c) 2015 Ken Hahn. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}