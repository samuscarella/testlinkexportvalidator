require 'Nokogiri'
require 'pathname'
require 'logger'

class TestLinkExportLogs

  def initialize
  end

  def mapTestSuites
    # puts ENV['USER']
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

    return testSuitesArray

  end

  def saveToLogFile(testsuites_data)
    File.open("testlinkresults.txt", "w+") { |f|
      testsuites_data.each do |suite|
          suite.each do |s|
            f.write("#{s.dig(:suitename)} = (#{s.dig(:testCaseCount)})\n")
          end
      end
    }
  end

end

test = TestLinkExportLogs.new
data = test.mapTestSuites
test.saveToLogFile(data)
