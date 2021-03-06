if @reservation.errors.empty?
  json.partial! 'reservation', reservation: @reservation
else
  json.errors do
    @reservation.errors.each do |attribute, errors|
      json.set! attribute do
        json.messages @reservation.errors.full_messages_for(attribute)
      end
    end
  end
end
