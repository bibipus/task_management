require 'pagy'
require 'pagy/extras/limit'
require 'pagy/extras/bootstrap'
require 'pagy/extras/overflow'

Pagy::DEFAULT[:limit] = 2
Pagy::DEFAULT[:overflow] = :empty_page
