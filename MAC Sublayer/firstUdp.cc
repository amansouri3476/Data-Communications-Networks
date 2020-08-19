#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/internet-module.h"
#include "ns3/point-to-point-module.h"
#include "ns3/applications-module.h"

#define NODES_NUMBER 2

using namespace ns3;
NS_LOG_COMPONENT_DEFINE ("Lab 3 UDP");

int main (int argc, char *argv[]) {
  
	// Command Line:
	CommandLine cmd;
	cmd.Parse (argc, argv);
	
	// Time:
	Time::SetResolution (Time::NS);
	LogComponentEnable ("UdpEchoClientApplication", LOG_LEVEL_INFO);
	LogComponentEnable ("UdpEchoServerApplication", LOG_LEVEL_INFO);


	// Nodes:
	NodeContainer nodes;
	nodes.Create (2);

	// Point to point:
	PointToPointHelper pointToPoint;
	pointToPoint.SetDeviceAttribute ("DataRate", StringValue ("10Mbps"));

	pointToPoint.SetChannelAttribute ("Delay", StringValue ("5ms"));

	// Net Device Container:
	NetDeviceContainer devices;
	devices = pointToPoint.Install (nodes);

	// Internet stack:
	InternetStackHelper internetStack;
	internetStack.Install (nodes);

	// IPV4 address:
	Ipv4AddressHelper netAddresses;
	netAddresses.SetBase ("08.05.1.0", "255.255.255.0");
	Ipv4InterfaceContainer interfaces = netAddresses.Assign (devices);

	UdpEchoServerHelper echoServer (12);

	ApplicationContainer serverApps = echoServer.Install (nodes.Get (1));
	serverApps.Start (Seconds (1.0));
	serverApps.Stop (Seconds (10.0));

	UdpEchoClientHelper echoClient (interfaces.GetAddress (1), 12);
	echoClient.SetAttribute ("MaxPackets", UintegerValue (1));
	echoClient.SetAttribute ("Interval", TimeValue (Seconds (4.0)));
	echoClient.SetAttribute ("PacketSize", UintegerValue (1024));

	ApplicationContainer clientApps = echoClient.Install (nodes.Get (0));
	clientApps.Start (Seconds (2.0));
	clientApps.Stop (Seconds (60.0));


	// Run and desetroy simulation:
	Simulator::Run ();
	Simulator::Destroy ();

	return 0;
}

