class Pokemon
  attr_accessor :id, :name, :height, :weight

  def initialize(id:, name:, height:, weight:)
    @id = id
    @name = name
    @height = height
    @weight = weight
  end

  def self.all
    response = Faraday.get('https://pokeapi.co/api/v2/pokemon?limit=386&offset=0')
    pokemons = []

    if response.status == 200
      data = JSON.parse(response.body)
      pokemons = build_all_pokemons(data)
    end
    pokemons
  rescue Faraday::ConnectionFailed
    raise PokemonConnectionError
  end

  def self.find(id)
    response = Faraday.get("https://pokeapi.co/api/v2/pokemon/#{id}")

    return unless response.status == 200
    
    data = JSON.parse(response.body).slice('name', 'id','height', 'weight')
    
    build_pokemon(data)
  rescue Faraday::ConnectionFailed
    raise PokemonConnectionError
  end

  class << self
    private

    def build_pokemon(data)
      Pokemon.new(id: data['id'], name: data['name'], height: data['height'], weight: data['weight'])
    end

    def build_all_pokemons(data)

      pokemons_list = data['results']
      pokemons_list.map {|pokemon| {id: pokemon['url'].split('/').last.to_i, name: pokemon['name']}}
    end
  end
end