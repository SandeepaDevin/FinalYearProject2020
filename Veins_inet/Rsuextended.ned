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
    @display("bgb=881,567");
    submodules:
        app_1[numApps]: <> like IApp {                      //number of apps in application layer. defined the app
            parameters:
                @display("p=645,43,row,150");
        }
        apptrans_1: MessageDispatcher {					// dispatch message between application and transport layers
            parameters:
                @display("p=644,113;b=315.262,14.481999,,,,1");
        }
    connections allowunconnected:
        for i=0..numApps-1 {
            app_1[i].socketOut --> apptrans_1.in++;			//messages between application and app-trans dispatcher
            app_1[i].socketIn <-- apptrans_1.out++;
        }
}
