def wait_for_db(retry_left=20)
  ActiveRecord::Base.connection
  puts "\n"
  return true
rescue PG::ConnectionBad => e
  raise e if retry_left <= 0
  print '.'
  sleep 5
  wait_for_db(retry_left-=1)
end

wait_for_db