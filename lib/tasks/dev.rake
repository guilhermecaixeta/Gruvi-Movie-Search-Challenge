namespace :dev do
  desc "Development environment setup"
  task setup: [ :environment ] do
    puts "== Closing Connections Development ==\n#{`rails db:kick`}"
    puts "== Creating ==\n#{`rails db:prepare`}"
    puts "== Migrating ==\n#{`rails db:migrate`}"
  end

  desc "Development environment recreation"
  task recreate: [ :environment ] do
    puts "== Closing Connections Development ==\n#{`rails db:kick`}"
    puts "== Dropping ==\n#{`rails db:drop`}"
    puts "== Recreating ==\n#{`rails db:prepare`}"
    puts "== Migrating ==\n#{`rails db:migrate`}"
  end
end
