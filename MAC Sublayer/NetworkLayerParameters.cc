#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/internet-module.h"
#include "ns3/point-to-point-module.h"
#include "ns3/applications-module.h"
#include "ns3/mobility-module.h"
#include "ns3/config-store-module.h"

#define NODES 2

using namespace ns3;
NS_LOG_COMPONENT_DEFINE ("Lab3ONOFF");

int main (int argc, char *argv[]) {

	// Command Line:
	CommandLine cmd;
	cmd.Parse (argc, argv);

	// Time:
	Time::SetResolution (Time::NS);
	LogComponentEnable("OnOffApplication", LOG_LEVEL_INFO);

	// Nodes:
	NodeContainer nodes;
	nodes.Create (NODES);

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

	// Application On Off:
	Address onOffAddress = InetSocketAddress(interfaces.GetAddress(0), 4002);
	OnOffHelper app ("ns3::UdpSocketFactory", onOffAddress);
	app.SetAttribute ("OnTime", StringValue("ns3::ConstantRandomVariable[Constant=1]"));
	app.SetAttribute ("OffTime", StringValue("ns3::ConstantRandomVariable[Constant=0.7]"));
	app.SetAttribute ("DataRate",StringValue ("10Mbps"));
	app.SetAttribute ("PacketSize", UintegerValue (512));

	ApplicationContainer source;

	source.Add (app.Install (nodes.Get(0)));
	source.Start (Seconds (1.1));
	source.Stop (Seconds (10));

	// Run and desetroy simulation:
	Simulator::Run ();
	Simulator::Destroy ();

	return 0;
}
