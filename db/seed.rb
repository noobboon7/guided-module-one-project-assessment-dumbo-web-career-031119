require 'pry'
require 'colorize'
require 'rest_client'
require 'json'
require 'active_record'
require_relative '../lib/app/model/pokemon'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')

#Opens API call to pokeapi and returns all Pokemon From 1 - 807 
#Parses that value using Rest-client
#Pokemon name followed by url of pokemon data
def pokemon_api_caller
response = RestClient.get "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=807"
response_JSON = JSON.parse(response)
response_JSON["results"]
end

def pokemon_url_caller(url)
	poke_data = JSON.parse(RestClient.get(url))
end

def pokemon_stat_setter(pokemon,stat_data)
	stat_data["stats"].each do |stats|
		hp,speed,attack,defense = 0
		
		if stats["stat"]["name"] == "hp"
			pokemon.hp = stats["base_stat"]

		elsif stats["stat"]["name"] == "attack"
			pokemon.attack = stats["base_stat"]
		
		elsif stats["stat"]["name"] == "defense"
			pokemon.defense = stats["base_stat"]
		
		else stats["stat"]["name"] == "speed"
			pokemon.speed = stats["base_stat"]
		end
	end
	pokemon
end	

def pokemon_type_setter(pokemon, stat_data)
	if stat_data["types"].length == 1
		pokemon.element = stat_data["types"][0]["type"]["name"]
	else
		stat_data["types"].each_with_index do |types, idx|
			if idx == 0
				pokemon.element = types["type"]["name"]
			end
			if idx == 1
				pokemon.element += "/"+types["type"]["name"]
			end
		end

	end
end

def create_pokemon(pokemon_data)
	new_pokemon = Pokemon.new(name:pokemon_data["name"], total:0) 
	#sets pokemon stats
	pokemon_stat_setter(new_pokemon, pokemon_data)
	#totals stats for total power of pokemon
	new_pokemon.total = new_pokemon.hp + new_pokemon.attack + new_pokemon.defense + new_pokemon.speed
	##sets pokemon type
	pokemon_type_setter(new_pokemon, pokemon_data)
	# Save Pokemon to database
	new_pokemon.save()
end

def pokemon_database_runner
	pokemon_results_arr = pokemon_api_caller

	pokemon_results_arr.each do |pokemon|
		poke = create_pokemon(pokemon_url_caller(pokemon["url"]))
	end
end

pokemon_database_runner
binding.pry
