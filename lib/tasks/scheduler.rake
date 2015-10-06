desc "This task is called by the Heroku scheduler to update all Winrates from dotabuff"
task update_winrates: :environment do
  Winrate.each do |winrate|
    puts "Updating winrate #{winrate._id}..."
    winrate.update_from_web
  end
  puts "done."
end