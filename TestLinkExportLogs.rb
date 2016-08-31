require 'Nokogiri'
require 'pathname'
require 'logger'

    xmlFiles = Dir["*.xml"]
    testSuitesArray = Array.new
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

    File.open("testlinkresults.txt", "w+") { |f|
      testSuitesArray.each do |suite|
          suite.each do |s|
            f.write("#{s.dig(:suitename)} = (#{s.dig(:testCaseCount)})\n")
          end
      end
    }
