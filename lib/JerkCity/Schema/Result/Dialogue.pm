use utf8;
package JerkCity::Schema::Result::Dialogue;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

JerkCity::Schema::Result::Dialogue

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<dialogue>

=cut

__PACKAGE__->table("dialogues");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 comic_id

  data_type: 'integer'
  is_nullable: 1

=head2 speaker_id

  data_type: 'integer'
  is_nullable: 1

=head2 speech

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "comic_id",
  { data_type => "integer", is_nullable => 1 },
  "speaker_id",
  { data_type => "integer", is_nullable => 1 },
  "speech",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-07-08 16:41:57
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wnm1zPiws+Q7jfsNJ0YGLw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
