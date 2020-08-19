#include <iostream>
#include <fstream>
#include <string>

#include "ns3/core-module.h"
#include "ns3/applications-module.h"
#include "ns3/network-module.h"
#include "ns3/internet-module.h"
#include "ns3/point-to-point-module.h"
#include "ns3/ipv4-global-routing-helper.h"
#include "ns3/error-model.h"

using namespace ns3;
bool firstCwnd = true;
Ptr<OutputStreamWrapper> cWndStream;
uint32_t cWndValue;

static void
CwndTracer (uint32_t oldval, uint32_t newval)
{
  if (firstCwnd)
    {
      *cWndStream->GetStream () << "0.0 " << oldval << std::endl;
      firstCwnd = false;
    }
  *cWndStream->GetStream () << Simulator::Now ().GetSeconds () << " " << newval << std::endl;
  cWndValue = newval;

}

  static void
  TraceCwnd (std::string cwnd_tr_file_name)
  {
    AsciiTraceHelper ascii;
    cWndStream = ascii.CreateFileStream (cwnd_tr_file_name.c_str ());
    Config::ConnectWithoutContext ("/NodeList/1/$ns3::TcpL4Protocol/SocketList/0/CongestionWindow", MakeCallback (&CwndTracer));
  }

int main (int argc, char *argv[])
{





std::string prefix_file_name = "Lab5_1";

  ns3::PacketMetadata::Enable () ;

  NodeContainer n0n1;
  n0n1.Create (2);

  NodeContainer n1n2;
  n1n2.Add (n0n1.Get (1));
  n1n2.Create (1);

  NodeContainer n2n3;
  n2n3.Add (n1n2.Get (1));
  n2n3.Create (1);


/*
  double error_p = 0.01;

    Ptr<UniformRandomVariable> uv = CreateObject<UniformRandomVariable> ();
    uv->SetStream (50);
    RateErrorModel error_model;
    error_model.SetRandomVariable (uv);
    error_model.SetUnit (RateErrorModel::ERROR_UNIT_PACKET);
    error_model.SetRate (error_p);

*/

  double error_p = 0.0005;


   Ptr<UniformRandomVariable> uv = CreateObject<UniformRandomVariable> ();
   Ptr<UniformRandomVariable> uv2 = CreateObject<UniformRandomVariable> ();
   uv2->SetAttribute("Min",DoubleValue(1));
   uv2->SetAttribute("Max",DoubleValue(5));
   BurstErrorModel error_model;
   error_model.SetRandomVariable (uv);
   error_model.SetRandomBurstSize (uv2);
   error_model.SetBurstRate (error_p/2);


    // We create the channels first without any IP addressing information
    // First make and configure the helper, so that it will put the appropriate
    // attributes on the network interfaces and channels we are about to install.
    PointToPointHelper p2p1;
    p2p1.SetDeviceAttribute ("DataRate", DataRateValue (DataRate ("1Mbps")));
    p2p1.SetChannelAttribute ("Delay", TimeValue (MilliSeconds (15)));

    PointToPointHelper p2p2;
    p2p2.SetDeviceAttribute ("DataRate", DataRateValue (DataRate ("4Mbps")));
    p2p2.SetChannelAttribute ("Delay", TimeValue (MilliSeconds (50)));
  //  p2p2.SetDeviceAttribute ("ReceiveErrorModel", PointerValue (&error_model));



  PointToPointHelper p2p3;
  p2p3.SetDeviceAttribute ("DataRate", DataRateValue (DataRate ("1Mbps")));
  p2p3.SetChannelAttribute ("Delay", TimeValue (MilliSeconds (15)));
  // And then install devices and channels connecting our topology.
  NetDeviceContainer dev0 = p2p1.Install (n0n1);
  NetDeviceContainer dev1 = p2p2.Install (n1n2);
  NetDeviceContainer dev2 = p2p3.Install (n2n3);



  InternetStackHelper internet;
  internet.InstallAll ();

  // Later, we add IP addresses.
  Ipv4AddressHelper ipv4;
  ipv4.SetBase ("94.21.1.0", "255.255.255.0");
  //ipv4.Assign (dev1);
  Ipv4InterfaceContainer ipInterfs0 = ipv4.Assign (dev1);
  ipv4.SetBase ("94.21.2.0", "255.255.255.0");
  Ipv4InterfaceContainer ipInterfs1 = ipv4.Assign (dev0);
  ipv4.SetBase ("94.21.3.0", "255.255.255.0");
  Ipv4InterfaceContainer ipInterfs2 = ipv4.Assign (dev2);



Config::SetDefault ("ns3::TcpL4Protocol::SocketType", StringValue ("ns3::TcpNewReno"));


  Ipv4GlobalRoutingHelper::PopulateRoutingTables ();




    BulkSendHelper source ("ns3::TcpSocketFactory",
                           InetSocketAddress (ipInterfs2.GetAddress (1), 50000));


    ApplicationContainer sourceApps = source.Install (n0n1.Get (0));
    sourceApps.Start (Seconds (0.0));
    sourceApps.Stop (Seconds (97.0));

  //
  // Create a PacketSinkApplication and install it on node 1
  //
    PacketSinkHelper sink ("ns3::TcpSocketFactory",
                           InetSocketAddress (Ipv4Address::GetAny (), 50000));
    ApplicationContainer sinkApps = sink.Install (n2n3.Get (1));
    sinkApps.Start (Seconds (0.0));
    sinkApps.Stop (Seconds (100.0));


    p2p1.EnablePcap ("dev0",dev0);
    p2p1.EnablePcap ("dev1",dev1);
    p2p1.EnablePcap ("dev2",dev2);


    std::ofstream ascii;
    Ptr<OutputStreamWrapper> ascii_wrap;
    ascii.open ((prefix_file_name + "-ascii").c_str ());
    ascii_wrap = new OutputStreamWrapper ((prefix_file_name + "-ascii").c_str (),
                                          std::ios::out);
    internet.EnableAsciiIpv4All (ascii_wrap);

    Simulator::Schedule (Seconds (0.001), &TraceCwnd, prefix_file_name + "-cwnd.data");


    Simulator::Stop (Seconds (100.0));
    Simulator::Run ();




    Simulator::Destroy ();

return 0;
  }
