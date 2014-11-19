module Mmfcc
  require "find"

  class Command
    def run
    	require 'optparse'

		params = ARGV.getopts('mc',"type:mp3", "m4apath:./m4a/", "mp3path:./mp3/", "cnum:8")

		if params["m"] then
			puts "calculating mfcc..."

			require 'mmfcc/mfcc'

			mfcc = Mmfcc::Mfcc.new(params["type"], params["m4apath"], params["mp3path"])
			mfcc.run
		end

		if params["c"] then
			puts "start clustering..."

			require 'mmfcc/clustering'

			clustering = Mmfcc::Clustering.new(params["cnum"])
			clustering.run
		end
    end
  end
end
