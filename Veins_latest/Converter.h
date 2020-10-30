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


#pragma once
#include <omnetpp.h>
#include "veins/veins.h"

using namespace omnetpp;

namespace hybridcom {

#include "veins/base/modules/BatteryAccess.h"
#include "veins/base/utils/PassedMessage.h"
/**
 * Generates messages; see NED file for more info.
 */
class Converter : public cSimpleModule
{
    public:
        /** @brief SignalID for packets. */
        const static simsignal_t catPacketSignal;
        /** @brief Signal for passed messages.*/
        const static simsignal_t catPassedMsgSignal;
        /** @brief Signal for dropped packets.*/
        const static simsignal_t catDroppedPacketSignal;

    protected:
      veins::PassedMessage* passedMsg;
      int BSMin; int BeaconIn;


  public:
      Converter()
             :passedMsg(nullptr)
         {
         }
      ~Converter () override;
      /** @brief Initialization of the module and some variables*/
      void initialize(int) override;
      /** @brief Called every time a message arrives*/
      void handleMessage(cMessage*) override;
      /** @brief Called when the simulation has finished.*/
      void finish() override;

  protected:

     virtual void handleSelfMsg(cMessage* msg);/** @brief Handle self messages such as timer... */

     virtual void handleDsrcMsg(cMessage* msg);/** @brief Handle receiving dsrc messages from dsrc appl layer*/

     virtual void handleWifiMsg(cMessage* msg);/** @brief Handle receiving wifi messages from wifi mac layer*/

     void recordPacket(veins::PassedMessage::direction_t dir, veins::PassedMessage::gates_t gate, const cMessage* m);
};

}; // namespace
