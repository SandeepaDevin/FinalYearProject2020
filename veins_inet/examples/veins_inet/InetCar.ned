package org.car2x.veins.subprojects.veins_inet.example;

import inet.applications.contract.IApp;
import inet.common.MessageDispatcher;
import inet.networklayer.configurator.ipv4.HostAutoConfigurator;
import inet.node.base.TransportLayerNodeBase;
import org.car2x.veins.base.modules.*;
//
// TODO auto-generated type
//
network InetCar extends TransportLayerNodeBase
{
    parameters:
        @display("i=device/pc");
        @figure[submodules];
        forwarding = default(false);  // disable routing by default
        ipv4.arp.proxyArpInterfaces = default(""); // proxy arp is disabled on hosts by default
        *.routingTableModule = default("^.ipv4.routingTable");
        string veinsmobilityType = default("org.car2x.veins.modules.mobility.traci.TraCIMobility");
        ipv4.configurator.networkConfiguratorModule = "";
        wlan[*].mgmt.typename = default("Ieee80211MgmtAdhoc");
        wlan[*].agent.typename = default("");
        forwarding = default(true);
        numWlanInterfaces = default(1);
        int numApps = default(0);
        @figure[applicationLayer](type=rectangle; pos=250,6; size=1000,130; lineColor=#808080; cornerRadius=5; fillColor=#ffff00; fillOpacity=0.1);
        @figure[applicationLayer.title](type=text; pos=1245,11; anchor=ne; text="application layer");
        
    submodules:
        veinsmobility: <veinsmobilityType> like org.car2x.veins.base.modules.IMobility {
            parameters:
                @display("p=130,172;i=block/cogwheel");
        }
        ifConfig: HostAutoConfigurator {
            @display("p=125,320;is=s");
        }
        app[numApps]: <> like IApp {
            parameters:
                @display("p=375,76,row,150");
        }
        at: MessageDispatcher {
            parameters:
                @display("p=750,146;b=1000,5,,,,1");
        }
    connections allowunconnected:
        for i=0..numApps-1 {
            app[i].socketOut --> at.in++;
            app[i].socketIn <-- at.out++;
        }

        at.out++ --> udp.appIn if hasUdp;
        at.in++ <-- udp.appOut if hasUdp;

        at.out++ --> tcp.appIn if hasTcp;
        at.in++ <-- tcp.appOut if hasTcp;

        at.out++ --> sctp.appIn if hasSctp;
        at.in++ <-- sctp.appOut if hasSctp;

        at.out++ --> tn.in++;
        at.in++ <-- tn.out++;
}
