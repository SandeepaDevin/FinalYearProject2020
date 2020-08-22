package org.car2x.veins.subprojects.veins_inet;

//
// TODO auto-generated type
//
simple wifixdsrc
{
    gates:
        input dsrcin;
        output dsrcout;
        input wifiin;
        output wifiout;
}
network FinalRsu extends Rsuextended
{
    submodules:
        wifixdsrc[numApps]: wifixdsrc {           //packet converter module instantiated           
            parameters:
                @display("p=448,43,row,150");
        }
    connections allowunconnected:
        for i=0..numApps1-1 {
            wifixdsrc[i].dsrcin <-- apptrans.out++;			//connections established 
            wifixdsrc[i].wifiin <-- apptrans_1.out++;
            wifixdsrc[i].dsrcout --> apptrans_1.in++;
            wifixdsrc[i].wifiout --> apptrans.in++;
        }
}
