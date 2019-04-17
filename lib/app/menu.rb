#########Golbal##########
$prompt = TTY::Prompt.new
$current_user = nil
$wild_pokemon = nil
#########################
#data = require_relative
# presses a key to continue
def keypress
  $prompt.keypress("Press space or enter to continue", keys: [:space, :return])
end
# clears the user screen
def clear
  system "clear"
end
def run_program
  welcome
  # sleep(2)
  opening_menu
  game_menu
end
def welcome
  puts "Hello there!"
  # sleep(1)
  puts "Welcome to the world of pokémon!"
  File.open('pokemon_ascii/pokemon_logo').each do |line|
    puts line
  end
  # sleep(3)
  puts "My name is Oak! People call me the pokémon Prof!"
  # sleep(1)
  puts "This world is inhabited by creatures called pokémon! For some people, pokémon are pets. Others use them for fights. Myself...I study pokémon as a profession."
end
def exit
  puts "Smell Ya Later!".blue
  abort
end
def log_out
  clear
  opening_menu
end
def view_profile
  clear
  puts "Username: #{$current_user.name}"
  puts "Gender: #{$current_user.sex}"

  $prompt.select('Profile Menu') do |u|
    u.choice "Update Profile", ->{update_profile}
    u.choice "Delete Account", ->{delete_profile}
    u.choice "Exit", ->{game_menu}
  end
end

def update_profile
  clear
  to_update = $prompt.select('Update') do |u|
    u.choice "Change Name"
    u.choice "Change Password"
    u.choice "Back", ->{view_profile}
  end
  case to_update
    when "Change Name"
      name = $prompt.ask('Enter your name') do |q|
        q.required true
        q.modify :capitalize
      end
      user = Trainer.find_by(name: $current_user.name)
      user.update(name: name)
      $current_user.name = name

    when "Change Password"
      pass = $prompt.ask('Enter new password') do |q|
        q.required true
        q.validate(/[a-z,0-9\ ]{4,10}/, "Invaild entry, please try agian.(4 to 10 characters)")
      end
      user = Trainer.find_by(name: $current_user.name)
      user.update(password: pass)
  end
  update_profile
end

def delete_profile
  to_delete = $prompt.select("Are you sure you want to delete?") do |c|
    c.choice "yes"
    c.choice "no"
  end
  case to_delete
    when "yes"
      # also need to delete the pokeball instance
      user = Trainer.find_by(id: $current_user.id)
      user.destroy
      pc_delete = PC.where(trainer_id:$current_user.id)
      PC.delete(pc_delete)
      opening_menu
    when "no"
      view_profile
    end
end

def find_pokemon
  $prompt.select("Where would you like to find pokemon") do |p|
    p.choice "Waterfall", ->{waterfall_location}
    p.choice "Camp", ->{camp_location}
    p.choice "Park", ->{park_location}
  end
end

def waterfall_location
  clear
  File.open('pokemon_ascii/waterfall_1').each do |line|
    puts line
  end

  $prompt.select("What do you want to do?") do |p|
    p.choice 'Search', ->{pokemon_encounter}
    p.choice 'Back Home', ->{game_menu}
  end
end

def camp_location
  clear
  File.open('pokemon_ascii/landscape_1').each do |line|
    puts line
  end

  $prompt.select("What do you want to do?") do |p|
    p.choice 'Search', ->{pokemon_encounter}
    p.choice 'Back Home', ->{game_menu}
  end
end

def park_location
  clear
  File.open('pokemon_ascii/park').each do |line|
    puts line
  end

  $prompt.select("What do you want to do?") do |p|
    p.choice 'Search', ->{pokemon_encounter}
    p.choice 'Back Home', ->{game_menu}
  end
end

def pokemon_encounter(wild_pokemon=nil)
  if wild_pokemon == nil
    wild_pokemon = random_pokemon
    view_pokemon(wild_pokemon)
  end

  $prompt.select("What do you wanna do with #{wild_pokemon.name.capitalize}!") do |p|
    p.choice "Attack"
    p.choice "Catch", ->{catch_pokemon(wild_pokemon)}
    p.choice "Run", -> {game_menu}
  end
end

def catch_pokemon(pokemon)
  chance_catch = 1 + rand(100)

  if pokemon.total < 201
    if chance_catch > 50 #10
      puts "You caught #{pokemon.name}!"
      get_pokemon(pokemon)
      party_menu
    else
      puts"It broke free!"
      #sleep step
      pokemon_encounter(pokemon)
      # location
    end
  end

  if pokemon.total > 200 && pokemon.total <= 350
    chance_catch = 1 + rand(100)
    if chance_catch > 75 #25
      puts "You caught #{pokemon.name}!"
      get_pokemon(pokemon)
      party_menu
    else
      puts "It broke free!"
      pokemon_encounter(pokemon)
      # location

    end
  end

  if pokemon.total > 350
    chance_catch = 1 + rand(100)
    if chance_catch > 95 #65
      puts "You caught #{pokemon.name}!"
      get_pokemon(pokemon)
      party_menu
    else
      puts "It broke free!"
      pokemon_encounter(pokemon)
      # location
    end
  end
end

def opening_menu
  clear
  File.open('pokemon_ascii/pokemon_logo').each do |line|
    puts line
  end
  $prompt.select("Main Menu") do |t|
    t.choice 'Sign-up', -> {sign_up}
    t.choice 'Log-in', -> {log_in}
    t.choice 'Exit', -> {exit}
  end
end

def game_menu
  clear
  File.open('pokemon_ascii/dream_castle').each do |line|
    puts line
  end

  $prompt.select("Game Menu") do |t|
    t.choice 'View Profile', ->{view_profile}
    t.choice 'Find Pokemon', ->{find_pokemon}
    t.choice 'Party', ->{party_menu}
    t.choice 'PC', ->{pc_menu}
    t.choice 'Log-out', ->{log_out}
  end
end

def sign_up
  ######################################################################
  # asks user name and stores it in name variable
  name = $prompt.ask("What is your name?", require:true) do |n|
    n.modify :capitalize
  end
  puts "Welcome #{name}! Welcome to the world of pokemon!".blue
  ######################################################################
  #variable to decorate password
  ball = $prompt.decorate("◓",:red)
  # stores password in variable
  pass = $prompt.mask("Create a password(4 to 10 characters)", mask:ball) do |p|
    p.required true
    p.validate(/[a-z,0-9\ ]{4,10}/, "Invaild entry, please try agian.")
  end
  ######################################################################
  # store's gender in variable
  gender = $prompt.select('what is your gender?') do |g|
    g.choice 'Male'
    g.choice 'Female'
    g.choice 'Non-binary'
  end
######################################################################
  # checks for username, if it does not exist then it creates a new user
  if Trainer.find_by(name: name) != nil
    puts "Sorry, username that is taken. Try again."
    sign_up
  else
    $current_user = Trainer.create(name: name, password: pass, sex: gender)
    puts "You have successfully signed up and logged in. Enjoy!"
    sleep 1
  end

  starter_pokemon
end

def starter_pokemon
  puts "Every young trainer must have a Pokemon. I have 3 for you to choose from."
  $prompt.select("Pokemon Choices") do |p|
    pokemon1 = Pokemon.find(197)
    pokemon2 = Pokemon.find(373)
    pokemon3 = Pokemon.find(376)

    p.choice "#{pokemon1.name.capitalize}", -> {view_starter_pokemon(pokemon1)}
    p.choice "#{pokemon2.name.capitalize}", -> {view_starter_pokemon(pokemon2)}
    p.choice "#{pokemon3.name.capitalize}", -> {view_starter_pokemon(pokemon3)}
  end
end

def random_pokemon
  random_id = 1 + rand(807)
  pokemon = Pokemon.find(random_id)
end

def view_pokemon(pokemon)
  puts "Pokemon: #{pokemon.name.capitalize}"
  puts "Type: #{pokemon.element}"
  puts "Total: #{pokemon.total}"
  puts "HP: #{pokemon.hp}"
  puts "Attack: #{pokemon.attack}"
  puts "Defense: #{pokemon.defense}"
  puts "Speed: #{pokemon.speed}"
end

def view_starter_pokemon(pokemon)
  view_pokemon(pokemon)

  $prompt.select("Do you want this Pokemon?") do |s|
    s.choice "Yes", -> {get_pokemon(pokemon)}
    s.choice "No", ->{starter_pokemon}
  end
end

def get_pokemon(pokemon)
  pokeball = Pokeball.create(trainer_id:$current_user.id,pokemon_id:pokemon.id)
  #if Party at Trainer_id.count < 6
  if Party.where(trainer_id: $current_user.id).count <= 5
    Party.create(pokeball_id:pokeball.id,trainer_id:$current_user.id)
  else
    PC.create(pokeball_id:pokeball.id,trainer_id:$current_user.id)
  end
end

def view_party_pokemon(pokemon)
  view_pokemon(pokemon)
  $prompt.select("What do you want to do?") do |p|
    p.choice "Send to PC", -> {pc_menu}
    p.choice "Back to Party", -> {party_menu}
  end
end

def view_pc_pokemon(pokemon,pokeball)
  view_pokemon(pokemon)
  $prompt.select("What do you want to do?") do |p|
    p.choice "Release Pokemon", -> {release_pokemon(pokemon, pokeball)}
    p.choice "Back to PC", -> {pc_menu}
  end
end

def pc_menu
  $prompt.select("Check Stats") do |z|
    PC.trainer_pc($current_user).map do |pokeball|
      curr_ball = Pokeball.find(pokeball.pokeball_id)
      curr_ball
    end.each do |pokeball|
      pokemon_name = pokeball.display_pokemon
      pokemon_name
      z.choice "#{pokemon_name.name.capitalize}", ->{view_pc_pokemon(pokemon_name, pokeball)}
    end
    z.choice "back",->{game_menu}
  end
  game_menu

end

def release_pokemon(pokemon,pokeball)
  $prompt.select("Are you sure you want to release #{pokemon.name}?") do |c|
    c.choice "yes", -> {delete_pokemon(pokeball)}
    c.choice "no", -> {view_pc_pokemon(pokemon)}
  end
end

def delete_pokemon(pokeball)
  ball = Pokeball.find(pokeball.id)
  pc_delete = PC.where(pokeball_id:ball.id)
  PC.delete(pc_delete)
  ball.destroy
  pc_menu
end

def party_menu
  $prompt.select("Check Stats") do |z|
    Party.trainer_party($current_user).map do |pokeball|
      curr_ball = Pokeball.find(pokeball.pokeball_id)
      pokemon_name = curr_ball.display_pokemon
      pokemon_name
    end.each do |pokemon|
      z.choice "#{pokemon.name.capitalize}", ->{view_party_pokemon(pokemon)}
    end
    z.choice "back",->{game_menu}
  end
  game_menu
end


def log_in
  name = $prompt.ask("What is your Username?", require:true) do |n|
    n.modify :capitalize
  end
#####################################################################################
  ball = $prompt.decorate("◓",:red)

  pass = $prompt.mask("Enter Password(4 to 10 characters)",require:true, mask:ball) do |p|
    p.validate(/[a-z,0-9\ ]{4,10}/, "Wrong password, please try again")
  end
#######################################################################################
  if Trainer.all.find_by(name: name) && Trainer.all.find_by(password: pass) != nil
   $current_user = Trainer.all.find_by(name: name)

   puts "Welcome back, #{$current_user.name}!"
   sleep 1
   clear
   game_menu
  else
   puts "Wrong Username or Password, please try agian."
   log_in
  end
end
