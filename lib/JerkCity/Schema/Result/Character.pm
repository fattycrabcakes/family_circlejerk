use utf8;
package JerkCity::Schema::Result::Character;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

JerkCity::Schema::Result::Speaker

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<speaker>

=cut

__PACKAGE__->table("characters");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'char'
  is_nullable: 1
  size: 128

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "char", is_nullable => 1, size => 128 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-07-08 16:41:57
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZQdVKlLqJ1kdi87tYnBEWQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
