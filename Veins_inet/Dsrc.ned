package org.car2x.veins.subprojects.veins_inet;

import inet.common.MessageDispatcher;
import inet.applications.contract.IApp;
import inet.transportlayer.contract.IUdp;
import inet.networklayer.contract.INetworkLayer;
import inet.common.lifecycle.NodeStatus;
import inet.mobility.contract.IMobility;
import inet.node.inet.INetworkNode;
import inet.linklayer.contract.IWirelessInterface;
import inet.linklayer.contract.IVlanInterface;
import inet.networklayer.common.InterfaceTable;
import inet.linklayer.contract.IPppInterface;
import inet.linklayer.contract.ITunnelInterface;
//
// TODO auto-generated type
//
module Dsrc
{
    parameters:
        bool hasIpv4 = default(true);
        bool hasIpv6 = default(false);
        int numApps = default(0);
        bool hasUdp = default(firstAvailableOrEmpty("Udp") != "");
        bool forwarding = default(false);
        bool multicastForwarding = default(false);
        *.forwarding = forwarding;
        *.multicastForwarding = multicastForwarding;
    gates:
        input radioIn[numWlanInterfaces] @directIn;
        inout pppg[numPppInterfaces] @labels(PppFrame-conn) @allowUnconnected;
    submodules:
        ipv4: <default("Ipv4NetworkLayer")> like INetworkLayer if hasIpv4 {
            parameters:
                @display("p=365,308;q=queue");
        }
        ipv6: <default("Ipv6NetworkLayer")> like INetworkLayer if hasIpv6 {
            parameters:
                @display("p=419,347;q=queue");
        }
        generic: <default("")> like INetworkLayer if hasGn {
            parameters:
                @display("p=180,328;q=queue");
        }
        app[numApps]: <> like IApp {                      //number of apps in application layer. defined the app
            parameters:
                @display("p=250,43,row,150");
        }
        apptrans: MessageDispatcher {					// dispatch message between application and transport layers
            parameters:
                @display("p=249,114;b=379,15,,,,1");
        }
        transnet: MessageDispatcher {					//dispatcher between transport layer and network layer
            parameters:
                @display("p=253,271;b=387,12,,,,1");
        }
        netlink: MessageDispatcher {
            parameters:
                @display("p=253,378;b=387,9,,,,1");
        }
        udp: <default(firstAvailableOrEmpty("Udp"))> like IUdp if hasUdp {	//udp transport layer protocol
            parameters:
                @display("p=365,186");
        }
    connections allowunconnected:
        ipv4.ifIn <-- netlink.out++ if hasIpv4;
        ipv4.ifOut --> netlink.in++ if hasIpv4;

        ipv6.ifIn <-- netlink.out++ if hasIpv6;
        ipv6.ifOut --> netlink.in++ if hasIpv6;

        generic.ifIn <-- netlink.out++ if exists(generic);
        generic.ifOut --> netlink.in++ if exists(generic);

        for i=0..numApps-1 {
            app[i].socketOut --> apptrans.in++;			//messages between application and app-trans dispatcher
            app[i].socketIn <-- apptrans.out++;
        }
        apptrans.out++ --> udp.appIn if hasUdp;
        apptrans.in++ <-- udp.appOut if hasUdp;

        apptrans.out++ --> transnet.in++;
        apptrans.in++ <-- transnet.out++;

        transnet.out++ --> netlink.in++;
        transnet.in++ <-- netlink.out++;

        udp.ipOut --> transnet.in++ if hasUdp;
        udp.ipIn <-- transnet.out++ if hasUdp;
}
