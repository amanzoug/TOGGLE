package fastxToolkit;

###################################################################################################################################
#
# Licencied under CeCill-C (http://www.cecill.info/licences/Licence_CeCILL-C_V1-en.html) and GPLv3
#
# Intellectual property belongs to IRD, CIRAD and South Green developpement plateform 
# Written by Cecile Monat, Ayite Kougbeadjo, Marilyne Summo, Cedric Farcy, Mawusse Agbessi, Christine Tranchant and Francois Sabot
#
###################################################################################################################################

use strict;
use warnings;

use lib qw(.);
use localConfig;
use toolbox;
use Data::Dumper;

sub fastxTrimmer
{
    my($fastqFileIn,$fastqFileOut,$optionsHachees)=@_;
    if (toolbox::sizeFile($fastqFileIn)==1)             ##Check if the fastqfile exist and is not empty
    {
        my $options=toolbox::extractOptions($optionsHachees, " ");  ##Get given options by software.config
        ## DEBUGG
        toolbox::exportLog("DEBUG: fastxToolkit::fastxTrimmer : fastxTrimmer option equals to $options",1);
        my $command=$fastxTrimmer." ".$options." -i ".$fastqFileIn." -o ".$fastqFileOut; ## Command initialization
        
        # Command is executed with the run function (package toolbox)
        if (toolbox::run($command)==1)
        {
            toolbox::exportLog("INFOS: fastxToolkit : correctly done\n",1);
            return 1;
        }
        else
        {
            toolbox::exportLog("ERROR: fastxToolkit : ABBORTED\n",0);
            return 0;
        }
        
    }
    else
    {
        toolbox::exportLog("ERROR: fastxToolkit::fastxTrimmer : Problem with the file $fastqFileIn\n",0);
        return 0;
    }
    
    
}


1;
