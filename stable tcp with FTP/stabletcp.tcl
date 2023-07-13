# Create a Simulator
set ns [new Simulator]

# Create a Trace file
set tracefile [open tcp.tr w]
$ns trace-all $tracefile

# NAM file creation
set namfile [open tcp.nam w]
$ns namtrace-all $namfile

# Finish Procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam tcp.nam &
    exit 0
}
#node creation
set n1 [$ns node]
set n2 [$ns node]

#connection
$ns duplex-link $n1 $n2 5Mb 2ms DropTail 

#agent creation
set tcp [new Agent/TCP]
$tcp set class_ 2
$ns attach-agent $n1 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n2 $sink

$ns connect $tcp $sink

#generate the traffic 
set ftptcp [new Application/FTP]
$ftptcp attach-agent $tcp
$ftptcp set type_ FTP
$ftptcp set packet_size_ 1000
$ftptcp set rate_ 1Mb

#start traffic
$ns at 0.1 "$ftptcp start"
$ns at 4.5 "$ftptcp stop"

$ns at 5.0 "finish"
$ns run

