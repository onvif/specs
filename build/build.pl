#!/usr/bin/perl
#
# Script to generate ONVIF Technical Specifications
#
# Apache FOP to be downloaded from https://xmlgraphics.apache.org/fop/ and copied into subfolder fop.
#
use File::Basename;
use File::Path;
chdir(dirname(__FILE__));
chdir('..');		# goto root folder
my $version = '2006';
my $filter;
if ($#ARGV >= 0) { $filter = $ARGV[0]; }

if (not $filter ) { rmtree('out'); }
mkdir 'out';

open my $index, '>', "out/index.html";
print $index "<html><body><ul>\n";

sub toPdf
{
	my ($name, $outname) = @_;
#
#
	my $xversion;
	open my $file, "doc/$name.xml" or die;
	while (my $line = <$file>) {
		if ($line =~ /<releaseinfo>(\d\d).(\d\d)<\/releaseinfo>/) {
			$xversion = $1.$2;
#			print "$filter => $name, $xversion $folder\n";
			last;
		}
		# old style 2.x version numbers
		if ($line =~ /<releaseinfo>(\d).(\d+)<\/releaseinfo>/) {
			$xversion = $1.$2;
			if ($2 < 10) { $xversion = $1.$2.'0'; }
#			print "$filter => $name, $xversion $folder\n";
			last;
		}
	}
	close $file;
	if ($filter && ($xversion ne $filter && $name ne $filter)) { return; }
	my $folder = $xversion;
	print "\n\n$name\n";
	if (not -e 'out/'.$folder) { mkdir 'out/'.$folder; }
#
# Suppress INFO and event messages
#
	my $filename = "$folder/ONVIF-$outname-Spec-v$xversion.pdf";
	#open my $fop, '-|', "build/fop/fop -c build/fop.xconf -xml doc/$name.xml -xsl build/xsl/onvif-fo.xsl -pdf out/$filename 2>&1" or die $!;
	open my $fop, '-|', "/usr/local/fop-2.9/fop/fop -c build/fop.xconf -xml doc/$name.xml -xsl build/xsl/onvif-fo.xsl -pdf out/$filename 2>&1" or die $!;
	while (my $line = <$fop>) {
		if (not ($line=~/(processEvent)|(^INFO)|(org.apache.fop.apps.FopConfParser configure)|(checkTTC)|(getTTCnames)/)) {
			print $line;
		}
	}
	print $index "<li><a href='$filename'>$name</a> Version $xversion</li>\n";
	
}

my %nosrv = (
	'Core' => 1,
	'Streaming' => '1',
	'ExportFileFormat' => '1',
	'MediaSigning' => '1',
	'SecurityBaseline' => '1',
	'Uplink' => '1',
	'WebRTC' => 1,
);

my @files = <doc/*.xml>;
foreach my $file (@files) {
	$file =~ s|doc\/||;
	$file =~ s|\.xml$||;
	if ($nosrv{$file}) { toPdf($file, $file); }
	else { toPdf($file, $file.'-Service'); }
}

print $index "</ul></body></html>";
close $index;
