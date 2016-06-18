require 'rails_helper'

TEST_RUN_ID = SecureRandom.uuid

describe 'echo endpoint' do
  it "echos the post" do
    post "/projects", project: {
      name: 'purple', address: "413 N Railroad Ave", city: "Loveland", state: "CO", zip: "80537"
    }

    JSON.parse(response.body).tap do |response_json|
      expect(response_json).to have_key 'name'
      expect(response_json).to have_key 'address'
      expect(response_json).to have_key 'city'
      expect(response_json).to have_key 'state'
      expect(response_json).to have_key 'zip'
    end
  end

  it "adds a unique id" do
    post "/projects", project: {
      name: 'purple', address: "413 N Railroad Ave", city: "Loveland", state: "CO", zip: "80537"
    }

    JSON.parse(response.body).tap do |response_json|
      expect(response_json).to have_key 'id'
      expect(response_json['id']).to eq Echoable.last.id
    end
  end

  it "works when I do random weird things" do
    post "/colors", color: {
      name: 'purple', combined_from: ['red', 'blue']
    }

    JSON.parse(response.body).tap do |response_json|
      expect(response_json).to have_key 'combined_from'
      expect(response_json).to have_key 'name'
      expect(response_json['combined_from']).to eq ['red', 'blue']
      expect(response_json['name']).to eq 'purple'
    end
  end

  it 'gets an echo' do
    echoable = Echoable.new name: 'color', data: {name: 'green', combined_from: ['yellow', 'blue']}

    echoable.save!

    get "/colors/#{echoable.id}"

    JSON.parse(response.body).tap do |response_json|
      expect(response_json).to have_key 'id'
      expect(response_json).to have_key 'name'
      expect(response_json).to have_key 'combined_from'

      expect(response_json['combined_from']).to eq ['yellow', 'blue']
      expect(response_json['name']).to eq 'green'
    end
  end

  it "gets echos" do
    green_echoable = Echoable.new(name: 'color', data: {name: 'green', combined_from: ['yellow', 'blue']})

    echoables = [
      green_echoable,
      Echoable.new(name: 'color', data: {name: 'pink', combined_from: ['red', 'white']}),
      Echoable.new(name: 'color', data: {name: 'purple', combined_from: ['red', 'blue']}),
      Echoable.new(name: 'color', data: {name: 'orange', combined_from: ['yellow', 'red']})
    ]

    echoables.each(&:save!)

    get "/colors"

    JSON.parse(response.body).tap do |response_set|
      response_set.each do |response_json|
        expect(response_json).to have_key 'id'
        expect(response_json).to have_key 'name'
        expect(response_json).to have_key 'combined_from'
      end

      green_reponse = response_set.find {|rj| rj['name'] == 'green' }

      expect(green_reponse['combined_from']).to eq ['yellow', 'blue']
      expect(green_reponse['id']).to eq green_echoable.id
    end
  end

  it 'deletes an echo' do
    echoable = Echoable.new name: 'color', data: {name: 'green', combined_from: ['yellow', 'blue']}

    echoable.save!

    expect { delete "/color/#{echoable.id}" }.to change { Echoable.count }.by -1
  end

  it 'updates an echo' do
    echoable = Echoable.new name: 'color', data: {name: 'green', combined_from: ['yellow', 'blue']}

    echoable.save!

    updated_echoable = {color: { name: 'orange', combined_from: ['yellow', 'red'] }}

    patch "/colors/#{echoable.id}", updated_echoable

    JSON.parse(response.body).tap do |response_json|
      expect(response_json).to have_key 'id'
      expect(response_json).to have_key 'name'
      expect(response_json).to have_key 'combined_from'

      expect(response_json['combined_from']).to eq ['yellow', 'red']
      expect(response_json['name']).to eq 'orange'
    end
  end

  it 'deletes a class' do
    green_echoable = Echoable.new(name: 'color', data: {name: 'green', combined_from: ['yellow', 'blue']})

    echoables = [
      green_echoable,
      Echoable.new(name: 'color', data: {name: 'pink', combined_from: ['red', 'white']}),
      Echoable.new(name: 'color', data: {name: 'purple', combined_from: ['red', 'blue']}),
      Echoable.new(name: 'color', data: {name: 'orange', combined_from: ['yellow', 'red']})
    ]

    echoables.each(&:save!)

    expect { delete '/colors' }.to change { Echoable.count }.to 0
  end

  it 'deletes items created in the same session' do

    green_echoable = Echoable.new(name: 'color', data: {name: 'green', combined_from: ['yellow', 'blue']})

    echoables = [
      green_echoable,
      Echoable.new(name: 'color', data: {name: 'pink', combined_from: ['red', 'white']}),
      Echoable.new(name: 'color', data: {name: 'purple', combined_from: ['red', 'blue']}),
      Echoable.new(name: 'color', data: {name: 'orange', combined_from: ['yellow', 'red']})
    ]

    echoables.each do |echoable|
      post "/#{echoable.name}", echoable.data, { 'REQUEST_SESSION' => TEST_RUN_ID }
    end

    expect(Echoable.count).to eq echoables.count

    expect do
      delete "/session", {}, { 'REQUEST_SESSION' => TEST_RUN_ID }

      expect(response.body).to eq 'SESSION REMOVED'
    end.to change { echoables.count }.to 0

  end
end
