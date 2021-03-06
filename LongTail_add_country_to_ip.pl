#!/usr/bin/perl
# SAMPLE INPUT
#    213 117.21.174.111
#   2801 119.147.84.181

sub init {
$DEBUG=0;
#	if ($0) {
#		print "DEBUG found an arg --> $0\n";
#	}
#	else {
#		print "DEBUG no arg found\n";
#	}

	open ("FILE", "/usr/local/etc/translate_country_codes")|| die "Can not open /usr/local/etc/translate_country_codes\nExiting now\n";
	while (<FILE>){
		chomp;
		$_ =~ s/  / /g;
		($code,$country)=split (/ /,$_,2);
		$country =~ s/ /_/g;
		$country_code{$code}=$country;
	}
	close (FILE);
if ($DEBUG){ print "Done loading /usr/local/etc/translate_country_codes\n";}

	open ("FILE", "/usr/local/etc/ip-to-country")|| die "Can not open /usr/local/etc/ip-to-country\nExiting now\n";
	while (<FILE>){
		chomp;
		$_ =~ s/  / /g;
		($ip,$country)=split (/ /,$_,2);
		$ip_to_country{$ip}=$country;
	}
	close (FILE);
if ($DEBUG){print "Done loading /usr/local/etc/ip-to-country\n";}

	open ("FILE", "/usr/local/etc/LongTail_sshPsycho_IP_addresses")|| die "Can not open /usr/local/etc/LongTail_sshPsycho_IP_addresses\nExiting now\n";
	while (<FILE>){
		chomp;
		$ssh_psycho{$_}=$_;
		($ip1,$ip2,$ip3,$ip4)=split(/\./,$_);
		if ( $ip4 eq ""){
			$counter=1;
			while ($counter <= 255){
				$tmp="$_.$counter";
				$ssh_psycho{$tmp}="$_.$counter";
				$counter++;
			}
		}
	}
	close (FILE);
if ($DEBUG){print "Done loading /usr/local/etc/LongTail_sshPsycho_IP_addresses\n";}

	open ("FILE", "/usr/local/etc/LongTail_sshPsycho_2_IP_addresses")|| die "Can not open /usr/local/etc/LongTail_sshPsycho_IP_addresses\nExiting now\n";
	while (<FILE>){
		chomp;
		$ssh_psycho2{$_}=$_;
		($ip1,$ip2,$ip3,$ip4)=split(/\./,$_);
		if ( $ip4 eq ""){
			$counter=1;
			while ($counter <= 255){
				$tmp="$_.$counter";
				$ssh_psycho2{$tmp}="$_.$counter";
				$counter++;
			}
		}
	}
	close (FILE);
if ($DEBUG){print "Done loading /usr/local/etc/LongTail_sshPsycho_2_IP_addresses\n";}

	open ("FILE", "/usr/local/etc/LongTail_friends_of_sshPsycho_IP_addresses")|| die "Can not open /usr/local/etc/LongTail_friends_of_sshPsycho_IP_addresses\nExiting now\n";
	while (<FILE>){
		chomp;
		$ssh_psycho_friends{$_}=$_;
		($ip1,$ip2,$ip3,$ip4)=split(/\./,$_);
		if ( $ip4 eq ""){
			$counter=1;
			while ($counter <= 255){
				$tmp="$_.$counter";
				$ssh_psycho_friends{$tmp}="$_.$counter";
				$counter++;
			}
		}
	}
	close (FILE);
if ($DEBUG){print "Done loading /usr/local/etc/LongTail_friends_of_sshPsycho_IP_addresses\n";}

	open ("FILE", "/usr/local/etc/LongTail_associates_of_sshPsycho_IP_addresses")|| die "Can not open /usr/local/etc/LongTail_associates_of_sshPsycho_IP_addresses\nExiting now\n";
	while (<FILE>){
		chomp;
		$ssh_psycho_associates{$_}=$_;
		($ip1,$ip2,$ip3,$ip4)=split(/\./,$_);
		if ( $ip4 eq ""){
			$counter=1;
			while ($counter <= 255){
				$tmp="$_.$counter";
				$ssh_psycho_associates{$tmp}="$_.$counter";
				$counter++;
			}
		}
	}
	close (FILE);
if ($DEBUG){print "Done loading /usr/local/etc/LongTail_associates_of_sshPsycho_IP_addresses\n";}

	if ( -d "/usr/local/etc/LongTail_botnets"){
			open (FIND, "find /usr/local/etc/LongTail_botnets -type f -print|sort |") || die "Can not run find command\n";
			while (<FIND>){
				chomp;
				if (/.sh$/){next;}
				if (/.pl$/){next;}
				if (/.html/){next;}
				if (/.shtml/){next;}
				if (/\.201\d\./){next;}
				if (/\.202\d\./){next;}
				if (/backups/){next;}
				if (/sshPsycho/){next;}
				$filename=$_;
				$botnet_name=`basename $filename`;
				chomp $botnet_name;
				open (FILE, "$_");
				while (<FILE>){
					chomp;
					$ip=$_;
					if (/\.\.\./){next;}
					#if ($ssh_psycho_friends{$ip} ){ $tag="sshPsycho_Friend"; }
					$botnets{$ip}=$botnet_name;
				}
				close (FILE);
			}
			close (FIND);
		}
		if ($DEBUG){print "Done loading /usr/local/etc/LongTail_botnets\n";}
}
# <A HREF="/honey/ip_attacks.shtml#109.161.137.122">109.161.137.122</A> 

$DEBUG=0;
&init;
if ($DEBUG > 0 ) {print "DEBUG back from init\n";}
while (<>){
	chomp;
	# Sometimes I feed bad data, more than three fields and it breaks things
	# So I have to account for extra fields which get slammed into $more_trash
	# and then delete the extra crap.
	($trash,$count,$ip,$more_trash)=split (/\s+/,$_,4);
	$_ ="$trash $count $ip";
	# If there's only one field I assume it's an IP address
	if ( ($count eq "") && ($ip eq "") ) {
		#print "DEBUG Only one field, must be ip\n";
		$ip = $trash;
	}
	if (defined($ip_to_country{$ip})){
		$tmp_country_code=$ip_to_country{$ip};
	}
	else {
		if ($ip =~ /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/){
			#print (STDERR "ip is $ip\n");
			$tmp_country_code=`/usr/local/etc/whois.pl $ip`;
			chomp $tmp_country_code;
			($trash,$country)=split(/ /,$tmp_country_code);
		}
	}
	$tmp_country_code=~ tr/A-Z/a-z/;
	$_ =~ s/$ip/$ip $country_code{$tmp_country_code}/;
	$tag="";
	if ($ssh_psycho{$ip} ){ $tag="sshPsycho"; }
	if ($ssh_psycho2{$ip} ){ $tag="sshPsycho-2"; }
	if ($ssh_psycho_associates{$ip} ){ $tag="sshPsycho_Associate"; }
	if ($ssh_psycho_friends{$ip} ){ $tag="sshPsycho_Friend"; }
	if ($botnets{$ip}) { $tag=$botnets{$ip};}
	if ($tag ne ""){
		print "$_($tag)\n";
	}
	else {
		print "$_\n";
	}
}

