//
//  DataDIConfiguration.swift
//  Recipes
//
//  Created by Marcell Magyar on 2020. 09. 09..
//  Copyright © 2020. Marcell Magyar. All rights reserved.
//

import Swinject

struct DataDIConfiguration {
    public static var assemblies: [Assembly] {
        #if MOCK
            return [MockDataAssembly()]
        #else
            return [DataAssembly(),
                    CommonAssembly()]
        #endif
    }
}
