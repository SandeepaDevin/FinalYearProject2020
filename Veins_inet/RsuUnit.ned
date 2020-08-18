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
module RsuUnit like INetworkNode
{
    parameters:
        bool hasStatus = default(false); 
        bool hasIpv4 = default(true); 	 
        bool hasIpv6 = default(false);	 
        int numApps = default(0);		 
        bool hasUdp = default(firstAvailableOrEmpty("Udp") != "");
        bool forwarding = default(false);
        bool multicastForwarding = default(false);
        *.forwarding = forwarding;
        *.multicastForwarding = multicastForwarding;
        int numPcap = default(0);
        int numVlan = default(0);
        int numWlan = default(0);
        int numPpp = default(0);
        int numExt = default(0);
        mobility.subjectModule = default("^");
        *.mobilityModule = default(exists(mobility) ? absPath(".mobility") : "");
        mobility.typename = default(numWlan > 0 ? "StationaryMobility" : "");
        *.interfaceTableModule = default(absPath(".interfaceTable"));
        wlan[*].radio.antenna.mobilityModule = default("^.^.^.mobility");
        @display("bgb=738.582,567.026");
    gates:
        input radioIn[numWlan] @directIn;
        inout pppg[numPpp] @labels(PppFrame-conn) @allowUnconnected;
    submodules:
        status: NodeStatus if hasStatus {
            parameters:
                @display("p=144.81999,25.622;is=s");
        }
        pcapRecorder[numPcap]: PcapRecorder {
            parameters:
                @display("p=83.549995,170.442;is=s");
        }
        ipv4: <default("Ipv4NetworkLayer")> like INetworkLayer if hasIpv4 {
            parameters:
                @display("p=305.236,299.666;q=queue");
        }
        ipv6: <default("Ipv6NetworkLayer")> like INetworkLayer if hasIpv6 {
            parameters:
                @display("p=375.418,307.464;q=queue");
        }
        generic: <default("")> like INetworkLayer if hasGn {
            parameters:
                @display("p=160.416,290.754;q=queue");
        }
        app[numApps]: <> like IApp {                      //number of apps in application layer. defined the app
            parameters:
                @display("p=250,43,row,150");
        }
        apptrans: MessageDispatcher {					// dispatch message between application and transport layers
            parameters:
                @display("p=251.76399,113.628;b=315.262,14.481999,,,,1");
        }
        transnet: MessageDispatcher {					//dispatcher between transport layer and network layer
            parameters:
                @display("p=251.76399,249.536;b=315.262,11.139999,,,,1");
        }
        netlink: MessageDispatcher {
            parameters:
                @display("p=251.76399,369.848;b=315.262,15.596,,,,1");
        }
        udp: <default(firstAvailableOrEmpty("Udp"))> like IUdp if hasUdp {	//udp transport layer protocol
            parameters:
                @display("p=331.972,170.442");
        }
        interfaceTable: InterfaceTable {
            parameters:
                @display("p=57.927998,25.622;is=s");
        }
        wlan[numWlan]: <default("Ieee80211Interface")> like IWirelessInterface {
            parameters:
                @display("p=66.84,419.978,row,150;q=queue");
        }
        ppp[sizeof(pppg)]: <default("PppInterface")> like IPppInterface {
            parameters:
                @display("p=123.654,499.072,row,150;q=txQueue");
        }
        ext[numExt]: <default("ExtInterface")> like IExternalInterface {
            parameters:
                @display("p=249.536,463.42398,row,150;q=txQueue");
        }
        tun[numTun]: <default("TunInterface")> like ITunnelInterface {
            parameters:
                @display("p=418.86398,432.232,row,150;q=txQueue");
        }
        vlan[numVlan]: <default("VlanInterface")> like IVlanInterface {
            parameters:
                @display("p=375.418,516.896,row,150;q=txQueue");
        }
        mobility: <default("")> like IMobility if typename != "" {
            parameters:
                @display("p=45.674,94.689995;is=s");
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

        for i=0..sizeof(radioIn)-1 {
            radioIn[i] --> { @display("m=s"); } --> wlan[i].radioIn;
            wlan[i].upperLayerOut --> netlink.in++;
            wlan[i].upperLayerIn <-- netlink.out++;
        }
        for i=0..sizeof(pppg)-1 {
            pppg[i] <--> { @display("m=s"); } <--> ppp[i].phys;
            ppp[i].upperLayerOut --> netlink.in++;
            ppp[i].upperLayerIn <-- netlink.out++;
        }
        for i=0..numExt-1 {
            ext[i].upperLayerOut --> netlink.in++;
            ext[i].upperLayerIn <-- netlink.out++;
        }
        for i=0..numTun-1 {
            tun[i].upperLayerOut --> netlink.in++;
            tun[i].upperLayerIn <-- netlink.out++;
        }
        for i=0..numVlan-1 {
            vlan[i].upperLayerOut --> netlink.in++;
            vlan[i].upperLayerIn <-- netlink.out++;
        }
}
