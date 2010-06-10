task :default => [:expire_cache_items]

task :expire_cache_items do
  items = Dir.new("cache").entries
  items.delete(".")
  items.delete("..")

  items.each do |item|
    file = File.new("cache/#{item}")
    time_diff = Time.now.to_i - file.mtime.to_i

    if time_diff > 86400
      File.delete "cache/#{item}"
    end
  end
end
