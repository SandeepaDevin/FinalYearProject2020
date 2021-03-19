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

package org.car2x.veins.new;

import org.car2x.veins.base.modules.*;
import org.car2x.veins.modules.nic.Nic80211p;
import org.car2x.veins.new.IBaseApplLayernew;
import org.car2x.veins.new.DemoRSU;
import org.car2x.veins.new.Converter;

module RSUnew
{
    parameters:
        string convType = default("Converter");
        string applType = default("DemoRSU"); //type of the application layer
        string nicType = default("Nic80211p"); // type of network interface card
        @display("bgb=261,235");
    gates:
        input veinsradioIn; // gate for sendDirect
    submodules:
        conv: <convType> like org.car2x.veins.new.IConverter {
            parameters:
                @display("p=199,58");
        }
        appl: <applType> like org.car2x.veins.new.IBaseApplLayernew {
            parameters:
                @display("p=59,58");
        }

        nic: <nicType> like org.car2x.veins.modules.nic.INic80211p {
            parameters:
                @display("p=59,148");
        }

        mobility: BaseMobility {
            parameters:
                @display("p=160,172;i=block/cogwheel");
        }

    connections:
        nic.upperLayerOut --> appl.lowerLayerIn;
        nic.upperLayerIn <-- appl.lowerLayerOut;
        nic.upperControlOut --> appl.lowerControlIn;
        nic.upperControlIn <-- appl.lowerControlOut;

        appl.upperLayerOut --> conv.lowerLayerIn;
        veinsradioIn --> nic.radioIn;
}
