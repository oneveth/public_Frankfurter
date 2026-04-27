//
//  LicenseTypeDetermination.hpp
//  project_Frankfurter
//
//  Created by Ivan Batrakov on 22/04/2026.
//  Copyright © 2026 on_eveth. All rights reserved.
//

#ifndef LicenseTypeDetermination_hpp
#define LicenseTypeDetermination_hpp

#include <stdio.h>
#include <iostream>
#include <vector>
#include <string>

enum UsageType {
    REACTION_VIDEO,
    VIDEO_ESSAY,
    PODCAST,
    COVER,
    FILM,
    LIVE_PERFORMANCE,
    SAMPLING
};

struct LicenseOutput {
    std::vector<std::string> licenses;
};

enum class AcquisitionMethod {
    AUTOMATIC,
    COMPULSORY,
    NEGOTIATION,
    PRO_ADMIN
};

struct LicenseDetail {
    std::string name;
    AcquisitionMethod method;
    std::string description;
};

struct LicenseResult {
    std::vector<LicenseDetail> licenses;
};

LicenseResult determineRequiredLicenses(UsageType type);
LicenseResult determineRequiredLicenses_ru(UsageType type);

#endif /* LicenseTypeDetermination_hpp */
