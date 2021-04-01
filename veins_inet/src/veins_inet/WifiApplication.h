#pragma once

#include "veins_inet/veins_inet.h"
#include "veins_inet/VeinsInetApplicationBasenew.h"

class VEINS_INET_API WifiApplication : public veins::VeinsInetApplicationBasenew {
protected:
    bool haveForwarded = false;

protected:
    virtual bool startApplication() override;
    virtual bool stopApplication() override;
    virtual void processPacket(std::shared_ptr<inet::Packet> pk) override;

public:
    WifiApplication();
    ~WifiApplication();
};
