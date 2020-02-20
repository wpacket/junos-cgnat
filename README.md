# PBA & junos-pba script : What is it ?
PBA stand for Port Block Allocation. It is a well-known method in Telco environments to map a subscriber's private IP address with a public address using source NAT & PAT while reducing large log storage that traditionnal firewall/NAT device generates. In a nutshell, subscriber get allocated a range of ports ( usually between 128 & 1024 ) with a public IP and a single log is generated for every session in this pool.

The junos-pba script will give you details about port-block allocation & subscribers port usage in a CGNAT/Juniper SRX environment where the PBA feature is used. It is a great source of information and will come in addition to the Junos CLI to make smart choices when sizing your IP pools & blocks.

## Explanation & Motivation
This script was originaly  written to understand how port block allocation was working on SRX5K/Junos and quickly became a source of precious information to better size and scale my configurations. It will give input such as block usage ( in % ) and how subscriber are using those blocks. In addition it will let you know if you are approaching the limit of your setup in term of port/block sizing.

## How does it work ?
You first need you to extract the port-block table from the SRX cluster on your primary node and save it in a file. This can be done using the following command in Junos. 
```
show security nat source port-block pool xxx node xxx | save table.txt
```
   
Once this is done you can  run the script using the file as an argument in shell. I personnaly tested it on WLS, Debian & Ubuntu and it worked like a charm. For instance: 
```
# junos-pba.sh table.txt

------------------------------------------
Subscriber statistics
------------------------------------------
Total Number of subscriber : 895712
------------------------------------------
Subscriber using 8 blocks : 239 (0%)
Subscriber using 7 blocks : 244 (0%)
Subscriber using 6 blocks : 1158 (0%)
Subscriber using 5 blocks : 8115 (0%)
Subscriber using 4 blocks : 37657 (4%)
Subscriber using 3 blocks : 110495 (12%)
Subscriber using 2 blocks : 286956 (32%)
Subscriber using 1 blocks : 450848 (50%)

------------------------------------------
Ports statistics
------------------------------------------
Total number of port allocated:5891304
Average number of port per subscriber:6

------------------------------------------
Block statistics
------------------------------------------
Total number of block allocated:1820770
Total number of possible block:8126464
Block usage:22%

-------------------------------
Top 10 Subscriber ( IP/N ports)
-------------------------------
100.64.144.32/2048
100.64.54.178/2048
100.64.18.23/2048
100.64.6.13/2048
100.64.14.50/2046
100.64.15.198/2045
100.64.82.110/2021
100.64.32.224/2019
100.64.177.141/1972
100.64.190.18/1968

------------------------------
Top 10 Subscriber using 8 blocks
------------------------------
100.64.144.32
100.64.54.178
100.64.18.23
100.64.6.13
100.64.14.50
100.64.15.198
100.64.82.110
100.64.32.224
100.64.177.141
100.64.190.18
....
```
