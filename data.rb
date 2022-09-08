# frozen_string_literal: true

module RVACars
  NAME = 'rva_cars'
  DESCRIPTION = "Re-Volt America's Cars Pack"
  YEAR = 22
  MONTH = 8
  DAY = 17
  REVISION = 2
  SUFFIX = 'a'
  VERSION = "#{YEAR}.#{MONTH < 10 ? "0#{MONTH}" : MONTH}#{DAY}#{SUFFIX}-#{REVISION}"
  URL = 'https://distribute.revolt-america.com/rva/rva_cars.zip'
end
