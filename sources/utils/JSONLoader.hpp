//
//  JSONLoader.hpp
//  project_Frankfurter
//
//  Created by Ivan Batrakov on 20/03/2026.
//  Copyright © 2026 on_eveth. All rights reserved.
//

#ifndef JSONLoader_hpp
#define JSONLoader_hpp

#include <stdio.h>
#include "iostream"
#include "nlohmann/json.hpp"
#include <vector>
#include "Track.hpp"

class JSONLoader{
public:
    void JSON_sort(std::string &JSON, std::vector<TrackAndInfo>& InfoCollection);
    
private:
};

#endif /* JSONLoader_hpp */
