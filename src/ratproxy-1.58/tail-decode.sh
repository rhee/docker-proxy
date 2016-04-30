:

### Log item example:
###
###  0: 0
###  1: 5
###  2: All POST requests
###  3: -
###  4: 200
###  5: 927
###  6: text/html
###  7: application/x-javascript
###  8: UTF-8
###  9: traces/5513dac5-5904.trace
### 10: POST
### 11: https://sometalk.appex.co.kr:443/randomchat/api/?n=46174&p=randomchat&v=10200
### 12: -
### 13: {&#x22;d&#x22;:{&#x22;no_user&#x22;:&#x22;46174&#x22;,&#x22;no_from&#x22;:&#x22;46174&#x22;},&#x22;m&#x22;:&#x22;getprofile&#x22;}
### 14: {&#x22;r&#x22;:&#x22;0&#x22;,&#x22;d&#x22;:{&#x22;no_user&#x22;:&#x22;46174&#x22;,&#x22;userid&#x22;:&#x22;A0000028454E77_randomchat&#x22;,&#x22;nick&#x22;:&#x22;\uc90c\ub9c8\u201c&\/@@&#x22;,&#x22;nick_change&#x22;:&#x22;1427170945&#x22;,&#x22;memo&#x22;:&#x22;&#x22;,&#x22;memofiletype&#x22;:&#x22;&#x22;,&#x22;memofile&#x22;:&#x22;&#x22;,&#x22;memochange&#x22;:&#x22;0&#x22;,&#x22;memo2&#x22;:&#x22;&#x22;,&#x22;sex&#x22;:&#x22;\uc5ec\uc790&#x22;,&#x22;sexchange&#x22;:&#x22;0&#x22;,&#x22;age&#x22;:&#x22;49&#x22;,&#x22;agechange&#x22;:&#x22;0&#x22;,&#x22;imgfile&#x22;:&#x22;&#x22;,&#x22;imgfile_big&#x22;:&#x22;&#x22;,&#x22;no_img&#x22;:&#x22;0&#x22;,&#x22;heart&#x22;:&#x22;18&#x22;,&#x22;visit&#x22;:&#x22;145&#x22;,&#x22;lat&#x22;:&#x22;37.4828077&#x22;,&#x22;lng&#x22;:&#x22;126.898051&#x22;,&#x22;geohash&#x22;:&#x22;wydjpxs34vuc&#x22;,&#x22;accuracy&#x22;:&#x22;14&#x22;,&#x22;device&#x22;:&#x22;android&#x22;,&#x22;gcm&#x22;:&#x22;APA91bHWcuux5T275xuYtAb4YVFMsRAbdotzBH9hRlb_ehfwJzfR9RvQ0KnONw7pHvDdBeEyMmR0h0qpk...


LOGDIR=/opt/proxy/var/log/ratproxy

tail -F "$LOGDIR"/log.txt |perl -e '
#use strict;
use warnings;

binmode(STDOUT, qw/:utf8/);
$|=1;
$trprev="";
while ( <STDIN> ) {
    chomp;
    @cols = split(/\|/);
    $trace = $cols[9];
    if($trace ne $trprev){
        $cols[13] =~ s/\&#x([0-9a-f]{2});/chr(hex($1))/eg;
        $cols[13] =~ s/\\u([0-9a-fA-F]{4})/chr(hex($1))/eg;
        $cols[13] =~ s#\//#/#g;
        $cols[14] =~ s/\&#x([0-9a-f]{2});/chr(hex($1))/eg;
        $cols[14] =~ s/\\u([0-9a-fA-F]{4})/chr(hex($1))/eg;
        $cols[14] =~ s#\//#/#g;
        print "HTTP REQ: ",join(qw/|/,@cols[10,11,13]),"\n";
        print "HTTP RES: ",join(qw/|/,@cols[4,5,7,14]),"\n";
        $trprev = $trace;
    }
}
'
