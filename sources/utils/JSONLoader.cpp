//
//  JSONLoader.cpp
//  project_Frankfurter
//
//  Created by Ivan Batrakov on 20/03/2026.
//  Copyright © 2026 on_eveth. All rights reserved.
//

#include "JSONLoader.hpp"
#include "nlohmann/json.hpp"
#include "Track.hpp"
#include <locale>
#include <codecvt>
#include <algorithm>

using json = nlohmann::json;

void JSONLoader::JSON_sort(std::string &JSON, std::vector<TrackAndInfo>& InfoCollection) {
    
    auto normalize = [](const std::string& s) {
        std::string result;
        result.reserve(s.size());

        for (unsigned char c : s) {
            if (!(c == ' ' || c == '-' || c == '.' || c == ',')) {
                result.push_back(c);
            }
        }
        return result;
    };

    auto isMatch = [&](const std::string& artist,
                       const std::string& title,
                       const json& item) -> bool
    {
        std::string na = normalize(artist);
        std::string nt = normalize(title);

        // artist match
        std::string fullTitle = normalize(item.value("title", ""));
        bool artistOk = fullTitle.find(na) != std::string::npos;

        // tracklist match
        if (item.contains("tracklist") && item["tracklist"].is_array()) {
            for (auto& t : item["tracklist"]) {
                std::string tTitle = normalize(t.value("title", ""));
                if (tTitle == nt || tTitle.find(nt) != std::string::npos) {
                    return true;
                }
            }
        }
        return artistOk;
    };

    auto getFirstString = [](const json& j, const std::string& key) {
        if (j.contains(key)) {
            if (j[key].is_string()) return j[key].get<std::string>();
            if (j[key].is_array() && !j[key].empty() && j[key][0].is_string())
                return j[key][0].get<std::string>();
        }
        return std::string("");
    };
    
    auto buildFullTitle = [](const json& rec) -> std::string {
        std::string title = rec.value("title", "");

        std::string dis = rec.value("disambiguation", "");
        if (!dis.empty()) {
            title += "\n[" + dis + "]";
        }

        if (dis.empty() && rec.contains("releases") && rec["releases"].is_array()) {
            auto& rel = rec["releases"][0];
            if (rel.contains("title")) {
                title += "\n[" + rel["title"].get<std::string>() + "]";
            }
        }
        return title;
    };



    if (JSON.empty()) return;
    json root;
    try {
        root = json::parse(JSON);
    } catch (...) { return; }

    bool hasMB = root.contains("musicbrainz") && root["musicbrainz"].is_object() &&
                 root["musicbrainz"].contains("recordings") && root["musicbrainz"]["recordings"].is_array();
    
    bool hasDC = root.contains("discogs") && root["discogs"].is_object() &&
                 (root["discogs"].contains("results") || root["discogs"].contains("releases"));

    if (hasMB && hasDC) {
        json dc = root.contains("discogs") ? root["discogs"] : json();
        if (!root.contains("musicbrainz") || !root["musicbrainz"].contains("recordings")) return;

        for (auto& rec : root["musicbrainz"]["recordings"]) {
            TrackAndInfo track_info;

            // title / artist
            track_info.track.track = buildFullTitle(rec);
            if (rec.contains("artist-credit") && rec["artist-credit"].is_array()) {
                std::string artists;
                for (auto& a : rec["artist-credit"]) {
                    std::string name = a.contains("artist") ? a["artist"].value("name", "") : "";
                    if (!artists.empty()) artists += ", ";
                    artists += name;
                }
                track_info.track.artist = artists;
            }

            // ISRC
            if (rec.contains("isrcs") && rec["isrcs"].is_array()) {
                for (auto& isrc : rec["isrcs"]) {
                    track_info.info.MB_info.push_back({isrc.get<std::string>(), rec.value("status", "Official")});
                }
            }

            // matching
            if (!dc.is_null() && dc.contains("results")) {
            // std::cout << "Discogs results count: " << dc["results"].size() << std::endl;
            for (auto& item : dc["results"]) {
                std::string dcTitle = item.value("title", "");
                
                    if (isMatch(track_info.track.artist, track_info.track.track, item)) {
                        DC_meta dc_meta;
                        dc_meta.label = getFirstString(item, "label");
                        dc_meta.barcode = getFirstString(item, "barcode");
                        track_info.info.DC_info.push_back(dc_meta);
                    }
                }
            }

            if (!track_info.track.track.empty()) {
                InfoCollection.push_back(track_info);
            }
        }
    }
    else if (hasMB) {
        
        for (auto& rec : root["musicbrainz"]["recordings"]) {
            TrackAndInfo track_info;
            track_info.track.track = buildFullTitle(rec).insert(0, "(MusicBrainz-only mode):\n\n");
            if (rec.contains("isrcs") && rec["isrcs"].is_array()) {
                for (auto& isrc : rec["isrcs"]) {
                    track_info.info.MB_info.push_back({isrc.get<std::string>(), rec.value("status", "Official")});
                }
            }
            InfoCollection.push_back(track_info);
        }
    }
    else if (hasDC) {
        
        auto& dc_data = root["discogs"].contains("results") ? root["discogs"]["results"] : root["discogs"]["releases"];
        
        for (auto& item : dc_data) {
            TrackAndInfo track_info;
            
            track_info.track.track = item.value("title", "Unknown").insert(0, "(Discogs-only mode, Artist / Album):\n\n");
            
            DC_meta dc_meta;
            dc_meta.label = getFirstString(item, "label");
            dc_meta.barcode = getFirstString(item, "barcode");
            track_info.info.DC_info.push_back(dc_meta);

            if (!track_info.track.track.empty()) {
                InfoCollection.push_back(track_info);
            }
        }
    }
}
