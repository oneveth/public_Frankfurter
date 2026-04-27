//
//  LicenseTypeDetermination.cpp
//  project_Frankfurter
//
//  Created by Ivan Batrakov on 22/04/2026.
//  Copyright © 2026 on_eveth. All rights reserved.
//

#include "LicenseTypeDetermination.hpp"

LicenseResult determineRequiredLicenses(UsageType type) {
    LicenseResult result;

    switch (type) {
        case COVER:
            result.licenses.push_back({"Mechanical license", AcquisitionMethod::COMPULSORY,
                "Can be obtained automatically through DistroKid/HFA at a fixed rate."}); // "Можно получить автоматически через DistroKid/HFA по фиксированной ставке."
            result.licenses.push_back({"Synchronization license", AcquisitionMethod::NEGOTIATION,
                "YouTube video-covers formally demand negotiations."}); // "Для видео-каверов на YouTube формально требуются переговоры."
            break;
            
        case SAMPLING:
            result.licenses.push_back({"Master use license", AcquisitionMethod::NEGOTIATION,
                "Record-owner's (label's) permission is required."}); // "Требуется разрешение владельца записи (лейбла)."
            result.licenses.push_back({"Mechanical license (sampling)", AcquisitionMethod::NEGOTIATION,
                "Fixed rate for sampling is irrelevant, negotiations are required."}); // "Для сэмплов стандартная ставка не действует, нужны переговоры."
            break;

        case FILM:
            result.licenses.push_back({"Synchronization license", AcquisitionMethod::NEGOTIATION,
                "Syncing music with video always requires a direct contract."}); // "Синхронизация музыки с видео всегда требует прямого контракта."
            result.licenses.push_back({"Master use license", AcquisitionMethod::NEGOTIATION,
                "Permission to use the original track in the movie."}); // "Разрешение на использование оригинального трека в фильме."
            break;

        case LIVE_PERFORMANCE:
            result.licenses.push_back({"Public performance license", AcquisitionMethod::PRO_ADMIN,
                "It is usually paid for by the provider of the platform through PRO (BMI, ASCAP, RAO)."}); // "Обычно оплачивается площадкой через PRO (BMI, ASCAP, РАО)."
            break;

        case PODCAST:
        case REACTION_VIDEO:
        case VIDEO_ESSAY:
            result.licenses.push_back({"Synchronization license", AcquisitionMethod::NEGOTIATION,
                "If Fair use is not approved, direct negotiations are required."}); // "Если Fair use не подтвержден, нужны прямые переговоры."
            break;
    }

    return result;
}

LicenseResult determineRequiredLicenses_ru(UsageType type) {
    LicenseResult result;

    switch (type) {
        case COVER:
            result.licenses.push_back({"Mechanical license", AcquisitionMethod::COMPULSORY,
                "Можно получить автоматически через DistroKid/HFA по фиксированной ставке."});
            result.licenses.push_back({"Synchronization license", AcquisitionMethod::NEGOTIATION,
                "Для видео-каверов на YouTube формально требуются переговоры."});
            break;
            
        case SAMPLING:
            result.licenses.push_back({"Master use license", AcquisitionMethod::NEGOTIATION,
                "Требуется разрешение владельца записи (лейбла)."});
            result.licenses.push_back({"Mechanical license (sampling)", AcquisitionMethod::NEGOTIATION,
                "Для сэмплов стандартная ставка не действует, нужны переговоры."});
            break;

        case FILM:
            result.licenses.push_back({"Synchronization license", AcquisitionMethod::NEGOTIATION,
                "Синхронизация музыки с видео всегда требует прямого контракта."});
            result.licenses.push_back({"Master use license", AcquisitionMethod::NEGOTIATION,
                "Разрешение на использование оригинального трека в фильме."});
            break;

        case LIVE_PERFORMANCE:
            result.licenses.push_back({"Public performance license", AcquisitionMethod::PRO_ADMIN,
                "Обычно оплачивается площадкой выступления через PRO (BMI, ASCAP, РАО)."});
            break;

        case PODCAST:
        case REACTION_VIDEO:
        case VIDEO_ESSAY:
            result.licenses.push_back({"Synchronization license", AcquisitionMethod::NEGOTIATION,
                "Если Fair use не подтвержден, нужны прямые переговоры."});
            break;
    }

    return result;
}
