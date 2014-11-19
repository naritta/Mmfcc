
module Mmfcc
  require "rubygems"
  require "ai4r"

  class Clustering

  	def initialize(cnum)
      @cnum = cnum
    end

  	def kmeans(all_mfcc, clusterNum)

		ai4r_data = Ai4r::Data::DataSet.new(:data_items=> all_mfcc)

		cluster = Ai4r::Clusterers::KMeans.new
      	cluster.build(ai4r_data, clusterNum)

      	return cluster
  	end

  	def loadMFCC(mfccFile, m, all_mfcc)
	    
	    mfcc = []
	    mfccs = []

	    File.open(mfccFile, "r+b")  {|f|
		  	while line = f.read(4)
		        if line == "" then
		        	break
		        end

		        val = line.unpack('f')[0]
		        mfcc.push(val)
		        

		        if mfcc.length==m then
		        	mfccs.push(mfcc)
		        	all_mfcc.push(mfcc)
		        	mfcc=[]
		        end
		  	end
		}

		return mfccs
    end

    def run

    	mfccDir = './mfcc/'

	    clusterNum = @cnum.to_i
	    mfcc_dict = {}
	    all_mfcc = []

	    Find.find(mfccDir) {|mfccFile|
	    	next unless mfccFile.end_with?(".mfc")
	    	mfcc = loadMFCC(mfccFile, 20, all_mfcc)
	    	mfcc_dict[mfccFile]=mfcc
	    }

	    cluster = kmeans(all_mfcc, clusterNum)

	    writeToFile = File.open("./histgram.txt",'w')

     	mfcc_dict.each{|key, value|
      		writeToFile.puts key

      		histgram = [0]*clusterNum

      		value.each{|d|
	      		i = cluster.eval(d)
	      		histgram[i]+=1
	      	}
	      	
	      	str_hist = histgram.join(" ")
	      	writeToFile.puts str_hist

      	}

      	puts "histgram.txt is created."
      	writeToFile.close
    end
  end
end
