require 'pry'

class Hotel
  attr_reader :rooms, :reservations, :blocks
  def initialize
    @rooms = []
    set_up_rooms(20)
    @reservations = []
    @blocks = []
  end

  def set_up_rooms(number_of_rooms)
    number_of_rooms.times do |i|
      @rooms << Room.new(i + 1, 200)
    end
  end

  def room_list
    return @rooms
  end

  def make_reservation(start_date, end_date, room_number)
    check_availability(start_date, end_date, room_number)
    room = find_room_by_number(room_number)
    new_reservation = Reservation.new(start_date, end_date, room)
    @reservations << new_reservation
    add_reservation_to_room(room, new_reservation)
    return new_reservation
  end

  def create_room_block(start_date, end_date, room_number_list, discounted_rate, block_code)
    room_number_list.each do |room_number|
      check_availability(start_date, end_date, room_number)
    end
    room_list = convert_numbers_to_rooms(room_number_list)
    new_reservation = BlockReservation.new(start_date, end_date, room_list, discounted_rate, block_code)
    @blocks << new_reservation
    room_list.each do |room|
      add_reservation_to_room(room, new_reservation)
    end
    return new_reservation
  end

  def convert_numbers_to_rooms(room_number_list)
    room_list = []
    room_number_list.each do |room_number|
      room_list << find_room_by_number(room_number)
    end
    return room_list
  end

  def check_availability(start_date, end_date, room_number)
    available_room_list = find_available_rooms(start_date, end_date)
    raise ArgumentError, 'Room not available' unless available_room_list.include?(room_number)
  end

  def find_room_by_number(number)
    room_list.find {|room| room.room_number == number}
  end

  def add_reservation_to_room(room, reservation)
    room.reservations << reservation
  end

  def find_reservations_by_date(date)
    @reservations.select {|reservation| reservation.checkin_date <= date && reservation.checkout_date >= date}
  end

  def find_available_rooms(start_date, end_date)
    available_room_numbers = []
    room_list.each do |room|
      room_is_available = true
      (start_date..end_date).each do |date|
        if !room.is_available?(date)
          room_is_available = false
        end
      end
      available_room_numbers << room.room_number if room_is_available
    end
    return available_room_numbers
  end
end
