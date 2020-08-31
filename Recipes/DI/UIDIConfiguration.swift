//
//  DataDIConfiguration.swift
//  Recipes
//
//  Created by Marcell Magyar on 2020. 09. 09..
//  Copyright © 2020. Marcell Magyar. All rights reserved.
//

import Swinject

struct UIDIConfiguration {
    public static var assemblies: [Assembly] {
        return [ScreenAssembly()]
    }
}
