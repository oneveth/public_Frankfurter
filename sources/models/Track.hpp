//
//  Track.hpp
//  project_Frankfurter
//
//  Created by Ivan Batrakov on 20/03/2026.
//  Copyright © 2026 on_eveth. All rights reserved.
//

#ifndef Track_hpp
#define Track_hpp

#include <stdio.h>
#include <iostream>
#include <vector>
#include "LicenseInfo.hpp"

struct Track{
    std::string artist;
    std::string track;
};

struct TrackAndInfo{
    Track track;
    Info info;
};

// std::vector<TrackAndInfo> InfoCollection;

#endif /* Track_hpp */
