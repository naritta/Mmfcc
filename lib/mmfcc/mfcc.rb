
module Mmfcc
  class Mfcc

  	def initialize(type, m4apath, mp3path)
      @type = type
      @m4apath = m4apath
      @mp3path = mp3path
    end

  	def m4aToRaw(m4aFile)
	    system("ffmpeg -i "+m4aFile+" -ab 32k -ar 16000 temp.m4a")
	    # decode mp3 to wav
	    system("ffmpeg -i temp.m4a temp.wav")
	    # convert wav to raw
	    system("sox temp.wav temp.raw")
	    # delete needless
	    system("rm temp.m4a")
	    system("rm temp.wav")
	end

  	def mp3ToRaw(mp3File)
	    system("lame --resample 16 -b 32 -a "+mp3File+" temp.mp3")
	    # decode mp3 to wav
	    system("lame --decode temp.mp3 temp.wav")
	    # convert wav to raw
	    system("sox temp.wav temp.raw")
	    # delete needless
	    system("rm temp.mp3")
	    system("rm temp.wav")
	end

	def calcNumSample(rawFile)
	    # calculate byte
	    filesize = File.size?("temp.raw")
	    numsample = filesize / 2
	    return numsample
	end

	def extractCenter(inFile, outFile, period)
	    numsample = calcNumSample(inFile)
	    p numsample

	    fs = 16000
	    center = numsample / 2
	    start = center - fs * period
	    ends = center + fs * period

	    if start < 0 then
	    	start = 0
	    end
	    if ends > numsample - 1 then
	    	ends = numsample - 1
	    end

	    system("bcut +s -s "+start.to_s+" -e "+ends.to_s+" < temp.raw > "+outFile)
	end

	def calcMFCC(rawFile, mfccFile)
	    # sampling rate: 16kHz
	    # frame length: 400
	    # shift broad: 160
	    # num of channel: 40
	    # MFCC: 19 dimentions + energy
	    system("x2x +sf < "+rawFile+" | frame -l 400 -p 160 | mfcc -l 400 -f 16 -n 40 -m 19 -E > "+mfccFile)
	end

  	def run
  		p "start"

      	m4aDir = @m4apath
      	mp3Dir = @mp3path
	    mfccDir = '../data/mfcc/'
    	rawDir = '../data/raw/'

    	if not Dir::exist?(mfccDir) then
        	Dir::mkdir(mfccDir)
        end
    	if not Dir::exist?(rawDir) then
        	Dir::mkdir(rawDir)
        end

        if @type == "m4a" then
	        Find.find(m4aDir) {|m4aFile|
	        	next unless FileTest.file?(m4aFile)
				next unless m4aFile.end_with?(".m4a")

	        	mfccFile = m4aFile.sub(".m4a",".mfc")
			  	mfccFile = mfccFile.sub(m4aDir, mfccDir)

			  	rawFile = m4aFile.sub(".m4a",".raw")
			  	rawFile = rawFile.sub(m4aDir, rawDir)

			  	begin
		            # decode MP3
		            m4aToRaw(m4aFile)

		            # convert 30s mp3 to rawFile
		            extractCenter("temp.raw", rawFile, 15)

		            calcMFCC(rawFile, mfccFile)

		            system("rm temp.raw")
		        rescue
		            next
		            p "failed at decode m4a"
		        end
	        }
	    else
			Find.find(mp3Dir) {|mp3File|
				next unless FileTest.file?(mp3File)
			  	next unless mp3File.end_with?(".mp3")

			  	mfccFile = mp3File.sub(".mp3",".mfc")
			  	mfccFile = mfccFile.sub(mp3Dir, mfccDir)

			  	rawFile = mp3File.sub(".mp3",".raw")
			  	rawFile = rawFile.sub(mp3Dir, rawDir)

			  	begin
		            # decode MP3
		            mp3ToRaw(mp3File)

		            # convert 30s mp3 to rawFile
		            extractCenter("temp.raw", rawFile, 15)

		            calcMFCC(rawFile, mfccFile)

		            system("rm temp.raw")
		        rescue
		            next
		            p "failed at decode mp3"
		        end			
			}

		end
  	end
  end
end
