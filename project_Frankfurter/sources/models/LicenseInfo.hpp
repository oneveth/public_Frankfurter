//
//  LicenseInfo.hpp
//  project_Frankfurter
//
//  Created by Ivan Batrakov on 20/03/2026.
//  Copyright © 2026 on_eveth. All rights reserved.
//

#ifndef LicenseInfo_hpp
#define LicenseInfo_hpp
#include <iostream>
#include <stdio.h>
#include <vector>

struct MB_meta{
    std::string isrc;
    std::string status = "Unknown";
};

struct DC_meta{
    std::string label = "Enable Discogs search in the preferences.";
    std::string barcode = "Enable Discogs search in the preferences.";
};

//struct Info{
//    MB_meta MB_info;
//    DC_meta DC_info;
//};

struct Info{
    std::vector<MB_meta> MB_info;
    std::vector<DC_meta> DC_info;
};


#endif /* LicenseInfo_hpp */
