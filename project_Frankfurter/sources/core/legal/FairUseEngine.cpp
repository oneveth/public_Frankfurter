//
//  FairUseEngine.cpp
//  project_Frankfurter
//
//  Created by Ivan Batrakov on 13/03/2026.
//  Copyright © 2026 on_eveth. All rights reserved.
//

#include "FairUseEngine.hpp"

float FairUseEngine::calculateFairUseScore(FairUseInput input, UsageType type){
    float score = 50.0f;
    
    switch (type) {
        case VIDEO_ESSAY:
            
        case PODCAST:
            score += 20;
            break;
            
        case REACTION_VIDEO:
            score += 10;
            break;
            
        case COVER:
            score = input.isTransformative ? score + 15 : score - 30;
            break;
            
        case FILM:
        case LIVE_PERFORMANCE:
        case SAMPLING:
            score -= 40;
            break;
    }
    
    if (input.isTransformative) {
        score += 30;
        if (input.isCommercial) {
            score -= 5;
        }
    } else {
        if (input.isCommercial) {
            score -= 40;
        }
    }
    
    if (input.amount > 7) {
        score = input.isTransformative ? score - 10 : score - 40;
    } else {
        score += 10;
    }
    
    return std::clamp(score, 0.0f, 100.0f);
}
