package org.car2x.veins.subprojects.veins_inet;

moduleinterface IAppnew
{
    parameters:
        @display("i=block/app");
    gates:
        input socketIn;
        output socketOut;
        input DsrcIn;
}
