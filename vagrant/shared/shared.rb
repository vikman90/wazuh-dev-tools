# Vikman Fernandez-Castro
# February 9, 2020

require_relative "config.rb"

File.open(File.join(File.dirname(__FILE__), 'hosts'), "w") do |f|
    for host, ip in $hosts do
        f.puts "%s\t%s" % [ip, host]
    end
end
