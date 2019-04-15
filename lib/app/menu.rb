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
  sleep(3)
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
  sleep(3)
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
    binding.pry
    p.validate(/[a-z,0-9\ ]{4,10}/)
  end

  gender = $prompt.select('what is your gender?') do |g|
    binding.pry
    g.choice 'Male'
    g.choice 'Female'
    g.choice 'Non-binary'
  end

  if Trainer.find_by(name: name) != nil
    puts "Sorry, username that is taken. Try again."
  else
    $current_user = Trainer.create(name: name, password: pass)
    puts "You have signed up and successfully logged in. Enjoy!"
  end
end

def log_in #username, #password
  $current_user = Trainer.find_by(name: name, password: pass)
  if $current_user == nil
    puts "Your username or password is incorrect. Please try again."
  end
end
