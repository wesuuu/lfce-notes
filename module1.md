# Managing Networking Basics

## Network administration

### Managing network configurations with ifconfig or ip

*Linux network interfaces*

See network interfaces with `ip link`. Status of hardware

Will show whether they are active `UP` or inactive `DOWN`

`LOWER_UP` means not only does that kernel thinks it's up, it's up at the electrical level as there's a pulse there

Can see the ethernet MAC address after `link/ether`

*Using the IP command*

use ip command

```bash
ip help # get help

ip address show # show ip address info
```

Add an IP address:

1. specify a network interface
2. ip address to add
3. the subnet mask (i.e. /24)

Adding an IP address like this is runtime only

`ip addr add dev ens33 192.16.4.100/24`

### Managing persistent network connections

To do this, you must have a static IP setup with a separate network interface, not sure why.

Use `nmtui`

1. Find your gateway address with `ip route`
2. Find your nameserver, located at `/etc/resolv.conf`
3. use `nmtui` and edit your connection
4. specify the ip address to add to the network interface
5. specify the gateway
6. specify the nameserver
7. save it
8. deactivate and activate nmtui

### Configuring static routing

Default route is the route that typically takes you to the internet. It'll forward packets to the default router.

To go to other networks, it just needs to know the router of the other network

```
172.16.0.0 via 10.0.0.2 # router is 10.0.0.2
```

Knowlege about routing table is either present inside default router or machine. Typically its on the router

You can configure the routing table either with static or dynamic routing

In static routing, you're typing in routes yourself

In dynamic routing, you're using a routing protocol that'll figure it out for you

You can deal with routers 2 ways:

1. Infrastructure cisco router with knowledge about all other routers
2. Some organizations use linux as a router

#### Setup static routing

1. configuration data stored at /etc/sysconfig/network-scripts. configuration files are prefixed with `ifcfg-` and the network interface

```bash
# typical file inside network-scripts
NM_CONTROLLED=yes
BOOTPROTO=none
ONBOOT=yes
IPADDR=172.42.42.100
NETMASK=255.255.255.0
DEVICE=eth1
PEERDNS=no
```

2. You can also simply specify it like the following:
`172.42.42.101/24 via <ROUTER_IP> dev eth1 #dev = device`

3. Restart your network afterwards with `systemctl restart network`

```bash
# how ifcfg file looks like with 2 IP addresses
NM_CONTROLLED=yes
BOOTPROTO=none
ONBOOT=yes
IPADDR=172.42.42.100
NETMASK=255.255.255.0
DEVICE=eth1
PEERDNS=no
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
PREFIX=24
IPADDR1=172.42.42.101
PREFIX1=24
NETMASK1=255.255.255.0
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=no
NAME="System eth1"
UUID=9c92fad9-6ecb-3e6c-eb4d-8a47c6f50c04
```

### Configuring dynamic routing

TODO come back to this topic, it's highly dense and confusing

### Configuring generic network security

#### TCP wrappers

Basic network security

Access is controlled through `/etc/hosts.allow` and `/etc/hosts.deny`

ONLY respected by services that use libwrap as well as inetd

if pattern is not defined in any of the files, traffic will be permitted

```bash
# example hosts.allow
vsftpd: ALL
ALL: LOCAL
ALL: 172. EXCEPT .somewhere.com # allow all access from IPs starting from 172, deny from somewhere.com
```

```bash
# example hosts.deny
ALL: ALL
```

### Network troubleshooting tools

Common tools include: 

#### ping

`ping`: see if a server is online and receiving packets via ICMP. `icmp_seq` is the total packets sent, useful to see if there's any packets have been lost in transit. `ttl` is distance measured in routers. The `time` attribute will give you an idea about latency.

`ping -f` will give you a ping flood, useful for load testing a system
`ping -s 4096` will send 4096 packets to destination server

#### traceroute

`traceroute`: See how routing is occuring over the network.

`* * *` is indicated by hidden routers 

#### nmap

`nmap`: port scanner, can detect activity on specific ports

`nmap 192.168.0.1` will show you open ports on machine 192.168.0.1. Just scanning most common ports, not a deep scan of all ports

`nmap -sn 192.168.0.1/24` will scan an entire network

#### arp

`arp`: IP address to MAC address resolution

#### telnet

`telnet`: test connectivity to a simple port. Will need to tell telnet what protocol to use

`telnet www.google.com 80` will fail since you haven't specified the protocol. Add GET after

#### openssl

`openssl s_client -connect example.com:443`: will test if ssl is active

#### tcpdump

`tcpdump`: capture packets moving over a network interface.

`tcpdump -i ens33` will dump all packets over interface ens33

`tcpdump -i ens33 -w capture` will write to file capture

#### ss

`ss`: see ports that are open on your machine

`ss -tua` will show you socket statistics

# Network Monitoring & Reporting

## Monitoring network performance

Tools available

`ip link -s`: see success/failure of packets sent over the network.

RX packets are received packets. TX packets are transmitted packets

`ethtool -S eth0`: parameters and properties of network interfaces. Like `ss` but on steroids. Will show very detailed information about what's happening to the packets on your network

`iptraf`: real time insight about IP traffic. Proivdes an interface for overviewing what's happening over the network

`ntop`: reporting about what's going on in your machine. Only available on ubuntu. Starts a webserver that gives you data about what's going on in the machine

## Understanding network performance

Center of everything is the NIC. Packets come in and out of the NIC. 

To help optimize the traffic, you can modify the MTU (maximum transmission unit)

Packets will flow from the MTU to RAM. RAM contains TCP/UDP buffers to hold packets.

Windows define how fast packets can be transmitted to RAM buffers

From RAM, packets are processed by the CPU on the system. 

To get optimal network configuration, analyze entire stack. If CPU is busy, packets won't be processed efficiently.

There may be processors available directly on the NIC (offload engines).

## Managing /proc network parameters

`sysctl -a` can show you all the parameters that can be modified/tuned on your system

Parameters related to networking reside in `/proc/sys/net`

`core` contains parameters related to everything on the network

`ipv4` to ipv4 only. `tcp_keepalive_time` to ensure tcp connections are kept alive for as long as possible. `tcp_mem` is the amount of memory reserved for tcp connections

To find the meaning of different parameters, start with

`yum search kernel | grep doc` to install kernel documentation. It's located under `/usr/share/doc/kernel-doc-<numeric>`. Do `grep -Rl to find specific file on parameter

Important `/proc` network parameters below:

`net.core.[rw]mem_default` and `net.core.[rw]mem_max` max amount of memory reserved for reading and writing

`net.ipv4.dsack` network traffic will be ackowledged in an efficient way. If a packet gets lost

`net.ipv4.keepalive*`. How long before a session is terminated

`net.ipv4.{tcp_mem|tcp_rmem|tcp_wmem}` memory reserved for tcp writing/reading

`net.ipv4.{udp_mem|udp_rmem_min|udp_wmem_min}` memory reserved for udp writing/reading

## Producing system reports using sar

system activity reporting.

`dnf install sysstat` to install

configuration under `/etc/cron.d/sysstat`. 2 files for data gathering `/usr/lib64/sa/sa1` short-term data gathering and `/usr/lib64/sa/sa2` long-term once a day

data is logged to `/var/log/sa`

use sar command to read this effectively

`sar -n ALL` shows information about what's going on on every network card.

sar shows long term trending to see when you experience peak performance.

## Using ss to monitor network service availability

`ss` stands for socket statistics

`ss` will dump all socket information

`ss -tu` will dump what's happening over tcp

`ss -tua` will display listening sockets

`ss -tuna` will not translate ports into names

`ss -ltn` will show just the listening ports

`ss -latp` will show listening processes as well as portocols

`ss -s` statistics summary

filter with `ss -at '( dport = :ssh or sport -= :ssh )'`. 
This will show all information about ssh

## Using nmap to verify remote port availability

`nmap -sn 192.168.4.0/24` all nodes on the network

`nmap 192.168.4.0` will list information about this IP. If it takes awhile, a firewall might be involved.

`nmap -O 192.168.4.0` will attempt to discover the OS on the target machine

`nmap -sS -sU -Pn 192.168.4.0` udp and tcp scan to find what is open and closed.

`nmap -sS -sU -Pn -o 1-65545 192.168.4.0` will scan that port range

`nmap -sA 192.168.4.0` will yield firewall information

