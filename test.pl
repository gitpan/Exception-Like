
use Test::More tests => 10;

BEGIN { use_ok( 'Exception::LikeTest' ); }

$a = new Exception::LikeTest;

isa_ok($a,'Exception::LikeTest');

is($a->fails(), undef, 'Return value');

is($a->errno, MyException,'MyException');

$a->fails();

$a->fails();

is_deeply([$a->errnos], ['MyException','MyException','MyException'], 'errnos');

is_deeply($a->dump_err, [
          {
            'no' => 'MyException',
            'caller_stack' => [
                                [
                                  'Exception::LikeTest',
                                  'blib/lib/Exception/LikeTest.pm',
                                  19,
                                  'Exception::Like::err'
                                ],
                                [
                                  'main',
                                  'test.pl',
                                  10,
                                  'Exception::LikeTest::fails'
                                ]
                              ],
            'str' => 'just felt like erroring'
          },
          {
            'no' => 'MyException',
            'caller_stack' => [
                                [
                                  'Exception::LikeTest',
                                  'blib/lib/Exception/LikeTest.pm',
                                  19,
                                  'Exception::Like::err'
                                ],
                                [
                                  'main',
                                  'test.pl',
                                  14,
                                  'Exception::LikeTest::fails'
                                ]
                              ],
            'str' => 'just felt like erroring'
          },
          {
            'no' => 'MyException',
            'caller_stack' => [
                                [
                                  'Exception::LikeTest',
                                  'blib/lib/Exception/LikeTest.pm',
                                  19,
                                  'Exception::Like::err'
                                ],
                                [
                                  'main',
                                  'test.pl',
                                  16,
                                  'Exception::LikeTest::fails'
                                ]
                              ],
            'str' => 'just felt like erroring'
          }
        ],'dump_err');

is_deeply([$a->errno], ['MyException'], 'errno');
is_deeply([$a->errstr], ['MyException: This is my exception: just felt like erroring'], 'errstr');

is_deeply([$a->errstrs], [
          'MyException: This is my exception: just felt like erroring',
          'MyException: This is my exception: just felt like erroring',
          'MyException: This is my exception: just felt like erroring'
        ], 'errstrs');


$a->clear_err;

is_deeply($a->dump_err,[],'clear_err');





=head1 AUTHOR

Ziya Suzen <ziya@ripe.net>

=head1 SEE ALSO

perl(1).

=head1 COPYRIGHT

Copyright (c) 2002                                          RIPE NCC 

All Rights Reserved

Permission to use, copy, modify, and distribute this software and its
documentation for any purpose and without fee is hereby granted,
provided that the above copyright notice appear in all copies and that
both that copyright notice and this permission notice appear in
supporting documentation, and that the name of the author not be
used in advertising or publicity pertaining to distribution of the
software without specific, written prior permission.

THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING
ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS; IN NO EVENT SHALL
AUTHOR BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY
DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

=cut



####################
#$a->fails();
#
#$a->fails();
#
#our @EXPORT = qw(err errno errnos errstr errstrs dump_err clear_err);
#print "\n\n";
#use Data::Dumper;print Dumper([$a->errstr]);
#
#print "\n\n",$a->errstack(),"\n\n";
#
# print "$_\n" for Exception::Like->list_defined_exceptions();
