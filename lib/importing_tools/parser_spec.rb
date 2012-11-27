# encoding: utf-8
require File.expand_path("../parser", __FILE__)

describe TJExam, "#parse" do
  it "trips all tags but <img>, <table>, <tr>, <td>, <thead>, <tbody>" do
    data = [
      ['<p>asdf</p>', ['asdf']],
      ['<img src="asdf">', ['<img src="asdf">']],
      ['<table>asdf</table>', ['<table>asdf</table>']]
    ]
    data.each{|d|
      TJExam::parse(StringIO.new(d[0])).should eq(d[1])  
    }
  end
  it "splits questions with the separator '==SEPARATOR=='"
  it "identifies tags like【科目】, store in an array"
  it "returns an hash"
end