package org.car2x.veins.subprojects.veins_inet;

import inet.common.MessageDispatcher;
import inet.applications.contract.IApp;
import inet.transportlayer.contract.IUdp;
//
// TODO auto-generated type
//
module Dsrc
{
    parameters:
        int numApps = default(0);
        bool hasUdp = default(firstAvailableOrEmpty("Udp") != "");
    submodules:
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
        udp: <default(firstAvailableOrEmpty("Udp"))> like IUdp if hasUdp {	//udp transport layer protocol
            parameters:
                @display("p=365,186");
        }
    connections allowunconnected:
        for i=0..numApps-1 {
            app[i].socketOut --> apptrans.in++;			//messages between application and app-trans dispatcher
            app[i].socketIn <-- apptrans.out++;
        }
        apptrans.out++ --> udp.appIn if hasUdp;
        apptrans.in++ <-- udp.appOut if hasUdp;

        apptrans.out++ --> transnet.in++;
        apptrans.in++ <-- transnet.out++;
        
        transnet.out++ --> nl.in++;
        transnet.in++ <-- nl.out++;
}
