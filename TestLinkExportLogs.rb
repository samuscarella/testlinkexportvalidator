require 'Nokogiri'
require 'pathname'
require 'logger'

  class TestLinkExportLogs

    def initialize
    end

    def mapTestSuites(category)

      testSuitesArray = Array.new
      Dir.chdir "/Users/#{ENV['USER']}/Desktop/TestLinkExportLogs/#{category}" do
          xmlFiles = Dir["*.xml"]
          xmlFiles.each do |xml|
            doc = Nokogiri::XML(File.open(xml))
            testSuites = doc.xpath("//testsuite")
            testsuite_data = testSuites.map { |ts|
              {
                suitename: ts["name"],
                testCaseCount: ts.xpath("./testcase").count,
                testCaseNames: ts.xpath("./testcase").map { |tc|
                  {
                    testcaseName: tc["name"]
                  }
                }
              }
            }
            testSuitesArray.push(testsuite_data)
          end
      end

      Dir.chdir "/Users/#{ENV['USER']}/Desktop/TestLinkExportLogs"
      
          File.open("testlinkresults.txt", "w+") { |f|
            f.write("You're looking at the results of #{category}:\n\n")
            testSuitesArray.each do |suite|
                suite.each do |s|
                  f.write("#{s.dig(:suitename)} = (#{s.dig(:testCaseCount)})\n")
                end
            end
            puts "Logged successfully..."
          }
    end
  end