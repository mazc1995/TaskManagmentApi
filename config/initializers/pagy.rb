# Pagy initializer file
# Customize as you see fit

require 'pagy/extras/metadata'
require 'pagy/extras/headers'

Pagy::DEFAULT[:items] = 10        # items per page
Pagy::DEFAULT[:size]  = [1,4,4,1] # nav bar links
# Better user experience handled automatically
Pagy::DEFAULT[:overflow] = :empty_page 