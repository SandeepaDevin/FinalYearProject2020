/*
 * Converter.h
 *
 *  Created on: Mar 13, 2021
 *      Author: veins
 */

#pragma once

#include <map>

#include "veins/base/modules/BaseApplLayer.h"
#include "veins/modules/utility/Consts80211p.h"
#include "veins/modules/messages/BaseFrame1609_4_m.h"
#include "veins/modules/messages/DemoServiceAdvertisement_m.h"
#include "veins/modules/messages/DemoSafetyMessage_m.h"
#include "veins/base/connectionManager/ChannelAccess.h"
#include "veins/modules/mac/ieee80211p/DemoBaseApplLayerToMac1609_4Interface.h"
#include "veins/modules/mobility/traci/TraCIMobility.h"
#include "veins/modules/mobility/traci/TraCICommandInterface.h"
#include "veins/base/modules/BaseLayer.h"

namespace veins {

class VEINS_API Converter : public BaseApplLayer {

public:
    ~Converter() override;
    void initialize(int stage) override;
    void finish() override;

    //void receiveSignal(cComponent* source, simsignal_t signalID, cObject* obj, cObject* details) override;

protected:
    void handleLowerMsg(cMessage* msg) override;

protected:
    int headerLength;
    uint32_t receivedApps;
};

}
