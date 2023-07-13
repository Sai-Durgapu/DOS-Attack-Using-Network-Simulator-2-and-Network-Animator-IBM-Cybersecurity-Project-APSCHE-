# Create a Simulator
set ns [new Simulator]
# Create a trace file
set tracefile [open udp.tr w]
$ns trace-all $tracefile
# NAM file creation
set namfile [open udp.nam w]
$ns namtrace-all $namfile

# Finish Procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam udp.nam &
    exit 0
}
#node creation
set n1 [$ns node]
set n2 [$ns node]

#connection
$ns duplex-link $n1 $n2 5Mb 2ms DropTail 

#agent creation
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp

set null [new Agent/Null]
$ns attach-agent $n2 $null

$ns connect $udp $null

#generate the traffic 
set cbrudp [new Application/Traffic/CBR]
$cbrudp attach-agent $udp

#start traffic
$ns at 0.1 "$cbrudp start"
$ns at 4.5 "$cbrudp stop"

$ns at 5.0 "finish"
$ns run

