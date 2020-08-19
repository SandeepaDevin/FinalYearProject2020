package org.car2x.veins.subprojects.veins_inet;

import inet.node.inet.INetworkNode;

import inet.common.packet.recorder.PcapRecorder;
import inet.common.MessageDispatcher;
import inet.applications.contract.IApp;
import inet.transportlayer.contract.IUdp;
import inet.networklayer.contract.INetworkLayer;
import inet.common.lifecycle.NodeStatus;
import inet.mobility.contract.IMobility;
import inet.linklayer.contract.IWirelessInterface;
import inet.linklayer.contract.IVlanInterface;
import inet.networklayer.common.InterfaceTable;
import inet.linklayer.contract.IPppInterface;
import inet.linklayer.contract.ITunnelInterface;
import inet.linklayer.contract.IExternalInterface;
//
// TODO auto-generated type
//
module Rsuextended extends RsuUnit
{
    parameters:
        bool hasIpv4_1 = default(true);
        bool hasIpv6_1 = default(false);
        int numApps_1 = default(0);
        bool hasUdp_1 = default(firstAvailableOrEmpty("Udp") != "");
        int numVlan_1 = default(0);
        int numWlan_1 = default(0);
        int numPpp_1 = default(0);
        int numExt_1 = default(0);
        mobility.typename = (numWlan > 0 & numWlan_1 >0) ? "StationaryMobility" : "";
        wlan_1[*].radio.antenna.mobilityModule = default("^.^.^.mobility");
        @display("bgb=881,567");
    gates:
        input radioIn_1[numWlan] @directIn;
        inout pppg_1[numPpp] @labels(PppFrame-conn) @allowUnconnected;
    submodules:
        app_1[numApps_1]: <> like IApp {                      //number of apps in application layer. defined the app
            parameters:
                @display("p=645,43,row,150");
        }
        apptrans_1: MessageDispatcher {					// dispatch message between application and transport layers
            parameters:
                @display("p=644,113;b=315.262,14.481999,,,,1");
        }
        transnet_1: MessageDispatcher {					//dispatcher between transport layer and network layer
            parameters:
                @display("p=644,249.536;b=315.262,11.139999,,,,1");
        }
        netlink_1: MessageDispatcher {
            parameters:
                @display("p=644,369.848;b=315.262,15.596,,,,1");
        }
        udp_1: <default(firstAvailableOrEmpty("Udp"))> like IUdp if hasUdp_1 {	//udp transport layer protocol
            parameters:
                @display("p=756,170");
        }
        ipv4_1: <default("Ipv4NetworkLayer")> like INetworkLayer if hasIpv4_1 {
            parameters:
                @display("p=717,299;q=queue");
        }
        ipv6_1: <default("Ipv6NetworkLayer")> like INetworkLayer if hasIpv6_1 {
            parameters:
                @display("p=782,318;q=queue");
        }
        generic_1: <default("")> like INetworkLayer if hasGn_1 {
            parameters:
                @display("p=526,307;q=queue");
        }
        wlan_1[numWlan_1]: <default("Ieee80211Interface")> like IWirelessInterface {
            parameters:
                @display("p=507,432,row,150;q=queue");
        }
        ppp_1[sizeof(pppg_1)]: <default("PppInterface")> like IPppInterface {
            parameters:
                @display("p=565,499,row,150;q=txQueue");
        }
        ext_1[numExt_1]: <default("ExtInterface")> like IExternalInterface {
            parameters:
                @display("p=652,463,row,150;q=txQueue");
        }
        tun_1[numTun_1]: <default("TunInterface")> like ITunnelInterface {
            parameters:
                @display("p=771,432,row,150;q=txQueue");
        }
        vlan_1[numVlan_1]: <default("VlanInterface")> like IVlanInterface {
            parameters:
                @display("p=732,510,row,150;q=txQueue");
        }

    connections allowunconnected:
        ipv4_1.ifIn <-- netlink_1.out++ if hasIpv4_1;
        ipv4_1.ifOut --> netlink_1.in++ if hasIpv4_1;

        ipv6_1.ifIn <-- netlink_1.out++ if hasIpv6_1;
        ipv6_1.ifOut --> netlink_1.in++ if hasIpv6_1;

        generic_1.ifIn <-- netlink_1.out++ if exists(generic_1);
        generic_1.ifOut --> netlink_1.in++ if exists(generic_1);

        for i=0..numApps_1-1 {
            app_1[i].socketOut --> apptrans_1.in++;			//messages between application and app-trans dispatcher
            app_1[i].socketIn <-- apptrans_1.out++;
        }
        for i=0..sizeof(radioIn_1)-1 {
            radioIn_1[i] --> { @display("m=s"); } --> wlan_1[i].radioIn;
            wlan_1[i].upperLayerOut --> netlink_1.in++;
            wlan_1[i].upperLayerIn <-- netlink_1.out++;
        }
        for i=0..sizeof(pppg_1)-1 {
            pppg_1[i] <--> { @display("m=s"); } <--> ppp_1[i].phys;
            ppp_1[i].upperLayerOut --> netlink_1.in++;
            ppp_1[i].upperLayerIn <-- netlink_1.out++;
        }
        apptrans_1.out++ --> udp_1.appIn if hasUdp_1;
        apptrans_1.in++ <-- udp_1.appOut if hasUdp_1;

        udp_1.ipOut --> transnet_1.in++ if hasUdp_1;
        udp_1.ipIn <-- transnet_1.out++ if hasUdp_1;

        apptrans_1.out++ --> transnet_1.in++;
        apptrans_1.in++ <-- transnet_1.out++;

        transnet_1.out++ --> netlink_1.in++;
        transnet_1.in++ <-- netlink_1.out++;

        for i=0..numExt_1-1 {
            ext_1[i].upperLayerOut --> netlink_1.in++;
            ext_1[i].upperLayerIn <-- netlink_1.out++;
        }
        for i=0..numTun_1-1 {
            tun_1[i].upperLayerOut --> netlink_1.in++;
            tun_1[i].upperLayerIn <-- netlink_1.out++;
        }
        for i=0..numVlan_1-1 {
            vlan_1[i].upperLayerOut --> netlink_1.in++;
            vlan_1[i].upperLayerIn <-- netlink_1.out++;
        }
}
