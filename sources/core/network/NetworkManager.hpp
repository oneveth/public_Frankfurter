//
//  NetworkFetcher.hpp
//  project_Frankfurter
//
//  Created by Ivan Batrakov on 13/03/2026.
//  Copyright © 2026 on_eveth. All rights reserved.
//

#ifndef NetworkManager_hpp
#define NetworkManager_hpp

#include <stdio.h>
#include <string>
#include <chrono>

#pragma once

class NetworkManager{
public:
    // methods
    std::string recordingSearcher(const std::string &artist, const std::string &track);
    
    bool DiscogsTokenProvided = true;
    
    // const std::string DiscordToken;
    
private:
    // fields
    std::chrono::steady_clock::time_point timeOfTheLastRequest;
    
    // methods
    void requestLimiter();
    
    // void validateDiscordToken();
    
    std::string MB_queryBuilder(const std::string &artist, const std::string &track);
    // |
    // v
    std::string MB_URLBuilder(const std::string &query);
    std::string Discogs_URLBuilder(const std::string &artist, const std::string &track);
    // |
    // v
    // goes to bridge-file which deforms string and sends it to an API-server; as the response is got
    // it returns it to this class again
    // |
    // v
    std::string fin(const std::string &url);
};

#endif /* NetworkFetcher_hpp */
