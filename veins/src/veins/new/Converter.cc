/*
 * Converter.cc
 *
 *  Created on: Mar 13, 2021
 *      Author: veins
 */

#include "veins/new/Converter.h"

using namespace veins;

Define_Module(veins::Converter);

void Converter::initialize(int stage)
{
    BaseApplLayer::initialize(stage);
    if (stage == 0) {
        headerLength = par("headerLength");
        receivedApps=0;
    }
}
Converter::~Converter()
{
    //cancelAndDelete(sendBeaconEvt);
    //cancelAndDelete(sendWSAEvt);
    //findHost()->unsubscribe(BaseMobility::mobilityStateChangedSignal, this);
}
void Converter::finish()
{
    recordScalar("received DSRC", receivedApps);
}

void Converter::handleLowerMsg(cMessage* msg)
{
    BaseFrame1609_4* wsm = dynamic_cast<BaseFrame1609_4*>(msg);
    ASSERT(wsm);

    if (DemoSafetyMessage* bsm = dynamic_cast<DemoSafetyMessage*>(wsm)) {
        receivedApps++;
        auto senderpos= bsm->getSenderPos();
        auto speed= bsm->getSenderSpeed();
        auto receiptAddress= bsm->getRecipientAddress();
        auto psid = bsm->getPsid();
        auto priority= bsm->getUserPriority();
        auto channelNumber= bsm->getChannelNumber();
    }

    delete(msg);
}
