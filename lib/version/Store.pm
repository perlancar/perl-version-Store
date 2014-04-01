package version::Store;

use 5.010001;
use strict 'vars';
use warnings;

# VERSION

sub import {
    my $pkg = shift;
    my $caller = caller;
    *{"$caller\::VERSION"} = \&VERSION;
}

sub VERSION {
    require version;

    my ($pkg, $ver) = @_;
    my $caller = caller;
    my $pkg_ver = ${"$pkg\::VERSION"};
    if (!defined $pkg_ver) {
        die "$pkg does not define \$VERSION, $caller wants >= $ver";
    } elsif (version->parse($pkg_ver) < version->parse($ver)) {
        die "$pkg's VERSION is only $pkg_ver, caller wants >= $ver";
    }
    ${"$pkg\::USER_PACKAGES"}{$caller}{version} = $ver;
}

1;
# ABSTRACT: Get your module's minimum/required version from your users

=for Pod::Coverage ^(VERSION)$

=head1 SYNOPSIS

In your module:

 package YourModule;
 our $VERSION = 0.12;

 use version::Store;
 our %USER_PACKAGES;

 use Exporter;
 our @ISA = qw(Exporter);
 our @EXPORT = qw(foo);

 sub foo {
     my $caller = caller;
     my $min_ver = $USER_PACKAGES{$caller}{min_ver};
     print "foo" . ($min_ver && $min_ver >= 0.11 ? " with extra zazz!" : "");
 }

In code using your module:

 use YourModule;
 foo(); # prints "foo";

In another code:

 use YourModule 0.12;
 foo(); # prints "foo with extra zazz!"


=head1 DESCRIPTION

Sometimes you want to present different features to each user, depending on what
version of your module she requests.

This pragma lets you do that. This is done by installing a C<VERSION()>
subroutine to your module. This subroutine is called by Perl whenever a user
does something like C<use YourModule 0.12> (the C<use MODULE VERSION> form). The
version information is stored in your module's C<%USER_PACKAGES> package
variable, with each calling package as the key and a hashref for each value.
Each hashref contains the key C<version> containing the data.

Alternatively, you can write your own C<VERSION()> when appropriate.


=head1 SEE ALSO

C<use> on L<perldoc>.
