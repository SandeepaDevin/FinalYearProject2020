package org.car2x.veins.subprojects.veins_inet.examples.veins_inet;

import inet.physicallayer.ieee80211.packetlevel.Ieee80211DimensionalRadioMedium;
import org.car2x.veins.subprojects.veins_inet.VeinsInetCar;
import org.car2x.veins.subprojects.veins_inet.WifiRSU;
import org.car2x.veins.subprojects.veins_inet.VeinsInetManager;
import org.car2x.veins.new.RSUnew;
import inet.visualizer.integrated.IntegratedVisualizer;
import inet.environment.common.PhysicalEnvironment;
import org.car2x.veins.visualizer.roads.RoadsCanvasVisualizer;
import org.car2x.veins.visualizer.roads.RoadsOsgVisualizer;
import org.car2x.veins.base.connectionManager.ConnectionManager;
import org.car2x.veins.base.modules.BaseWorldUtility;

network Scenario
{
    parameters:
        double playgroundSizeX @unit(m); // x size of the area the nodes are in (in meters)
        double playgroundSizeY @unit(m); // y size of the area the nodes are in (in meters)
        double playgroundSizeZ @unit(m); // z size of the area the nodes are in (in meters)
        @display("bgb=300,365");
    submodules:
        radioMedium: Ieee80211DimensionalRadioMedium {
            @display("p=53,161");
        }
        manager: VeinsInetManager {
            @display("p=182,186");
        }
        visualizer: IntegratedVisualizer {
            @display("p=121,177");
        }
        physicalEnvironment: PhysicalEnvironment {
            @display("p=73,248");
        }
        roadsCanvasVisualizer: RoadsCanvasVisualizer {
            @display("p=182,271");
        }
        roadsOsgVisualizer: RoadsOsgVisualizer {
            @display("p=242,203");
        }
        node[0]: VeinsInetCar {
            @display("p=63,80");
        }
        wifirsu: WifiRSU {
            @display("p=162,80");
        }
        rsu: RSUnew {
            @display("p=225,80;i=veins/node/car;is=s");
        }

    connections allowunconnected:
        rsu.rsuOut --> {  delay = 100ms; } --> wifirsu.DsrcIn;
}
