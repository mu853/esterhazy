#!/usr/bin/env perl
use strict;
use warnings;
use Time::Piece;
use Net::FTP;

my @months = qw(Jan Feb Mar Apl May Jun Jul Aug Sep Oct Nov Dec);
Time::Piece::mon_list(@months);

sub getdate {
    my $datestr = shift;
    my $format1 = shift;
    my $format2 = shift;

    if($datestr =~ /:/){
        $datestr .= " ".localtime->year;
        return Time::Piece->strptime($datestr, $format1);
    }
    return Time::Piece->strptime($datestr, $format2);
}

my $local  = shift;
my $remote = shift;

my %local_files  = ();
my %remote_files = ();

###############################
## get local files
###############################
open(IN, $local) or die "$local not found.";
while(<IN>){
    chomp;
    my @F = split(/\s+/);
    my $datestr = join(" ", @F[5..7]);
    my $filename = $F[8];
    
    my $t = getdate($datestr, "%m %d %R %Y", "%m %d %Y");
    #print $t->strftime("l: %Y/%m/%d %H:%M:%S"), "\n";

    $local_files{$filename} = $t;
}
close(IN);

###############################
## get remote files
###############################
open(IN, $remote) or die "$remote not found.";
while(<IN>){
    chomp;
    my @F = split(/\s+/);
    my $datestr = join(" ", @F[5..7]);
    my $filename = $F[8];
    
    my $t = getdate($datestr, "%b %d %R %Y", "%b %d %Y");
    #print $t->strftime("r: %Y/%m/%d %H:%M:%S"), "\n";

    $remote_files{$filename} = $t;
}
close(IN);

###############################
## diff timestamp and upload
###############################
my @files_modified = ();

foreach my $filename (keys %local_files){
    unless(exists($remote_files{$filename})){
        print "$filename is only at local\n";
        push @files_modified, $filename;
        next;
    }

    my $rt = $remote_files{$filename};
    my $lt = $local_files{$filename};

    #print "$filename: $lt: $rt\n";
    if($lt > $rt){
        print "$filename is new at local\n";
        push @files_modified, $filename;
    }
}

my @files_delete = ();

foreach my $filename (keys %remote_files){
    unless(exists($local_files{$filename})){
        print "$filename is only at remote\n";
        push @files_delete, $filename;
    }
}

my $ftpserver = "esterhazy.web.fc2.com";
my $ftp = Net::FTP->new($ftpserver, Debug => 0);

$ftp->login or die "cannot login to $ftpserver.";    # use ~/.netrc
$ftp->cwd("ester") or die "cannot cd ester";

foreach my $filename (@files_modified){
    print "uploading.. $filename\n";
    if($ftp->put($filename)){
        print "OK\n";
    }else{
        print "NG!\n";
    }
}

foreach my $filename (@files_delete){
    print "deleting.. $filename\n";
    if($ftp->delele($filename)){
        print "OK\n";
    }else{
        print "NG!\n";
    }
}

$ftp->quit;

