package Exception::Like;

require 5.005_62;
use strict;
use warnings;

require Exporter;
use AutoLoader qw(AUTOLOAD);

our @ISA = qw(Exporter);

our @EXPORT = qw(err errno errnos errstr errstrs dump_err clear_err errstack);

our $VERSION = '0.01';

my %_err_id;
my $_err = {};

my $_th = 1;

sub import {
  my $class = shift;

  # Export subs to level above
  Exporter::export_to_level($class, 1);

  @EXPORT = ();

  _add($class,
       TooManyParametersError=>'',
       UnexpectedParametersError=>'',
       StandardError=>'',
       ArithmeticError=>'',
       LookupError=>'',
       EnvironmentError=>'',
       AssertionError=>'',
       AttributeError=>'',
       EOFError=>'',
       FloatingPointError=>'',
       IOError=>'',
       ImportError=>'',
       IndexError=>'',
       KeyError=>'',
       KeyboardInterrupt=>'',
       MemoryError=>'',
       NameError=>'',
       NotImplementedError=>'',
       OSError=>'',
       OverflowError=>'',
       ReferenceError=>'',
       RuntimeError=>'',
       StopIteration=>'',
       SyntaxError=>'',
       SystemError=>'',
       SystemExit=>'',
       TypeError=>'',
       UnboundLocalError=>'',
       UnicodeError=>'',
       ValueError=>'',
       WindowsError=>'',
       ZeroDivisionError=>'',
       UserWarning=>'',
       DeprecationWarning=>'',
       SyntaxWarning=>'',
       RuntimeWarning=>'',
      );

  _add($class, @_);

  my $i;

  # Export Error IDs to all levels
  Exporter::export_to_level($class,$i) while(caller($i++));
}


sub _add {
  my $self = shift;
  my %arg = @_;

  for my $e (keys %arg) {
    no warnings;
    eval "use constant $e=>'$e';";
    $_err_id{$e} = $arg{$e};
    push @EXPORT, $e;
  }
}

sub err {
  my $err_id = shift;

  my ($i, $caller_stack);

  while (my @e = (caller($i++))[0..3]) {
    push @$caller_stack, \@e;
  }

  push @{$_err->{$_th}}, {
                          no=>  $err_id,
                          str=> "@_",
                          caller_stack=> $caller_stack,
                         };
  return;
}

sub errstr {
  return unless @{$_err->{$_th}};

  _raw2str($_err->{$_th}->[-1])
}

sub _raw2str {
  my $e = shift;

  no warnings;
  join ': '
    , $e->{no}
      , $_err_id{$e->{no}}
        , $e->{str}
}

sub _error_stack_raw2str {
  my $stack = shift;
  my $stack_str = '';

  for my $e (@$stack) {
    $stack_str .= (join ' ', @$e) . "\n";
  }

  $stack_str
}

sub dump_err { $_err->{$_th} }

sub errstrs {
  return unless @{$_err->{$_th}};

  my @error_stack;

  for my $e (@{$_err->{$_th}}) {
    push @error_stack, _raw2str($e)
  }

  @error_stack
}

sub clear_err { $_err->{$_th} = [] }

sub errno {
  return unless @{$_err->{$_th}};
  $_err->{$_th}->[-1]->{no}
}

sub errnos {
  return unless @{$_err->{$_th}};

  my @err_nos;

  push @err_nos, $_->{no} for @{$_err->{$_th}};
  @err_nos
}

sub errstack {
  return unless @{$_err->{$_th}};
  _error_stack_raw2str($_err->{$_th}->[-1]->{caller_stack})
}

sub list_defined_exceptions { keys %_err_id }

1;
__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

Exception::Like - Exception-like Error Checking

=head1 SYNOPSIS

  #Package file:
  package Exception::LikeTest;

  use Exception::Like MyException=>'This is my exception';

  use strict;
  use warnings;

  sub new {
    my $this = shift;
    my $class = ref($this) || $this;
    my $self = bless {}, $class;

    return $self;
  }

  sub fails {
    err(MyException,'just felt like erroring');
    return;
  }

  #Program file:
  use Exception::LikeTest;
  $a = new Exception::LikeTest;
  $r = $a->fails();

  unless ($r) {
    # Error ocured!
    if ($a->errno() eq MyException) {
      warn MyException, " occured.\n";
    }
    else {
      die $a->errstr();
    }
  }

  #To list all the defined Exceptions (or Error IDs)
  use Exception::Like;
  print "$_\n" for Exception::Like->list_defined_exceptions();

=head1 DESCRIPTION

Instead of using try-cacth method, this module relies on good old
return-value-check method. But gives its users the chance to
identify error types as in handling exceptions, and stacking errors.

=head1 METHODS

=item err(ErrorID,'Extra Description')

Used by the error reporting program or module,
to push an error into the error stack. Always returns undef.

=item errno() errnos()

Returns last occured ErrorID. errnos returns an array of error IDs from
the error stack.

=item errstr() errstrs()

Returns last occured Error String. errstrs returns an
array of error strings from the error stack.

=item dump_err()

Returns Error Stack data structure.

=item clear_err()

Clear the error stack.

=item errstack()

Returns last occured Error's Caller Stack with line breaks for easy reporting.

=item list_defined_exceptions()

Returns a list of all defined exceptions. Not exported.

=head2 EXPORT

err, errno, errnos, errstr, errstrs, dump_err, clear_err, errstack
are exported one level. All Error IDs Exported to all levels.

=head2 EXPORT WARNING

All Error IDs Exported to all levels by default.

=head1 AUTHOR

Ziya Suzen <ziya@ripe.net>

=head1 SEE ALSO

perl(1), Error, Exception::Class, Exception.

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

