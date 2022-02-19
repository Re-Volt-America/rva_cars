# frozen_string_literal: true

TIME = Time.now

module RVACars
  NAME = 'rva_cars'
  DESCRIPTION = "Re-Volt America's Cars Pack"
  VERSION = "#{TIME.year.digits[0]}#{TIME.year.digits[1]}.#{TIME.month}#{TIME.day}"
  URL = 'https://distribute.revolt-america.com/rva/rva_cars.zip'
end
