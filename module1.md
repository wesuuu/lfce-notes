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

