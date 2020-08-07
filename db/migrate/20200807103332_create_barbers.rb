class CreateBarbers < ActiveRecord::Migration[6.0]

  def change
    create_table :barbers do |b|
      b.text :name

      b.timestamps
  end

  Barber.create :name => 'Jessie Pinkman'
  Barber.create :name => 'Walter White'
  Barber.create :name => 'Gus Fring'

end
