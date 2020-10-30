# Managing Networking Basics

## Network administration

### Managing network configurations with ifconfig or ip

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


