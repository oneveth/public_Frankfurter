//
//  FairUseEngine.hpp
//  project_Frankfurter
//
//  Created by Ivan Batrakov on 13/03/2026.
//  Copyright © 2026 on_eveth. All rights reserved.
//

#ifndef FairUseEngine_hpp
#define FairUseEngine_hpp

#include <stdio.h>
#include "LicenseTypeDetermination.hpp"
#include "FairUseResult.hpp"

class FairUseEngine{
public:
    float calculateFairUseScore(FairUseInput input, UsageType type);
    
};

#endif /* FairUseEngine_hpp */
