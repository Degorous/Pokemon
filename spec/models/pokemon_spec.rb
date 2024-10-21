require 'rails_helper'

describe 'Pokemon' do
  context '.all' do
    it 'deve listar todos os pokemons' do
      json_data = Rails.root.join('spec/support/json/pokemons.json').read
      fake_response = double('faraday_response', status: 200, body: json_data)
      allow(Faraday).to receive(:get).with('https://pokeapi.co/api/v2/pokemon?limit=386&offset=0').and_return(fake_response)

      result = Pokemon.all

      expect(result.size).to eq 3
      expect(result[0][:id]).to eq 1
      expect(result[0][:name]).to eq 'bulbasaur'
      expect(result[1][:id]).to eq 2
      expect(result[1][:name]).to eq 'ivysaur'
      expect(result[2][:id]).to eq 3
      expect(result[2][:name]).to eq 'venusaur'
    end

    it 'gera erro quando não for possível conectar a API' do
      allow(Faraday).to receive(:get).with('https://pokeapi.co/api/v2/pokemon?limit=386&offset=0').and_raise(Faraday::ConnectionFailed)

      expect { Pokemon.all }.to raise_error(PokemonConnectionError)
    end
  end

  context '.find' do
    context 'deve receber um id' do
      it 'e retornar um pokemon' do
        json_data = Rails.root.join('spec/support/json/pokemon.json').read
        fake_response = double('faraday_response', status: 200, body: json_data)
        allow(Faraday).to receive(:get).with('https://pokeapi.co/api/v2/pokemon/1').and_return(fake_response)

        result = Pokemon.find(1)

        expect(result.name).to eq 'bulbasaur'
        expect(result.id).to eq 1
        expect(result.height).to eq 7
        expect(result.weight).to eq 69
      end

      it 'gera erro quando não for possível conectar a API' do
        allow(Faraday).to receive(:get).with('https://pokeapi.co/api/v2/pokemon/1').and_raise(Faraday::ConnectionFailed)

        expect { Pokemon.find(1) }.to raise_error(PokemonConnectionError)
      end
    end
  end
end