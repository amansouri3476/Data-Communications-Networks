#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/csma-module.h"
#include "ns3/internet-module.h"
#include "ns3/point-to-point-module.h"
#include "ns3/applications-module.h"
#include "ns3/ipv4-global-routing-helper.h"
#include "ns3/netanim-module.h"

using namespace ns3;

NS_LOG_COMPONENT_DEFINE ("LAB3CSMACD");

int main (int argc, char *argv[]) {

  uint32_t nCsma = 5;

  LogComponentEnable ("UdpEchoClientApplication", LOG_LEVEL_INFO);
  LogComponentEnable ("UdpEchoServerApplication", LOG_LEVEL_INFO);

  NodeContainer csmaNodes;
  csmaNodes.Create (nCsma);

  CsmaHelper csma;
  csma.SetChannelAttribute ("DataRate", StringValue ("100Mbps"));
  csma.SetChannelAttribute ("Delay", TimeValue (NanoSeconds (6000)));

  NetDeviceContainer csmaDevices;
  csmaDevices = csma.Install (csmaNodes);

  InternetStackHelper stack;
  stack.Install (csmaNodes);

  Ipv4AddressHelper address;

  address.SetBase ("51.74.2.0", "255.255.255.0");
  Ipv4InterfaceContainer csmaInterfaces;
  csmaInterfaces = address.Assign (csmaDevices);

// A:
  UdpEchoServerHelper echoServer (9);

  ApplicationContainer serverApps = echoServer.Install (csmaNodes.Get (0));
  serverApps.Start (Seconds (1.0));
  serverApps.Stop (Seconds (50.0));

  UdpEchoClientHelper echoClient (csmaInterfaces.GetAddress (0), 9);
  echoClient.SetAttribute ("MaxPackets", UintegerValue (5));
  echoClient.SetAttribute ("Interval", TimeValue (Seconds (1.0)));
  echoClient.SetAttribute ("PacketSize", UintegerValue (1024));

  ApplicationContainer clientApps = echoClient.Install (csmaNodes.Get (4));
  clientApps.Start (Seconds (2.0));
  clientApps.Stop (Seconds (120.0));

// B:
  UdpEchoServerHelper echoServer2 (10);

  ApplicationContainer serverApps2 = echoServer2.Install (csmaNodes.Get (1));
  serverApps2.Start (Seconds (1.0));
  serverApps2.Stop (Seconds (50.0));

  UdpEchoClientHelper echoClient2 (csmaInterfaces.GetAddress (1), 10);
  echoClient2.SetAttribute ("MaxPackets", UintegerValue (5));
  echoClient2.SetAttribute ("Interval", TimeValue (Seconds (1.0)));
  echoClient2.SetAttribute ("PacketSize", UintegerValue (1024));

  ApplicationContainer clientApps2 = echoClient2.Install (csmaNodes.Get (3));
  clientApps2.Start (Seconds (2.0));
  clientApps2.Stop (Seconds (120.0));


  Ipv4GlobalRoutingHelper::PopulateRoutingTables ();
  csma.EnablePcap ("LAB3CSMA", csmaDevices.Get (1), true);


  AnimationInterface anim ("LAB3CSMA.xml");

  anim.SetConstantPosition(csmaNodes.Get(0), 1.0, 2.0);
  anim.SetConstantPosition(csmaNodes.Get(1), 1.0, 3.0);
  anim.SetConstantPosition(csmaNodes.Get(2), 2.0, 2.0);
  anim.SetConstantPosition(csmaNodes.Get(3), 2.0, 3.0);
  anim.SetConstantPosition(csmaNodes.Get(4), 5.0, 6.0);


  Simulator::Run ();
  Simulator::Destroy ();
  return 0;
}
