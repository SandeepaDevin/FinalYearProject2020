package org.car2x.veins.subprojects.veins_inet;

import org.car2x.veins.subprojects.veins_inet.IAppnew;

simple VeinsInetApplicationBasenew like IAppnew
{
    parameters:
        string interfaceTableModule;   // The path to the InterfaceTable module
        string interface = default("wlan0");  // The interface name of where to send packets (via multicast)

        @display("i=block/app");
        @class(veins::VeinsInetApplicationBasenew);
        @signal[packetSent](type=inet::Packet);
        @signal[packetReceived](type=inet::Packet);
        @statistic[packetReceived](title="packets received"; source=packetReceived; record=count,"sum(packetBytes)","vector(packetBytes)"; interpolationmode=none);
        @statistic[throughput](title="throughput"; unit=bps; source="throughput(packetReceived)"; record=vector);
        @statistic[packetSent](title="packets sent"; source=packetSent; record=count,"sum(packetBytes)","vector(packetBytes)"; interpolationmode=none);
        @statistic[rcvdPkLifetime](title="received packet lifetime"; source="dataAge(packetReceived)"; unit=s; record=stats,vector; interpolationmode=none);
    gates:
        input socketIn @labels(UdpControlInfo/up);
        output socketOut @labels(UdpControlInfo/down);
        input DsrcIn;
}
