use strict;
use warnings;
my $dir = '/tmp/mp3/playlists/*.m3u';
#Find playlist files which end in .m3u 
my @files = glob( $dir ) or die "$!";
#Looping through each playlist file (.m3u)
foreach (@files){
    print $_ . "\n\n";
    open(my $fh,"<",$_) or die "Couldn't open playlist file: '$_'";
    my @songs;
    my $oldpath;
    #Looping to get the old path of the songs from the playlist file
    while(<$fh>){
        chomp $_;
        $_ =~ s/cd-lib/tmp/g;
        $_ =~ s/LittleFeat/LittleFeet/g;
        ($oldpath) = $_ =~ m/^\/(.+\/)*/;
        push(@songs,$_);
        }
	close $fh;
   	#Transforming old playlist path and file to new playlist path and file and also converting song paths to new path.
    print "Old Path: $oldpath\n";
    my $dummypath = $oldpath;
    $dummypath =~ s/tmp\/mp3/music/g;
    my $dummy = "files/";
    my $newdirectory = join "",$dummypath,$dummy;
	print "New Directory Path: $newdirectory\n";
    use File::Path qw(make_path);
    unless(-e $newdirectory or make_path("$newdirectory")){
        die "Couldn't create directory.\n";
        }  
	my ($playlistname) = $oldpath =~ /([^\/]*)\/[^\/]*$/;
	my ($playlistpath) = ($newdirectory =~ /.+?(?=$playlistname)/g);        
	my $playlist = join "",$playlistpath,$playlistname,".m3u";
	print "Playlist new Directory: $playlist\n";
	open(my $fd, '>', $playlist);
	my $songname;
	#Moving song files to new directory and writing it to its correspoinding playlist file (path of songs)
	print "================Songs====================\n";
	foreach (@songs){  		
		($songname) = $_ =~ /[\w-]+\.mp3/g;		
		use File::Copy qw(mv);
        if(mv("$_","$newdirectory")) 
			{
			my $songpath = join "",,"./files/",$songname;
			print $fd "$songpath\n";
			print "$songname added to playlist.\n";
			}
		else
			{
			print "$songname not in files, will not be added to playlist.\n";
			}
        }
    print "=========================================\n";
	close $fd;
	print "\n\n";
    }
