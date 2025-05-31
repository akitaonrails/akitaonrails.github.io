#!/usr/bin/env perl 
use strict;
use warnings;
use File::Spec;
use Cwd 'abs_path';

sub main {
    my ($base_dir, $dry_run) = @_;
    $base_dir = abs_path($base_dir // '.');

    my @files = collect_markdown_files($base_dir);

    for my $file (@files) {
        my $content = read_file($file);
        next unless defined $content;

        my ($new_content, $count) = convert_content($content);

        if ($count > 0) {
            print "[", $dry_run ? "DRY RUN" : "APPLY", "] Converting $count embed(s) in $file\n";

            if ($dry_run) {
                print_preview($content, $new_content);
            } else {
                write_file($file, $new_content) or warn "Failed to save $file\n";
            }
        }
    }
}

sub collect_markdown_files {
    my ($dir) = @_;
    my @result;

    opendir(my $dh, $dir) or do {
        warn "Could not open directory $dir: $!";
        return ();
    };

    while (my $entry = readdir($dh)) {
        next if $entry =~ /^\.\.?$/;
        my $path = File::Spec->catfile($dir, $entry);

        if (-d $path) {
            push @result, collect_markdown_files($path);
        }
        elsif (-f $path && $path =~ /\.md$/i) {
            push @result, $path;
        }
    }

    closedir($dh);
    return @result;
}

sub convert_content {
    my ($content) = @_;
    my $count = 0;

    # Convert \_ to _
    my $slash_underscore_count = ($content =~ s{\\_}{_}g);
    $count += $slash_underscore_count;
    
    # Convert \* to *
    my $slash_pointers_count = ($content =~ s{\\\*}{*}g);
    $count += $slash_pointers_count;
    
    # Convert iframe to {{ <youtube> }} to standalize
    my $modified = $content =~ s{
        <iframe[^>]*src=["']https?://(?:www\.)?youtube\.com/embed/([^?"']+)(?:\?([^"']*))?["'][^>]*>\s*</iframe>
    }{
        my $id = $1;
        $count++;
        "{{< youtube id=\"$id\" >}}"
    }egix ? $content : undef;


    return ($content, $count);
}



sub read_file {
    my ($path) = @_;
    open my $fh, '<', $path or do {
        warn "Could not open $path: $!";
        return undef;
    };
    local $/;
    my $content = <$fh>;
    close $fh;
    return $content;
}

sub write_file {
    my ($path, $content) = @_;
    open my $fh, '>', $path or do {
        warn "Could not save $path: $!";
        return 0;
    };
    print $fh $content;
    close $fh;
    return 1;
}

# Print side-by-side preview, simple diff-style highlight
sub print_preview {
    my ($old, $new) = @_;

    my @old_lines = split /\n/, $old;
    my @new_lines = split /\n/, $new;

    print "--- Before -------------------\n";
    print join("\n", map { length($_) > 80 ? substr($_,0,77)."..." : $_ } @old_lines);
    print "\n--- After --------------------\n";
    print join("\n", map { length($_) > 80 ? substr($_,0,77)."..." : $_ } @new_lines);
    print "\n------------------------------\n\n";
}

my $dry_run = 0;
my $dir = '.';

for my $arg (@ARGV) {
    if ($arg eq '--dry-run') {
        $dry_run = 1;
    } else {
        $dir = $arg;
    }
}

main($dir, $dry_run);
