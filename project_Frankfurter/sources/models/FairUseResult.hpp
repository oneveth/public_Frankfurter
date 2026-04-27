//
//  FairUseResult.hpp
//  project_Frankfurter
//
//  Created by Ivan Batrakov on 20/03/2026.
//  Copyright © 2026 on_eveth. All rights reserved.
//

#ifndef FairUseResult_hpp
#define FairUseResult_hpp

#include <stdio.h>
#include "LicenseTypeDetermination.hpp"

struct FairUseInput {
    
    int purpose;
    int amount;
    
    bool isParody;
    bool isTransformative;
    bool isCommercial;
    
};

#endif /* FairUseResult_hpp */
