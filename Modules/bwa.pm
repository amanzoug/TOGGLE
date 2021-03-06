package bwa;



###################################################################################################################################
#
# Copyright 2014 IRD-CIRAD
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/> or
# write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301, USA.
#
# You should have received a copy of the CeCILL-C license with this program.
#If not see <http://www.cecill.info/licences/Licence_CeCILL-C_V1-en.txt>
#
# Intellectual property belongs to IRD, CIRAD and South Green developpement plateform
# Written by Cecile Monat, Christine Tranchant, Ayite Kougbeadjo, Cedric Farcy, Mawusse Agbessi, Marilyne Summo, and Francois Sabot
#
###################################################################################################################################



use strict;
use warnings;
use lib qw(.);
use localConfig;
use toolbox;
use Data::Dumper;



##BWA INDEX
#Index database sequences in the FASTA format.
sub bwaIndex
{
    my($refFastaFileIn,$optionsHachees)=@_;
    if (toolbox::sizeFile($refFastaFileIn)==1)		##Check if the reference file exist and is not empty
    {
        my $options=toolbox::extractOptions($optionsHachees, " ");		##Get given options
        my $command=$bwa." index ".$options." ".$refFastaFileIn;		##command
        #Execute command
        if(toolbox::run($command)==1)		##The command should be executed correctly (ie return) before exporting the log
	{
            toolbox::exportLog("INFOS: bwa::bwaIndex : correctly done\n",1);		# bwaIndex have been correctly done
            return 1;
        }
        else
        {
            toolbox::exportLog("ERROR: bwa::bwaIndex : ABORTED\n",0);		# bwaIndex have not been correctly done
            return 0;
        }
    }
    else
    {
        toolbox::exportLog("ERROR: bwa::bwaIndex : Problem with the file $refFastaFileIn\n",0);		# bwaIndex can not function because of wrong/missing reference file
        return 0;
    }
}
##BWA ALN
#Find the SA coordinates of the input reads.
sub bwaAln
{
    my($refFastaFileIn,$FastqFileIn,$saiFileOut,$optionsHachees)=@_;
    if ((toolbox::sizeFile($refFastaFileIn)==1) and (toolbox::sizeFile($FastqFileIn)==1))		##Check if entry files exist and are not empty
    {
        my $options="";
        if ($optionsHachees)
	{
            $options=toolbox::extractOptions($optionsHachees);		##Get given options
        }
        my $command=$bwa." aln ".$options." -f ".$saiFileOut." ".$refFastaFileIn." ".$FastqFileIn;		# command line
        #Execute command
        if(toolbox::run($command)==1)		## if the command has been excuted correctly, export the log
	{
            toolbox::exportLog("INFOS: bwa::bwaAln : correctly done\n",1);
            return 1;
        }
	else
	{
            toolbox::exportLog("ERROR: bwa::bwaAln : ABORTED\n",0);
            return 0;     
        }
    }
    else
    {
        toolbox::exportLog("ERROR: bwa::bwaAln : Problem with the files $refFastaFileIn or/and $FastqFileIn\n",0);
        return 0;     
    }
}
##BWA SAMPE
#Generate alignments in the SAM format given paired-end reads. Repetitive read pairs will be placed randomly. 
sub bwaSampe
{
    my($samFileOut,$refFastaFileIn,$forwardSaiFileIn,$reverseSaiFileIn,$forwardFastqFileIn,$reverseFastqFileIn,$readGroupLine,$optionsHachees)=@_;
    if ((toolbox::sizeFile($refFastaFileIn)==1) and (toolbox::sizeFile($forwardSaiFileIn)==1) and (toolbox::sizeFile($forwardFastqFileIn)==1) and (toolbox::sizeFile($reverseFastqFileIn)==1))		##Check if entry files exist and are not empty
    {
        my $options="";
        if ($optionsHachees)
	{
            $options=toolbox::extractOptions($optionsHachees);		##Get given options
        }
        
        if (ref($readGroupLine)) # Here the RG has been sent as a ref, and will be named as a HASH(0x0000) format type. So we dereference it in a new mode
        {
            $readGroupLine = $$readGroupLine;
        }
         
        my $command=$bwa." sampe ".$options." -f ".$samFileOut."  -r '\@RG\\tID:".$readGroupLine."\\tSM:".$readGroupLine."\\tPL:Illumina' ".$refFastaFileIn." ".$forwardSaiFileIn." ".$reverseSaiFileIn." ".$forwardFastqFileIn." ".$reverseFastqFileIn;		# command line
        #Execute command
        if(toolbox::run($command)==1)		## if the command has been excuted correctly, export the log
	{
        toolbox::exportLog("INFOS: bwa::bwaSampe : correctly done\n",1);
        return 1;
        }
	else
	{
            toolbox::exportLog("ERROR: bwa::bwaSampe : ABORTED\n",0);
            return 0;
        }
    }
    else
    {
        toolbox::exportLog("ERROR: bwa::bwaSampe : Problem with the files\n",0);
        return 0;
        
    }
}
##BWA SAMSE
#Generate alignments in the SAM format given single-end reads. Repetitive hits will be randomly chosen.
sub bwaSamse
{
    my($samFileOut,$refFastaFileIn,$saiFileIn,$fastqFileIn,$readGroupLine,$optionsHachees)=@_;
    if ((toolbox::sizeFile($refFastaFileIn)==1) and (toolbox::sizeFile($saiFileIn)==1)and (toolbox::sizeFile($fastqFileIn)==1))		##Check if entry files exist and are not empty
    {
        my $options="";
        if ($optionsHachees)
	{
            my $options=toolbox::extractOptions($optionsHachees);		##Get given options
        }
        
        if (ref($readGroupLine)) # Here the RG has been sent as a ref, and will be named as a HASH(0x0000) format type. So we dereference it in a new mode
        {
            $readGroupLine = $$readGroupLine;
        }
        
        my $command=$bwa." samse ".$options." -f ".$samFileOut." -r '\@RG\\tID:".$readGroupLine."\\tSM:".$readGroupLine."\\tPL:Illumina' ".$refFastaFileIn." ".$saiFileIn." ".$fastqFileIn;		# command line
        #Execute command
        if(toolbox::run($command)==1)		## if the command has been excuted correctly, export the log
	{
        toolbox::exportLog("INFOS: bwa::bwaSamse : correctly done\n",1);
        return 1;
        }
	else
	{
            toolbox::exportLog("ERROR: bwa::bwaSamse : ABORTED\n",0);
            return 0;
        }
    }
    else
    {
        toolbox::exportLog("ERROR: bwa::bwaSamse : Problem with the files\n",0);
        return 0;
    }
}
##BWA MEM
#Generate alignments in the SAM format.
#BWA-MEM, which is the latest, is generally recommended for high-quality queries as it is faster and more accurate. It also has better performance for 70-100bp Illumina reads
sub bwaMem 
{
    my($samFileOut,$refFastaFileIn, $forwardFastqFileIn,$reverseFastqFileIn, $readGroupLine,$optionsHachees)=@_;

    #bwa mem work with paired end and single; test if both reverse and mate agiven or not
    my $fastqFileIn = 1; 	# In standard, the fastq are two files
    if ($reverseFastqFileIn eq "") # the fourth argument is empty, meaning a single file
    {
        $fastqFileIn = 0; # the boolean is put to zero for signaling the single mode
    }

    if ((toolbox::sizeFile($refFastaFileIn)==1) and (toolbox::sizeFile($forwardFastqFileIn)==1))
    {
	#$samFileOut=toolbox::extractName($fastqFileIn).".sam" unless $samFileOut;
	my $options="";
	if ($optionsHachees) 
	{
	    my $options=toolbox::extractOptions($optionsHachees);
	}

	$readGroupLine="" unless $readGroupLine;		# Unless a read group is specified by user, readGroupLine is empty
	# command
	my $command="";
	if ($fastqFileIn==1)		# if paired-end data
	{
	    $command="$bwa mem $options $refFastaFileIn $forwardFastqFileIn  $reverseFastqFileIn  -R '\@RG\\tID:".$readGroupLine."\\tSM:".$readGroupLine."\\tPL:Illumina' > $samFileOut";		# command line
	}
	else		# if single-end data
	{
	    $command="$bwa mem $options $refFastaFileIn $forwardFastqFileIn   -R '\@RG\\tID:".$readGroupLine."\\tSM:".$readGroupLine."\\tPL:Illumina' > $samFileOut";		# command line
	}

       #Execute command
	if(toolbox::run($command)==1)
	{
	    toolbox::exportLog("INFOS: bwa::bwaMem : correctly done\n",1);
	    return 1;
	}
	else
	{
	    toolbox::exportLog("ERROR: bwa::bwaMem : ABORTED\n",0);
	    return 0;
	}
    }
    else
    {
       toolbox::exportLog("ERROR: bwa::bwaMem : Problem with the files\n",0);
       return 0;
    }                                                                                                                              
}
1;

=head1 NAME

    Package I<bwa> 

=head1 SYNOPSIS

	use bwa;
    
	bwa::bwaIndex ($refFastaFileIn,$option_prog{'bwa index'});
    
	bwa::bwaAln ($refFastaFileIn,$FastqFileIn,$saiFileOut,$option_prog{'bwa aln'});
    
	bwa::bwaSampe ($samFileOut,$refFastaFileIn,$forwardSaiFileIn,$reverseSaiFileIn,$forwardFastqFileIn,$reverseFastqFileIn,$readGroupLine,$option_prog{'bwa sampe'});
    
	bwa::bwaSamse ($samFileOut,$refFastaFileIn,$saiFileIn,$fastqFileIn,$readGroupLine,$option_prog{'bwa samse'});
    
	bwa::bwaMem ($samFileOut,$refFastaFileIn, $forwardFastqFileIn,$reverseFastqFileIn, $readGroupLine,$option_prog{'bwa mem'});

=head1 DESCRIPTION

    Package BWA (Li et al, 2009, http:// ) is a software package for mapping low-divergent sequences against a large reference genome, such as the human genome.

=head2 FUNCTIONS

=head3 bwa::bwaIndex

This module index database sequences in the FASTA format.
It takes at least one argument: the name of the database to index
The second argument is the options of bwa index, for more informations see http://bio-bwa.sourceforge.net/bwa.shtml



=head3 bwa::bwaAln

This module find the SA coordinates of the input reads. Maximum maxSeedDiff differences are allowed in the first seedLen subsequence and maximum maxDiff differences are allowed in the whole sequence.
It takes at least three arguments: the name of the database indexed, the name of file where to find SA coordinates, the name of the output file of this module ".sai"
The fourth argument is the options of bwa aln, for more informations see http://bio-bwa.sourceforge.net/bwa.shtml



=head3 bwa::bwaSampe

This module generate alignments in the SAM format given paired-end reads. Repetitive read pairs will be placed randomly.
It takes at least six arguments: the name of the database indexed, the name of the reverse fastq file, the name of the forward fastq file, the name of the reverse sai file, the name of the forward sai file, the name of the output file of this module ".sam"
The seventh argument is the read group information
The eighth argument is the bwa sampe options, for more informations see http://bio-bwa.sourceforge.net/bwa.shtml



=head3 bwa::bwaSamse

This module generate alignments in the SAM format given single-end reads. Repetitive hits will be randomly chosen.
It takes at least four arguments: the name of the database indexed, the name of the fastq file, the name of the sai file, the name of the output of this module ".sam"
The fifth argument is the read group information
The sixth argument is the options of bwa samse, for more informations see http://bio-bwa.sourceforge.net/bwa.shtml



=head3 bwa::bwaMem

Align 70bp-1Mbp query sequences with the BWA-MEM algorithm. Briefly, the algorithm works by seeding alignments with maximal exact matches (MEMs) and then extending seeds with the affine-gap Smith-Waterman algorithm (SW).

If mates.fq file is absent and option -p is not set, this command regards input reads are single-end. If mates.fq is present, this command assumes the i-th read in reads.fq and the i-th read in mates.fq constitute a read pair. If -p is used, the command assumes the 2i-th and the (2i+1)-th read in reads.fq constitute a read pair (such input file is said to be interleaved). In this case, mates.fq is ignored. In the paired-end mode, the mem command will infer the read orientation and the insert size distribution from a batch of reads.

The BWA-MEM algorithm performs local alignment. It may produce multiple primary alignments for different part of a query sequence. This is a crucial feature for long sequences. However, some tools such as Picard markDuplicates does not work with split alignments. One may consider to use option -M to flag shorter split hits as secondary.
It takes at least three (for single) or four (for pair) arguments: the name of the database indexed, the name of the fastq file(s), the name of the output file of this module ".sam"
The penultimate arguement is the read group information
The last argument is the options of bwa mem, for more informations see http://bio-bwa.sourceforge.net/bwa.shtml


=head1 AUTHORS

Intellectual property belongs to IRD, CIRAD and South Green developpement plateform 
Written by Cecile Monat, Ayite Kougbeadjo, Marilyne Summo, Cedric Farcy, Mawusse Agbessi, Christine Tranchant and Francois Sabot

=head1 SEE ALSO

L<http://www.southgreen.fr/>

=cut