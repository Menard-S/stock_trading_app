desc "Update all stock prices in heroku"
task update_prices: :environment do
  puts "Starting update of all stock prices"
  Stock.update_all_current_prices
  puts "Completed update of all stock prices"
end

task update_gains: :environment do
    puts "Starting update of all portfolio gains"
    Portfolio.update_all_gains
    puts "Completed update of all portfolio gains"
  end