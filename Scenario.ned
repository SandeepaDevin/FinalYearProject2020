package org.car2x.veins.subprojects.veins_inet.example;

import inet.physicallayer.ieee80211.packetlevel.Ieee80211ScalarRadioMedium;
import org.car2x.veins.subprojects.veins_inet.VeinsInetCar;
import org.car2x.veins.subprojects.veins_inet.VeinsInetManager;
import org.car2x.veins.modules.obstacle.ObstacleControl;
import org.car2x.veins.modules.world.annotations.AnnotationManager;
import org.car2x.veins.base.modules.BaseWorldUtility;



network Scenario
{
    parameters:
        double playgroundSizeX @unit(m); // x size of the area the nodes are in (in meters)
        double playgroundSizeY @unit(m); // y size of the area the nodes are in (in meters)
        double playgroundSizeZ @unit(m); // z size of the area the nodes are in (in meters)
        @display("bgb=$playgroundSizeX,$playgroundSizeY");
        @display("bgb=453.22665,261.33334");
    submodules:
        obstacles: ObstacleControl {
            @display("p=83.62666,37.333332");
        }
        annotations: AnnotationManager {
            @display("p=209.81332,59.733334");
        }
        radioMedium: Ieee80211ScalarRadioMedium {
            @display("p=146.34666,36.586666");
        }
        world: BaseWorldUtility {
            parameters:
                playgroundSizeX = playgroundSizeX;
                playgroundSizeY = playgroundSizeY;
                playgroundSizeZ = playgroundSizeZ;
                @display("p=261.33334,37.333332;i=misc/globe");
        }
        manager: VeinsInetManager {
            @display("p=45.546665,88.10667");
        }
        node[0]: VeinsInetCar {
            @display("p=165.76,111.253334");
        }
        //RSU[1]: VeinsInetCar {
        //    @display("p=114.986664,96.32");
        //}
}
