//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

#include "Converter.h"

namespace hybridcom {

const simsignal_t Converter::catPassedMsgSignal = registerSignal("org_car2x_veins_base_utils_passedmsg");
const simsignal_t Converter::catPacketSignal = registerSignal("org_car2x_veins_modules_utility_packet");
const simsignal_t Converter::catDroppedPacketSignal = registerSignal("org_car2x_veins_modules_utility_droppedpacket");

Define_Module(hybridcom::Converter);

void Converter::initialize(int stage)
{
    if (stage == 0) {
        passedMsg = nullptr;
        if (hasPar("stats") && par("stats").boolValue()) {
            passedMsg = new veins::PassedMessage();
            if (passedMsg != nullptr) {
                passedMsg->fromModule = getId();
            }
        }
        BSMin = findGate("BSMin");
        BeaconIn = findGate("BeaconIn");
    }
}

void Converter::handleMessage(cMessage* msg)
{
    if (msg->isSelfMessage()) {
            handleSelfMsg(msg);
        }
    else if (msg->getArrivalGateId() == BSMin) {
            recordPacket(veins::PassedMessage::INCOMING, veins::PassedMessage::UPPER_DATA, msg);
            handleDsrcMsg(msg);
        }
    else if (msg->getArrivalGateId() == BeaconIn){
            recordPacket(veins::PassedMessage::INCOMING, veins::PassedMessage::LOWER_DATA, msg);
            handleWifiMsg(msg);
    }
    else if (msg->getArrivalGateId() == -1) {
            throw cRuntimeError("No self message and no gateID?? Check configuration.");
        }
    else {
            throw cRuntimeError("Unknown gateID?? Check configuration or override handleMessage().");
        }
}
void Converter::handleDsrcMsg(cMessage* msg)
{
    cPacket* m = msg->decapsulate();
}

void Converter::handleselfMsg(cMessage* msg)
{
    ASSERT(dynamic_cast<cPacket*>(msg));
    sendDown(encapsMsg(static_cast<cPacket*>(msg)));
}
void Converter::recordPacket(veins::PassedMessage::direction_t dir, veins::PassedMessage::gates_t gate, const cMessage* msg)
{
    if (passedMsg == nullptr) return;
    passedMsg->direction = dir;
    passedMsg->gateType = gate;
    passedMsg->kind = msg->getKind();
    passedMsg->name = msg->getName();
    emit(catPassedMsgSignal, passedMsg);
}
void Converter::finish()
{
}

Converter::~Converter()
{
    if (passedMsg != nullptr) {
        delete passedMsg;
    }
}

}; // namespace
