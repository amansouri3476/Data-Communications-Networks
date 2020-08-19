////////////////////////////////////////////////////// 1.
#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/internet-module.h"
#include "ns3/mobility-module.h"
#include "ns3/config-store-module.h"
#include "ns3/applications-module.h"
#include "ns3/wifi-module.h"
#include "ns3/internet-module.h"
#include "ns3/aodv-helper.h"
#include "ns3/olsr-helper.h"
#include "ns3/on-off-helper.h"
#include "ns3/point-to-point-layout-module.h"
#include "ns3/ipv4-static-routing-helper.h"
#include "ns3/ipv4-list-routing-helper.h"
#include "ns3/ipv4-global-routing-helper.h"
#include "ns3/flow-monitor.h"
#include "ns3/flow-monitor-helper.h"
#include "ns3/flow-monitor-module.h"
#include "ns3/animation-interface.h"
#include "ns3/netanim-module.h"
#include "ns3/command-line.h"
#include "ns3/random-variable-stream.h"
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
////////////////////////////////////////////////////////

////////////////////////////////////////////////////// 2.
using namespace ns3;
NS_LOG_COMPONENT_DEFINE ("WifiAdhoc_Routing");
//////////////////////////////////////////////////////

////////////////////////////////////////////////////// 3.
int main(int argc, char *argv[]){
  std::string phyMode ("DsssRate1Mbps");
  uint32_t PacketSize = 512; // bytes
  std::string DataRate ("1Mbps"); // Kbytes per second
  uint16_t num_Nodes = 10;
  uint16_t UDPport = 9;
  bool verbose = false;
  bool tracing = false;
  Config::SetDefault("ns3::OnOffApplication::PacketSize", UintegerValue (PacketSize));
  Config::SetDefault("ns3::OnOffApplication::DataRate", StringValue (DataRate));
  //"CommandLine object allows the user to override any of the defaults at run-time
  CommandLine cmd;
  cmd.AddValue ("phyMode", "Wifi Phy mode", phyMode);
  cmd.AddValue ("PacketSize", "size of application packet sent", PacketSize);
  cmd.AddValue ("DataRate", "rate of pacekts sent", DataRate);
  cmd.AddValue ("verbose", "turn on all WifiNetDevice log components", verbose);
  cmd.AddValue ("tracing", "turn on ascii and pcap tracing", tracing);
  cmd.Parse (argc, argv);
  ns3::PacketMetadata::Enable();
  std::string animFile = "Aodv_94105174.xml" ;
  ////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////// I'll tell you this one :) . We are creating our nodes. viola!!!!
  NodeContainer Nodes;
  Nodes.Create (num_Nodes);
  //////////////////////////////////////////////////////

  ////////////////////////////////////////////////////// 4.
  WifiHelper wifi;
  if (verbose)
  {
  wifi.EnableLogComponents (); // Turn on all Wifi logging
  }
  //////////////////////////////////////////////////////

  ////////////////////////////////////////////////////// 5.
  YansWifiPhyHelper wifiPhy = YansWifiPhyHelper::Default ();
  wifiPhy.Set ("RxGain", DoubleValue (-12) );
  // ns-3 supports RadioTap and Prism tracing extensions for 802.11b
  wifiPhy.SetPcapDataLinkType (YansWifiPhyHelper::DLT_IEEE802_11_RADIO);
  //////////////////////////////////////////////////////

  ////////////////////////////////////////////////////// 6.
  YansWifiChannelHelper wifiChannel;
  wifiChannel.SetPropagationDelay("ns3::ConstantSpeedPropagationDelayModel");
  wifiChannel.AddPropagationLoss("ns3::FriisPropagationLossModel");
  wifiPhy.SetChannel (wifiChannel.Create ());
  //////////////////////////////////////////////////////


  ////////////////////////////////////////////////////// 7.
  NqosWifiMacHelper wifiMac = NqosWifiMacHelper::Default ();
  wifi.SetStandard (WIFI_PHY_STANDARD_80211b);
  wifi.SetRemoteStationManager("ns3::ConstantRateWifiManager","DataMode",StringValue(phyMode),
  "ControlMode",StringValue (phyMode));
  //////////////////////////////////////////////////////

  ////////////////////////////////////////////////////// 8.
  wifiMac.SetType ("ns3::AdhocWifiMac");
  NetDeviceContainer Devices;
  Devices = wifi.Install (wifiPhy, wifiMac, Nodes);
  //////////////////////////////////////////////////////

  ////////////////////////////////////////////////////// 9.
  MobilityHelper mobility;
  mobility.SetPositionAllocator ("ns3::GridPositionAllocator",
  "MinX", DoubleValue (10.0),
  "MinY", DoubleValue (10.0),"DeltaX", DoubleValue (5.0),
  "DeltaY", DoubleValue (10.0),"GridWidth", UintegerValue (3),
  "LayoutType", StringValue ("RowFirst"));
  Ptr<ListPositionAllocator> positionAlloc = CreateObject <ListPositionAllocator>();
  positionAlloc ->Add(Vector(100, 0, 0));
  positionAlloc ->Add(Vector(100, 200, 0));
  positionAlloc ->Add(Vector(100, 300, 0));
  positionAlloc ->Add(Vector(400, 400, 0));
  positionAlloc ->Add(Vector(300, 400, 0));
  positionAlloc ->Add(Vector(300, 300, 0));
  positionAlloc ->Add(Vector(300, 190, 0));
  positionAlloc ->Add(Vector(200, 300, 0));
  positionAlloc ->Add(Vector(400, 210, 0));
  mobility.SetPositionAllocator(positionAlloc);
  mobility.SetMobilityModel ("ns3::ConstantPositionMobilityModel");
  mobility.Install (Nodes);
  //////////////////////////////////////////////////////  Is this part complete???!!!!!!

  ////////////////////////////////////////////////////// 10.
  OlsrHelper olsr;
  Ipv4StaticRoutingHelper staticRouting;
  Ipv4ListRoutingHelper list;
  list.Add (staticRouting, 0);
  list.Add (olsr, 10);
  InternetStackHelper internet;
  internet.SetRoutingHelper (list); // has effect on the next Install ()
  internet.Install (Nodes);
  //////////////////////////////////////////////////////

  ////////////////////////////////////////////////////// 11.
  Ipv4AddressHelper ipv4;
  NS_LOG_INFO ("Assign IP Addresses.");
  ipv4.SetBase ("192.168.1.0", "255.255.255.0");
  Ipv4InterfaceContainer i;
  i = ipv4.Assign (Devices);
  ////////////////////////////////////////////////////// Is this part complete???!!!!!!


  ////////////////////////////////////////////////////// 12.
  PacketSinkHelper UDPsink ("ns3::UdpSocketFactory", InetSocketAddress(Ipv4Address::GetAny (),
  UDPport));
  ApplicationContainer App;
  NodeContainer SourceNode = NodeContainer (Nodes.Get (10));
  NodeContainer SinkNode = NodeContainer (Nodes.Get (0));
  //To Create a UDP packet sink
  App = UDPsink.Install(SinkNode);
  App.Start (Seconds (30.0));
  App.Stop (Seconds (60.0));
  //To Create a UDP packet source
  OnOffHelper UDPsource ("ns3::UdpSocketFactory", InetSocketAddress(i.GetAddress(9,0), UDPport));
  UDPsource.SetAttribute ("OnTime", StringValue("ns3::ConstantRandomVariable[Constant=1]"));
  UDPsource.SetAttribute ("OffTime", StringValue("ns3::ConstantRandomVariable[Constant=0]"));
  App = UDPsource.Install(SourceNode);
  App.Start (Seconds (30.0));
  App.Stop (Seconds (60.0));
  Simulator::Stop (Seconds (60.0));
  //////////////////////////////////////////////////////


  ////////////////////////////////////////////////////// 13.
  AnimationInterface anim (animFile);
  Ptr<OutputStreamWrapper> routingStream = Create<OutputStreamWrapper> ("moh-aodv-routes",
  std::ios::out);
  AodvHelper aodv;
  aodv.PrintRoutingTableAllEvery (Seconds (1), routingStream);
  //////////////////////////////////////////////////////
  Simulator::Run();
  Simulator::Destroy();
  return 0;
}
