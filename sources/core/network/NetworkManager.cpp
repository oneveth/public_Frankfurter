//
//  NetworkFetcher.cpp
//  project_Frankfurter
//
//  Created by Ivan Batrakov on 13/03/2026.
//  Copyright © 2026 on_eveth. All rights reserved.
//

#include "NetworkManager.hpp"
#include <iostream>
#include "MainBridge.h"
#include <thread>

std::string NetworkManager::recordingSearcher(const std::string &artist, const std::string &track){
    std::string MBquery = MB_queryBuilder(artist, track);
    std::string MBurl = MB_URLBuilder(MBquery);
    
    if (DiscogsTokenProvided){
        std::string DiscogsURL = Discogs_URLBuilder(artist, track);
        requestLimiter();
        
        return MainBridge::respondGetter(MBurl, DiscogsURL);
    }
    
    requestLimiter();
    
    return MainBridge::MBrespondGetter(MBurl);
}

std::string NetworkManager::MB_queryBuilder(const std::string &artist,const std::string &track){
    return "recording:\"" + track +
           "\" AND artist:\"" + artist + "\"";
}

std::string NetworkManager::MB_URLBuilder(const std::string &query){
    std::string base = "https://musicbrainz.org/ws/2/recording";

    return base + "?query=" + query + "&fmt=json&limit=10";
}

std::string NetworkManager::Discogs_URLBuilder(const std::string &artist, const std::string &track){
    std::string base = "https://api.discogs.com/database/search";

    std::string query = "artist=" + artist +
                        "&track=" + track +
                        "&type=release";

    return base + "?" + query;
}

std::string NetworkManager::fin(const std::string &url)
{
    return MainBridge::MBrespondGetter(url);
}



void NetworkManager::requestLimiter(){
    auto now = std::chrono::steady_clock::now();
    
    auto passed = std::chrono::duration_cast<std::chrono::milliseconds>(
    now - timeOfTheLastRequest);
    
    if (passed.count() < 1000){
        std::this_thread::sleep_for(
        std::chrono::milliseconds(1000 - passed.count()));
    }
    
    timeOfTheLastRequest = std::chrono::steady_clock::now();
}


