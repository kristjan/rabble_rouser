require "fileutils"
require "httparty"
require "sanitize"
require "marky_markov"

BLOGGER_API_BASE = "https://www.googleapis.com/blogger/v3"
CORPUS_ROOT = File.join(File.dirname(__FILE__), 'corpus')

desc "Fetch blog posts"
task :fetch, [:blog_url] do |t, args|
  FileUtils.mkdir_p(CORPUS_ROOT)
  puts "Fetching #{args.blog_url} with #{ENV["GOOGLE_API_KEY"]}"
  response = HTTParty.get(BLOGGER_API_BASE + "/blogs/byurl",
                          :query => {:url => args.blog_url,
                                     :key => ENV["GOOGLE_API_KEY"]})
  blog_id = response["id"]
  puts "#{args.blog_url} has ID #{blog_id}"
  count = 0
  posts_url = response["posts"]["selfLink"]
  pageToken = nil
  begin
    query = {:key => ENV["GOOGLE_API_KEY"]}
    query[:pageToken] = pageToken if pageToken

    response = HTTParty.get(posts_url, :query => query)
    posts = response["items"]
    pageToken = response["nextPageToken"]

    posts.each do |post|
      File.open(File.join(CORPUS_ROOT, post["id"]), 'w') do |f|
        f.write(Sanitize.clean(post["content"]))
      end
    end

    count += posts.size
    puts "Fetched #{posts.size}. Total: #{count}."
  end until pageToken.nil?
end

desc "Build word index"
task :build_index, [:order] do |t, args|
  FileUtils.rm_f('markov.mmd')
  order = args.order.to_i
  dictionary = "markov.#{order}"
  MarkyMarkov::Dictionary.delete_dictionary!(dictionary)
  markov = MarkyMarkov::Dictionary.new(dictionary, order)
  Dir["#{CORPUS_ROOT}/*"].each do |filename|
    markov.parse_file(filename)
  end
  markov.save_dictionary!
end
