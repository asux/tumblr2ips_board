#!/usr/bin/env ruby
# coding: utf-8
require 'yaml'
require 'httmultiparty'
require 'pp'
require 'pry'

class IPSBoard
  include HTTMultiParty
  attr_reader :last_opts

  base_uri 'www.pickupforum.ru'

  def initialize
    @params = YAML.load(File.read(File.expand_path('config/params.yml', File.dirname(__FILE__))))
    @cookies = YAML.load(File.read(File.expand_path('config/cookies.yml', File.dirname(__FILE__))))
    self.class.default_params @params
  end

  def post(text, options={})
    @last_opts = {query:
      {
        act: 'Post',
        f: options[:forum_id],
        t: options[:topic_id],
        Post: text.encode('windows-1251'),
        CODE: '03',
        st: 0,
        enablesig: 1,
        enableemo: 1,
        enabletrack: 0,
        iconid: 0,
        parent_id: 0,
        dosubmit: 'Submit'
      },
      cookies: @cookies}
    self.class.post('/index.php', @last_opts)
  end
end

board = IPSBoard.new
response = board.post("Тестирую автопостинг сюда через скрипт", forum_id: 113, topic_id: 178760)
puts response
