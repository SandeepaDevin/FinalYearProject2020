
package org.car2x.veins.subprojects.veins_inet;

import inet.networklayer.configurator.ipv4.HostAutoConfigurator;
import inet.node.base.TransportLayerNodeBase;

import inet.applications.contract.IApp;
import org.car2x.veins.subprojects.veins_inet.IAppnew;
import inet.common.MessageDispatcher;


module WifiRSU extends TransportLayerNodeBase
{
    parameters:
        @display("i=device/cellphone");
        @figure[submodules];

        ipv4.arp.proxyArpInterfaces = default(""); // proxy arp is disabled on hosts by default
        *.routingTableModule = default("^.ipv4.routingTable");
 
        numWlanInterfaces = default(1);

        wlan[*].mgmt.typename = default("Ieee80211MgmtAdhoc");
        wlan[*].agent.typename = default("");
        forwarding = default(true);
        
 		int numApps = default(0);
        @figure[applicationLayer](type=rectangle; pos=250,6; size=1000,130; lineColor=#808080; cornerRadius=5; fillColor=#ffff00; fillOpacity=0.1);
        @figure[applicationLayer.title](type=text; pos=1245,11; anchor=ne; text="application layer");
    gates:
        input DsrcIn;
    submodules:
        app[numApps]: <> like IAppnew {
            parameters:
                @display("p=711.144,70.217995,row,150");
        }
        at: MessageDispatcher {
            parameters:
                @display("p=711.89996,133.875;b=837.89996,14.174999,,,,1");
        }
    connections allowunconnected:
		for i=0..numApps-1 {
            app[i].socketOut --> at.in++;
            app[i].socketIn <-- at.out++;
            app[i].upperLayerIn <-- DsrcIn;
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
