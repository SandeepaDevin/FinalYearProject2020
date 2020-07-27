package org.car2x.veins.subprojects.veins_inet.example;

import inet.physicallayer.ieee80211.packetlevel.Ieee80211ScalarRadioMedium;
import org.car2x.veins.subprojects.veins_inet.VeinsInetCar;
import org.car2x.veins.base.connectionManager.ConnectionManager;
import org.car2x.veins.base.modules.BaseWorldUtility;
import org.car2x.veins.modules.mobility.traci.TraCIScenarioManager*;
import org.car2x.veins.modules.obstacle.ObstacleControl;
import org.car2x.veins.modules.world.annotations.AnnotationManager;
import org.car2x.veins.nodes.Car;


network Scenario
{
    parameters:
        double playgroundSizeX @unit(m); // x size of the area the nodes are in (in meters)
        double playgroundSizeY @unit(m); // y size of the area the nodes are in (in meters)
        double playgroundSizeZ @unit(m); // z size of the area the nodes are in (in meters)
        @display("bgb=856,397");
    submodules:
        radioMedium: Ieee80211ScalarRadioMedium {
            @display("p=311,47");
        }
        connectionManager: ConnectionManager {
            @display("p=434,44");
        }
        obstacles: ObstacleControl {
            @display("p=129,38");
        }
        annotations: AnnotationManager {
            @display("p=216,38");
        }
        manager: TraCIScenarioManagerLaunchd {
            @display("p=42,38");
        }
        dsrc[0]: Dsrc {
            @display("p=531,44");
        }
        wifi[0]: VeinsInetCar {
            @display("p=51.6,117.174995");
        }
    connections allowunconnected:
}
