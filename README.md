# Mmfcc

'Mmfcc' calculation tool for music analysis.

* you can make mfcc from mp3 files or m4a files.
* you can also do clustering and make histgrams.

 you can install easily.

## Install and Execute

you need some tools like sox, lame and SPTK.

you can install by executing:

    gem install mmfcc

To execute for making mfcc from mp3:

    mkdir mp3
    # in case of making from m4a, execute "mkdir m4a"
    # put mp3 files into this directry.
    mmfcc -m

When you specify where directry is:

	mmfcc -m --mp3path "/mp3/is/here"

After you made mfcc, you can make histgram by clustering the mfcc.:

	mmfcc -c
	# if you specify num of clusters, execute like next one.
	# mmfcc -c --cnum 16	

This is fully open source software.
