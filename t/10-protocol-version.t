use v6;

use Test;
use IO::Socket::SSL;

plan 2;

my IO::Socket::SSL $ssl;

subtest {
    lives-ok { $ssl = IO::Socket::SSL.new(:host<www.parabon.com>, :port(443), :protocol-version(3)) };
    is $ssl.print("GET / HTTP/1.1\r\nHost:www.parabon.com\r\nConnection:close\r\n\r\n"), -1;
    $ssl.close;
}, 'parabon.com: !SSLv3';

subtest {
    lives-ok { $ssl = IO::Socket::SSL.new(:host<www.parabon.com>, :port(443), :protocol-version(1)) };
    is $ssl.print("GET / HTTP/1.1\r\nHost:www.parabon.com\r\nConnection:close\r\n\r\n"), 58;
    ok $ssl.get ~~ /\s3\d\d\s/|/\s2\d\d\s/;
    $ssl.close;
}, 'parabon.com: TLSv1';
