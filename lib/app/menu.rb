#########Golbal##########
$prompt = TTY::Prompt.new
$current_user = nil
#########################
# clears the user screen
def keypress
  $prompt.keypress("Press space or enter to continue", keys: [:space, :return])
end

def clear
  system "clear"
end
def run_program
  welcome
  sleep(4)
  opening_menu
end
def welcome
  puts "Hello there!"
  sleep(1)
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
  sleep(4)
  puts "My name is Oak! People call me the pokémon Prof!"
  sleep(1)
  puts "This world is inhabited by creatures called pokémon! For some people, pokémon are pets. Others use them for fights. Myself...I study pokémon as a profession."
end
def exit
  puts "Smell Ya Later!"
  abort
end

def opening_menu
  clear
  $prompt.select("Main Menu") do |t|
    t.choice 'Sign-up', -> {sign_up}
    t.choice 'Log-in', -> {log_in}
    t.choice 'Exit', -> {exit}
  end
end

def sign_up
  name = $prompt.ask("What is your name?", require:true) do |n|
    n.modify :capitalize
  end

  ball = $prompt.decorate("◓",:red)
  pass = $prompt.mask("Create a password(4 to 10 characters)",require:true, mask:ball) do |p|
    p.validate(/[a-z\ ]{4,10}/)
  end

  if Trainer.find_by(name: name) != nil
    puts "Sorry, username that is taken. Try again."
  else
    $current_user = Trainer.create(name: name, password: password)
    puts "You have signed up and successfully logged in. Enjoy!"
  end
end

def log_in
  $current_user = Trainer.find_by(name: name, password: password)
  if $current_user == nil
    puts "Your username or password is incorrect. Please try again."
  end 
end
