#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/internet-module.h"
#include "ns3/point-to-point-module.h"
#include "ns3/applications-module.h"
#include "ns3/traced-value.h"
#include "ns3/trace-source-accessor.h"
#include "ns3/uinteger.h"

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
	netAddresses.SetBase ("51.74.1.0", "255.255.255.0");
	Ipv4InterfaceContainer interfaces = netAddresses.Assign (devices);

	UdpEchoServerHelper echoServer (4002);

	ApplicationContainer serverApps = echoServer.Install (nodes.Get (1));
	serverApps.Start (Seconds (1.0));
	serverApps.Stop (Seconds (3.0));

	UdpEchoClientHelper echoClient (interfaces.GetAddress (1), 4002);
	echoClient.SetAttribute ("MaxPackets", UintegerValue (1));
	echoClient.SetAttribute ("Interval", TimeValue (Seconds (1.0)));
	echoClient.SetAttribute ("PacketSize", UintegerValue (512));

	ApplicationContainer clientApps = echoClient.Install (nodes.Get (0));
	clientApps.Start (Seconds (2.0));
	clientApps.Stop (Seconds (5.0));

	// Traces:
	AsciiTraceHelper ascii;
	pointToPoint.EnableAsciiAll(ascii.CreateFileStream("LAB3_94105174.tr"));
	pointToPoint.EnablePcapAll("LAB3_94105174");

	// Run and desetroy simulation:
	Simulator::Run ();
	Simulator::Destroy ();

	return 0;
}
