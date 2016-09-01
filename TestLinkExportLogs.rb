require 'Nokogiri'

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
                  suiteName: ts["name"],
                  testCaseCount: ts.xpath("./testcase").count,
                }
              }
              # puts testsuite_data
              testSuitesArray.push(testsuite_data)
            end

        end

          Dir.chdir "/Users/#{ENV['USER']}/Desktop/TestLinkExportLogs"

            File.open("./../#{category}_results.txt", "w+") { |f|

              f.write("You're looking at the results of #{category}:\n\n")
              testSuitesArray[0].each do |element|
                  # puts element.dig(:suitename)
                  f.write("\t\t#{element.dig(:suiteName)} = #{element.dig(:testCaseCount)}\n")
              end
              f.close
            }
            puts "Logged #{category} successfully..."
     end

  end
