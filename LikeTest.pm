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


1;
