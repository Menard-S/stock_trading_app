namespace :portfolio do
    desc "Update all portfolio gains"
    task update_gains: :environment do
      puts "Starting update of all portfolio gains"
      Portfolio.update_all_gains
      puts "Completed update of all portfolio gains"
    end
  end
  