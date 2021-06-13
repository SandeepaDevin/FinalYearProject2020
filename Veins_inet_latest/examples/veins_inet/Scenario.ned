//
// Copyright (C) 2006-2017 Christoph Sommer <sommer@ccs-labs.org>
//
// Documentation for these modules is at http://veins.car2x.org/
//
// SPDX-License-Identifier: GPL-2.0-or-later
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//

package org.car2x.veins.subprojects.veins_inet.examples.veins_inet;

import inet.physicallayer.ieee80211.packetlevel.Ieee80211ScalarRadioMedium;
import org.car2x.veins.subprojects.veins_inet.VeinsInetCar;
import org.car2x.veins.subprojects.veins_inet.WifiRSU;
import org.car2x.veins.subprojects.veins_inet.VeinsInetManager;
import org.car2x.veins.new.RSUnew;
import org.car2x.veins.nodes.Car;

import inet.environment.common.PhysicalEnvironment;
import org.car2x.veins.base.connectionManager.ConnectionManager;
import org.car2x.veins.base.modules.BaseWorldUtility;
import org.car2x.veins.modules.obstacle.ObstacleControl;
import org.car2x.veins.modules.world.annotations.AnnotationManager;

network Scenario
{
    parameters:
        double playgroundSizeX @unit(m); // x size of the area the nodes are in (in meters)
        double playgroundSizeY @unit(m); // y size of the area the nodes are in (in meters)
        double playgroundSizeZ @unit(m); // z size of the area the nodes are in (in meters)
        @display("bgb=386,425");
    submodules:
        obstacles: ObstacleControl {
            @display("p=240,50");
        }
        annotations: AnnotationManager {
            @display("p=260,50");
        }
        connectionManager: ConnectionManager {
            parameters:
                @display("p=133,27;i=abstract/multicast");
        }
        world: BaseWorldUtility {
            parameters:
                playgroundSizeX = playgroundSizeX;
                playgroundSizeY = playgroundSizeY;
                playgroundSizeZ = playgroundSizeZ;
                @display("p=27,42;i=misc/globe");
        }
        radioMedium: Ieee80211ScalarRadioMedium {
            @display("p=53,161");
        }
        manager: VeinsInetManager {
            @display("p=182,186");
        }

        physicalEnvironment: PhysicalEnvironment {
            @display("p=73,248");
        }

        wifi[0]: VeinsInetCar {
            @display("p=63,345");
        }
        dsrc[0]: Car {
            @display("p=133,332");
        }
        wifirsu: WifiRSU {
            @display("p=249,293");
        }
        dsrcrsu: RSUnew {
            @display("p=190,293;i=veins/node/car;is=s");
        }

    connections allowunconnected:
        dsrcrsu.rsuOut --> {  delay = 100ms; } --> wifirsu.DsrcIn;

}
