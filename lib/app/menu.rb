#########Golbal##########
$prompt = TTY::Prompt.new
$current_user = nil
#########################
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
  #sleep(3)
  opening_menu
  game_menu
end
def welcome
  puts "Hello there!"
  #sleep(1)
  puts "Welcome to the world of pokémon!"
  puts "                                  ,'\
    _.----.        ____         ,'  _\   ___    ___     ____
_,-'       `.     |    |  /`.   \,-'    |   \  /   |   |    \  |`.
\      __    \    '-.  | /   `.  ___    |    \/    |   '-.   \ |  |
 \.    \ \   |  __  |  |/    ,','_  `.  |          | __  |    \|  |
   \    \/   /,' _`.|      ,' / / / /   |          ,' _`.|     |  |
    \     ,-'/  /   \    ,'   | \/ / ,`.|         /  /   \  |     |
     \    \ |   \_/  |   `-.  \    `'  /|  |    ||   \_/  | |\    |
      \    \ \      /       `-.`.___,-' |  |\  /| \      /  | |   |
       \    \ `.__,'|  |`-._    `|      |__| \/ |  `.__,'|  | |   |
        \_.-'       |__|    `-._ |              '-.|     '-.| |   |
                                `'                            '-._|"
  #sleep(3)
  puts "My name is Oak! People call me the pokémon Prof!"
  #sleep(1)
  puts "This world is inhabited by creatures called pokémon! For some people, pokémon are pets. Others use them for fights. Myself...I study pokémon as a profession."
end
def exit
  puts "Smell Ya Later!"
  abort
end
def log_out
  opening_menu
end
def view_profile
  binding.pry
  puts "Username: #{$current_user.name}"
  puts "Password: #{$current_user.password}"
  $prompt.select('Update Profile') do |u|
    u.choice "Update Profile", ->{update_profile}
    u.choice "Exit", ->{game_menu}
  end
end

def update_profile

end

def opening_menu
  clear
  $prompt.select("Main Menu") do |t|
    t.choice 'Sign-up', -> {sign_up}
    t.choice 'Log-in', -> {log_in}
    t.choice 'Exit', -> {exit}
  end
end

def game_menu
  $prompt.select("Game Menu") do |t|
    t.choice 'View Profile', ->{view_profile}
    t.choice 'Find Pokemon', ->{find_pokemon}
    t.choice 'Party', ->{party_menu}
    t.choice 'PC', ->{pc}
    t.choice 'Log-out', ->{log_out}
  end
end

def sign_up
  # asks user name and stores it in name variable
  name = $prompt.ask("What is your name?", require:true) do |n|
    n.modify :capitalize
  end
  puts "Welcome #{name}! Welcome to the world of pokemon!"
  #variable to decorate password
  ball = $prompt.decorate("◓",:red)
  # stores password in variable
  pass = $prompt.mask("Create a password(4 to 10 characters)",require:true, mask:ball) do |p|
    p.validate(/[a-z,0-9\ ]{4,10}/)
  end
  # store's gender in variable
  gender = $prompt.select('what is your gender?') do |g|
    g.choice 'Male'
    g.choice 'Female'
    g.choice 'Non-binary'
  end

  # checks for username, if it does not exist then it creates a new user
  if Trainer.find_by(name: name) != nil
    puts "Sorry, username that is taken. Try again."
  else
    $current_user = Trainer.create(name: name, password: pass, sex: gender)
    puts "You have successfully signed up and logged in. Enjoy!"
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
  Party.create(pokeball_id:pokeball.id,trainer_id:$current_user.id)
  binding.pry
end

def party_menu
  $prompt.select("Check Stats") do |z|
    Party.trainer_party($current_user).map do |pokeball|
      curr_ball = Pokeball.find(pokeball.pokeball_id)
      pokemon_name = curr_ball.display_pokemon
      binding.pry
    end.each do |pokemon|
      binding.pry
      z.choice "#{pokemon.name}"
    end
  end

  game_menu
end


def log_in

  name = $prompt.ask("What is your Username?", require:true) do |n|
    n.modify :capitalize
  end

  ball = $prompt.decorate("◓",:red)

  pass = $prompt.mask("Create a password(4 to 10 characters)",require:true, mask:ball) do |p|
    p.validate(/[a-z,0-9\ ]{4,10}/)
  end

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
  # $current_user = Trainer.find_by(name: name, password: pass)
  #
  # if $current_user == nil
  #   puts "Your username or password is incorrect. Please try again."
  # end
  game_menu
end
