namespace :stock do
    desc "Update all stock prices"
    task update_prices: :environment do
      puts "Starting update of all stock prices"
      Stock.update_all_current_prices
      puts "Completed update of all stock prices"
    end
  end
  