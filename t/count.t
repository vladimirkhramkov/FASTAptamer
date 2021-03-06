package test;
use 5.008;    # Require at least Perl version 5.8
use strict;   # Must declare all variables before using them
use warnings; # Emit helpful warnings
use autodie;  # Fatal exceptions for common unrecoverable errors (e.g. w/open)

# Testing-related modules
use Test::More;                  # provide testing functions (e.g. is, like)
use Data::Section -setup;        # Set up labeled DATA sections
use Path::Tiny;

{
    my $input_filename  = filename_for('input');
    my $output_filename = Path::Tiny->tempfile();
    system("./fastaptamer_count -i $input_filename -o $output_filename");
    my $result   = path($output_filename)->slurp;
    my $expected = string_from('expected');
    is( $result, $expected, 'successfully created count file' );
}

{
    my $input_filename  = filename_for('input_fasta');
    my $output_filename = Path::Tiny->tempfile();
    system("./fastaptamer_count -f -i $input_filename -o $output_filename");
    my $result   = path($output_filename)->slurp;
    my $expected = string_from('expected');
    is( $result, $expected, 'successfully created count file from FASTA input' );
}

{
    my $input_filename  = filename_for('input_fasta');
    my $output_filename = Path::Tiny->tempfile();
    system("./fastaptamer_count -i $input_filename -o $output_filename");
    my $result   = path($output_filename)->slurp;
    my $expected = string_from('expected');
    is( $result, $expected, 'FASTA file automatically detected' );
}

{
    my $input_filename  = filename_for('input_unique_IDs');
    my $output_filename = Path::Tiny->tempfile();
    system("./fastaptamer_count -u -i $input_filename -o $output_filename");
    my $result   = path($output_filename)->slurp;
    my $expected_A = string_from('expected_unique_IDs_A');
    my $expected_B = string_from('expected_unique_IDs_B');

    # Two possible results since the order of the result is hash-based and there are two possibilities
    ok( ($result eq $expected_A) || ($result eq $expected_B) , 'successfully created count file with unique sequence IDs' );
}

done_testing();

sub string_from {
    my $section = shift;

    #Get the scalar reference to the section text
    my $sref = test->section_data($section);

    #Return a string containing the entire section
    return ${$sref};
}

sub filename_for {
    my $section           = shift;
    my $string   = string_from($section);

    my $tempfile = Path::Tiny->tempfile();
    $tempfile->spew($string); 

    return $tempfile;
}

__DATA__
__[ input ]__
@
AAAAAAAAAAAAAAAAAA
+
@HHHH@HHHHHHHH@HHH
@B
AAAAAAAAAAAAAAAAAA
+
@HHHHHHHHHHHHHHHHH
@C
GAAAAAAAAAAAAAAAAA
+
HHHHHHHHHHHHHHHHHH
@D
GAAAAAAAAAAAAAAAAA
+
HHHHHHHHHHHHHHHHHH
@E
CCCCCCCCCAAAAAAAAA
+
HHHHHHHHHHHHHHHHHH
@F
AAAAAAAAAAAAAAAAAA
+
HHHHHHHHHHHHHHHHHH
__[ input_fasta ]__
>A
AAAAAAAAAAAAAAAAAA
>B
AAAAAAAAAAAAAAAAAA
>C
GAAAAAAAAAAAAAAAAA
>D
GAAAAAAAAAAAAAAAAA
>E
CCCCCCCCCAAAAAAAAA
>F
AAAAAAAAAAAAAAAAAA
__[ expected ]__
>1-3-500000.00
AAAAAAAAAAAAAAAAAA
>2-2-333333.33
GAAAAAAAAAAAAAAAAA
>3-1-166666.67
CCCCCCCCCAAAAAAAAA
__[ input_unique_IDs ]__
@
AAAAAAAAAAAAAAAAAA
+
@HHHH@HHHHHHHH@HHH
@B
AAAAAAAAAAAAAAAAAA
+
@HHHHHHHHHHHHHHHHH
@C
GAAAAAAAAAAAAAAAAA
+
HHHHHHHHHHHHHHHHHH
@D
GAAAAAAAAAAAAAAAAA
+
HHHHHHHHHHHHHHHHHH
@E
CCCCCCCCCAAAAAAAAA
+
HHHHHHHHHHHHHHHHHH
@F
AAAAAAAAAAAAAAAAAA
+
HHHHHHHHHHHHHHHHHH
@G
AAAAAAAAAGGGGGGGGG
+
HHHHHHHHHHHHHHHHHH
@
AAAAAAAAAAAAAAAAAA
+
@HHHH@HHHHHHHH@HHH
@
AAAAAAAAAAAAAAAAAA
+
@HHHH@HHHHHHHH@HHH
@
AAAAAAAAAAAAAAAAAA
+
@HHHH@HHHHHHHH@HHH
__[ expected_unique_IDs_A ]__
>1-6-600000.00
AAAAAAAAAAAAAAAAAA
>2-2-200000.00
GAAAAAAAAAAAAAAAAA
>3-1-100000.00
CCCCCCCCCAAAAAAAAA
>3(2)-1-100000.00
AAAAAAAAAGGGGGGGGG
__[ expected_unique_IDs_B ]__
>1-6-600000.00
AAAAAAAAAAAAAAAAAA
>2-2-200000.00
GAAAAAAAAAAAAAAAAA
>3-1-100000.00
AAAAAAAAAGGGGGGGGG
>3(2)-1-100000.00
CCCCCCCCCAAAAAAAAA
