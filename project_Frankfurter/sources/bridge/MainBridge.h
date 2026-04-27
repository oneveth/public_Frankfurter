//
//  MainBridge.h
//  project_Frankfurter
//
//  Created by Ivan Batrakov on 13/03/2026.
//  Copyright © 2026 on_eveth. All rights reserved.
//

#ifndef MainBridge_h
#define MainBridge_h

#include "iostream"
#include <string>

#pragma once

class MainBridge {
public:
    static std::string MBrespondGetter(const std::string &url);
    
    static std::string respondGetter(const std::string &MBurl, const std::string &DCurl);
};

#endif /* MainBridge_h */
